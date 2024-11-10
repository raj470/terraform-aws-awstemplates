import json
import boto3
from datetime import datetime, timedelta, timezone
def get_last_modified(object):
    return int(object['LastModified'].strftime('%s'))
def lambda_handler(event, context):
    S3 = boto3.client('s3')
    list_bucket = S3.list_buckets()
    for bucket in list_bucket['Buckets']:
        print(bucket['Name'])
    list_objects = S3.list_objects_v2(Bucket='bucket123cross')
    utc_minus_4 = timezone(timedelta(hours=-4))
    # for object in list_objects['Contents']:
    #     print(object['Key'])
    last_modified = S3.list_objects_v2(Bucket='bucket123cross')
    # for object in list_objects['Contents']:
    #     print(object['LastModified'])
    if 'Contents' in last_modified:
        for object in last_modified['Contents']:
            print(bucket['Name']+" "+object['Key'] + " " + object['LastModified'].astimezone(utc_minus_4).strftime('%Y-%m-%d %H:%M:%S %Z'))