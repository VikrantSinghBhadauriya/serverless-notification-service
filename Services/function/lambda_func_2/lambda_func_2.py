import json
import boto3
import logging
from os import environ
from botocore.exceptions import ClientError

s3 = boto3.client("s3")
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

    bucket = environ["bucket-name"]
    object_prefix = environ["processed-prefix"]
    data = event["Records"][0]["body"].strip('"')

    try:
        file_object = s3.get_object(Bucket=bucket, Key=data)
    except ClientError as e:
        logger.error(f"An error occured while accesing S3 object - {e}")
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
