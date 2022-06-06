import json
import logging
import boto3
from os import environ
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def send_sqs_message(queue, body):
    """Send filename as SQS message"""
    sqs = boto3.client("sqs", region_name="ap-south-1")

    sqs_queue_url = sqs.get_queue_url(QueueName=queue)
    queue_url = sqs_queue_url["QueueUrl"]
    logger.info(f"Queue URL - {queue_url}")

    try:
        response = sqs.send_message(QueueUrl=queue_url, MessageBody=json.dumps(body))
    except ClientError as e:
        print(e)
        logging.error(f"Error during invoking AWS API for SQS - {e}")

    return response


def lambda_handler(event, context):
    """Lambda handler function"""
    queue = environ["queue-name"]

    if event:
        logger.info(f"Event data - {event}")

        object = str(event["Records"][0]["s3"]["object"]["key"])
        msg = send_sqs_message(queue, object)

        if msg:
            logger.info("Response form SQS API - {msg}")
            logger.info(f'SQS message ID: {msg["MessageId"]}')

        return {"statusCode": 200, "body": json.dumps(event)}
