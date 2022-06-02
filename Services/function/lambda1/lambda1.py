import json
import boto3
def send_sqs_message(QueueName, msg_body):
    # Send the SQS message
    sqs_client = boto3.client('sqs')
    sqs_queue_url = sqs_client.get_queue_url(QueueName=QueueName)['QueueUrl']
    try:
        msg = sqs_client.send_message(QueueUrl=sqs_queue_url,MessageBody=json.dumps(msg_body))
    except ClientError as e:
        return None
    return msg
def lambda_handler(event, context):
    s3 = boto3.client("s3")
    if event:
        print("Event:", event)
        file_obj = event["Records"][0]
        print(file_obj)
        filename = str(file_obj['s3']['object']['key'])
        print("Filename:", filename)
        QueueName = 'read-file-s3'
        msg = send_sqs_message(QueueName,filename)
        if msg is not None:
            print(f'Sent SQS message ID: {msg["MessageId"]}')
        return {
            'statusCode': 200,
            'body': json.dumps(event)
        }
        print("Message: ", msg )