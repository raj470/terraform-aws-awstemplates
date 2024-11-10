import json
import boto3
from datetime import datetime, timedelta, timezone
def lambda_handler(event, context):
    S3 = boto3.client('s3')
    list_bucket = S3.list_buckets()
    bucket_name = "bucket123cross"
    utc_minus_4 = timezone(timedelta(hours=-4))
    if 'Contents' in last_modified:
        for object in last_modified['Contents']:
            last_modified = object['LastModified'].astimezone(utc_minus_4)
            folder_name = last_modified.strftime("%Y-%m-%d %H:%M:%S %Z")
            new_key = f"{folder_name}/{object['Key'].split('/')[-1]}"  
            S3.copy_object(
                Bucket=bucket_name,
                CopySource={'Bucket': bucket_name, 'Key': object['Key']},
                Key=new_key
            )