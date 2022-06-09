import json
import boto3
import logging
from os import environ
from botocore.exceptions import ClientError

region = environ["region"]
queue_url = environ["queueURL"]
bucket = environ["bucketName"]
object_prefix = environ["processedPrefix"]

s3 = boto3.client("s3", region_name=region)
sqs = boto3.client("sqs", region_name=region)

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def ndjson(file_object):
    """Splits NDJSON file file_object JSON array"""

    ndjson_content = file_object["Body"].read().decode("utf-8")
    result = []

    for ndjson_line in ndjson_content.splitlines():
        if not ndjson_line.strip():
            continue  # ignore empty lines
        json_line = json.loads(ndjson_line)
        result.append(json_line)

    return result


def lambda_handler(event, context):
    """Lambda Handler"""

    logger.info(f"Event data - {event}")
    data = event["Records"][0]["body"].strip('"').split("/")[-1]

    message_info = [
        dict(
            zip(
                ("Id", "ReceiptHandle"),
                (items["messageId"].strip('"'), items["receiptHandle"]),
            )
        )
        for items in event["Records"]
    ]

    try:
        file_object = s3.get_object(Bucket=bucket, Key=data)
    except ClientError as e:
        logger.error(f"An error occured while accesing S3 object - {e}")
        raise e
    else:
        json_array = ndjson(file_object)
        new_data = {"Content": json_array}

        try:
            response = s3.put_object(
                Body=str(json.dumps(new_data)),
                Bucket=bucket,
                Key=f"{object_prefix}/{data}",
            )
        except ClientError as e:
            logger.error(f"An error occured while object the file - {e}")
            logger.error(f"Response from AWS API - {response}")
            raise e

        try:
            response = sqs.delete_message_batch(
                QueueURL=queue_url, Entries=message_info
            )
        except ClientError as e:
            logger.error("An error occured while deleting the messages from the queue.")
            logger.error(f"More details - {e}")
            logger.error(f"Response from AWS API - {response}")
            raise e
        else:
            if response["Failed"]:
                logger.error(
                    f'A list of messages failed to delete - {response["Failed"]}'
                )
