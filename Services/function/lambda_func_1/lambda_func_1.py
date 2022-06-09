import json
import logging
import boto3
from os import environ
from botocore.exceptions import ClientError

queue_name = environ["queueName"]
queue_url = environ["queueURL"]

sqs = boto3.client("sqs", region_name="ap-south-1")

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def send_sqs_message(queue, body):
    """Send filename as SQS message"""

    try:
        response = sqs.send_message(QueueUrl=queue_url, MessageBody=json.dumps(body))
    except ClientError as e:
        print(e)
        logging.error(f"Error during invoking AWS API for SQS - {e}")

    return response


def lambda_handler(event, context):
    """Lambda handler function"""

    logger.info(f"Event data - {event}")

    object = str(event["Records"][0]["s3"]["object"]["key"])
    msg = send_sqs_message(queue_name, object)

    if msg:
        logger.info("Response form SQS API - {msg}")
        logger.info(f'SQS message ID: {msg["MessageId"]}')

    return {"statusCode": 200, "body": json.dumps(event)}
