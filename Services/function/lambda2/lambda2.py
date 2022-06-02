import json
import boto3
def lambda_handler(event, context):
    s3 = boto3.client("s3")
    if event:
        print("Event:  ", event)
        data = json.loads(event["Records"][0]["body"])
        print("Data : ", data)
        fileObj = s3.get_object(Bucket='read-csv-s3', Key=data)
        ndjson_content = fileObj["Body"].read().decode('utf-8')
        print(ndjson_content)
        result = []
        for ndjson_line in ndjson_content.splitlines():
            print("Conerting ndjson to json")
            if not ndjson_line.strip():
               continue  # ignore empty lines
            json_line = json.loads(ndjson_line)
            result.append(json_line)
        print("Result: ", result) 