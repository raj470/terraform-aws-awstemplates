aws ecr get-login-password \
    --region <region> \
| docker login \
    --username AWS \
    --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com

aws ecr get-login-password \
    --region us-east-1 \
| docker login \
    --username AWS \
    --password-stdin 058264186519.dkr.ecr.us-east-1.amazonaws.com


docker tag hello-world:latest aws_account_id.dkr.ecr.region.amazonaws.com/hello-repository



1. Go to the Amazon CloudWatch console
2. Click on 'Log groups' in the left navigation pane
3. Find the log group '/ecs/Apache' and click on it
4. Check if the log stream 'ecs/Apache1/408a6ecc52784351b8da42457408e2d6' exists
    - If it does not exist, the ECS task logs are not being sent to CloudWatch for some reason
    - Verify the ECS task definition has the 'awslogs' log driver configured correctly to send logs to the '/ecs/Apache' log group
    - Check the ECS task container logs for any errors related to the 'awslogs' log driver
5. If the log stream exists but has no log data:
    - Check the ECS task status and container status for any errors
    - Ensure the application running in the container is writing logs to stdout/stderr
6. If you don't have permissions to view the log group or modify the ECS task/service, contact your AWS administrator



1. Go to the 'Task Definition' configuration page in the ECS console
2. In the 'Log Configuration' section, select a different log driver that supports creating custom log groups, such as 'Splunk' or 'Fluentd'
3. If you still want to use the 'awslogs' driver, remove the 'awslogs-create-group' option as it is not supported
4. Review and update any other log configuration options as needed
5. Save the Task Definition configuration



# define the name of the stream you want to read
KINESIS_STREAM_NAME='__your_stream_name_goes_here__';

# define the shard iterator to use
SHARD_ITERATOR=$(aws kinesis get-shard-iterator --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON --stream-name $KINESIS_STREAM_NAME --query 'ShardIterator');

# read the records, use `jq` to grab the data of the first record, and base64 decode it 
aws kinesis get-records --shard-iterator $SHARD_ITERATOR | jq -r '.Records[0].Data' | base64 --decode

SHARD_ITERATOR=$(aws kinesis get-shard-iterator --shard-id shardId-000000000002 --shard-iterator-type TRIM_HORIZON --stream-name KenesisStream --query 'ShardIterator');

aws kinesis get-records --shard-iterator $SHARD_ITERATOR | jq -r '.Records[0].Data' | base64 --decode


SHARD_ITERATOR=$(aws kinesis get-shard-iterator \
  --endpoint https://yds.serverless.yandexcloud.net \
  --shard-id shardId-000000000002 \
  --shard-iterator-type LATEST \
  --stream-name  KenesisStream\
  --query 'ShardIterator'| tr -d \")
aws kinesis get-records \
  --endpoint https://yds.serverless.yandexcloud.net \
  --shard-iterator $SHARD_ITERATOR


let items = event.Records.map( (record) => {
            let jsonData = new Buffer(record.kinesis.data, 'base64').toString('ascii');



        # import json
          # import logging
          # import base64
          # # Set up logging
          # logger = logging.getLogger()
          # logger.setLevel(logging.INFO)

          # def lambda_handler(event, context):
          #     # Extract the numbers from the event
          #   # for record in event['Records']:
          #   #   payload = base64.b64decode(record['kinesis']['data']).decode('utf-8')
          #   #   data = json.loads(payload)
          #     number1 = event.get('number1')
          #     number2 = event.get('number2')
          
          #     # Log the numbers
          #     logger.info("First Number is: %s", number1)
          #     logger.info("Second Number is: %s", number2)

          #     # Ensure both numbers are provided
          #     if number1 is None or number2 is None:
          #       logger.error("Missing number1 or number2 in the event")
          #       return {
          #           'statusCode': 400,
          #           'body': json.dumps('Please provide two numbers.')
          #       }
          
          #     # Add the two numbers
          #     result = number1 + number2
          
          #     # Log the result
          #     logger.info("Sum of two numbers: %s", result)

          #     # Return the result
          #     return {
          #       'statusCode': 200,
          #       'body': json.dumps({'result': result})
          #     }

# import json

# def lambda_handler(event, context):
#     # Iterate through SQS records
#     for record in event['Records']:
#         # Extract message body from record
#         message_body = json.loads(record['body'])
        
#         # Extract numbers from message body
#         num1 = int(message_body['num1'])
#         num2 = int(message_body['num2'])
        
#         # Add the numbers
#         result = num1 + num2
        
#         # Print result (for logging purposes)
#         print(f"Sum of {num1} and {num2} is {result}")
        
#         # Optionally, you can return or process the result as needed
#         # For demonstration, constructing a response
#         response = {
#             'num1': num1,
#             'num2': num2,
#             'result': result
#         }
        
#         # Print the response (for logging purposes)
#         print(json.dumps(response))
        
#         # You can also return the response if needed
#         # return response




import json
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)  
def lambda_handler(event, context):
    sum=0
    def add(num1, num2):
        return num1 + num2
    def message_body(messages):
        nonlocal sum
        for message in messages:
            body = json.loads(message['body'])
            num1 = int(body['num1'])
            num2 = int(body['num2'])
            logging.info("First number: ",num1)
            logging.info("Second number: ",num2)
# import json
# import logging
# logger = logging.getLogger()
# logger.setLevel(logging.INFO)          
# def lambda_handler(event, context):
#     logger.info(f"Received event: {json.dumps(event)}")
#     records = event.get('Records')
#     if 'num1' in event and 'num2' in event:
#         num1 = event['num1']
#         num2 = event['num2']
#         logger.info("First Number is: %s", num1)
#         logger.info("Second Number is: %s", num2)
#         sum_result = num1 + num2
#         logger.info(f"The sum of {num1} and {num2} is: {sum_result}")
#         return {
#             'statusCode': 200,
#             'body': json.dumps(f"The sum of {num1} and {num2} is: {sum_result}")
#             }
#     elif 'Records' in event:
#         records = event['Records']
#         for record in records:
#             try:
#                 message_body = json.loads(record['body'])
#                 num1 = message_body['num1']
#                 num2 = message_body['num2']
#                 sum_result = num1 + num2
#                 logger.info(f"The sum of {num1} and {num2} is: {sum_result}")
#             except (json.JSONDecodeError, KeyError) as e:
#                 logger.error(f"Error processing message: {e}")
#                 continue
        
#         return {
#             'statusCode': 200,
#             'body': json.dumps('Processing complete')
#         }
    
#     else:
#         logger.error("'Records' key not found in event")
#         return {
#             'statusCode': 400,
#             'body': json.dumps("'Records' key not found in event")
#             }
#     # if 'Records' not in event:
#     #     logger.error("'Records' key not found in event")
#     #     return {
#     #         'statusCode': 400,
#     #         'body': json.dumps("'Records' key not found in event")
#     #       }
              
#     # for record in event['Records']:
        
#     #     message_body = record['body']
#     #     try:
#     #         msgbody = json.loads(record['body']) 
#     #         logger.info(msgbody)
#     #         data = json.loads(message_body)
#     #         num1 = data['num1']
#     #         num2 = data['num2']
#     #         sum_result = num1 + num2
#     #         logger.info(f"The sum of {num1} and {num2} is: {sum_result}")
#     #     except (json.JSONDecodeError, KeyError) as e:
#     #         logger.error(f"Error processing message: {e}")
#     #         continue
#     # return {
#     #     'statusCode': 200,
#     #     'body': json.dumps('Processing complete')
#     #     }
# # import json
# # import logging
# # logger = logging.getLogger()
# # logger.setLevel(logging.INFO)
# # def lambda_handler(event, context):
# #     # Process each SQS message
# #     for record in event['Records']:
# #         # Get the message body
# #       logger.info(f"Received event: {json.dumps(event)}")
# #       message_body = record['body']
        
# #         # Parse the message body as JSON
# #       try:
# #           data = json.loads(message_body)
# #           num1 = data['num1']
# #           num2 = data['num2']
# #           print("First number : ",num1)
# #           print("Seconf number : ", num2)
# #             # Add the numbers
# #           sum_result = num1 + num2
            
# #             # Print the result (or log it, or store it as needed)
# #           print(f"The sum of {num1} and {num2} is: {sum_result}")
        
# #       except (json.JSONDecodeError, KeyError) as e:
# #           print(f"Error processing message: {e}")
# #           continue

# #     return {
# #         'statusCode': 200,
# #         'body': json.dumps('Processing complete')
# #     }

# # # import json
# # # import base64
# # # import logging
# # # logger = logging.getLogger()
# # # logger.setLevel(logging.INFO)
# # # def lambda_handler(event, context):
# # #   total_sum = 0

# # #   # Function to add two numbers
# # #   def add_numbers(num1, num2):
# # #     return num1 + num2

# # #   # Function to process Kinesis records
# # #   def process_records(records):
# # #     nonlocal total_sum
# # #     logger.info(f"Received event: {json.dumps(event)}")
# # #     results = []
# # #               # Check if the event is from SQS
# # #     if 'Records' in event:
# # #       # Process SQS messages
# # #       for record in event['Records']:
# # #     # for record in records:
# # #     #   # Decode the record data from base64
# # #     #   data = base64.b64decode(record['kinesis']['data']).decode('utf-8')
  
# # #     # # Parse the data (assuming the data is in JSON format)
# # #     #   message = json.loads(data)
  
# # #       # Get the two numbers from the message
# # #         logger.info(f"Processing record: {json.dumps(record)}")
# # #                           # Extract and parse the SQS message body
# # #         body = json.loads(record['body'])
# # #         # num1 = message.get('number1', 0)
# # #         # num2 = message.get('number2', 0)
# # #         num1 = float(body['num1', ])
# # #         num2 = float(body['num2', 0])
# # #         logger.info("First Number is: %s", num1)
# # #         logger.info("Second Number is: %s", num2)
# # #         #Ensure both numbers are provided
# # #         if num1 is None or num2 is None:
# # #           logger.error("Missing num1 or num2 in the event")
# # #           return {
# # #             'statusCode': 400,
# # #             'body': json.dumps('Please provide two numbers.')
# # #           }
# # #       # Add the numbers
# # #         result = add_numbers(num1, num2)
  
# # #       # Update total sum
# # #         total_sum += result
# # #         logger.info("Sum of two numbers: %s", total_sum)
# # #     # Process records from Kinesis event
# # #     if 'Records' in event:
# # #       process_records(event['Records'])

# # #     # Return the total sum
# # #       return {
# # #       'statusCode': 200,
# # #       'body': json.dumps({
# # #         'total_sum': total_sum
# # #       })
# # #         }


# # # # import json
# # # # import logging
# # # # logger = logging.getLogger()
# # # # logger.setLevel(logging.INFO)
# # # # def lambda_handler(event, context):
# # # #   logger.info(f"Received event: {json.dumps(event)}")
# # # #   results = []
# # # #   if 'Records' in event:
# # # #                   # Process SQS messages
# # # #       for record in event['Records']:
# # # #           try:
# # # #               logger.info(f"Processing record: {json.dumps(record)}")
# # # #               body = json.loads(record['body'])
# # # #               num1 = float(body['num1'])
# # # #               num2 = float(body['num2'])

# # # #                           # Function to add two numbers
# # # #               add_numbers = lambda num1, num2: num1 + num2

# # # #                           # Adding numbers
# # # #               sum_result = add_numbers(num1, num2)

# # # #               results.append({
# # # #                 'num1': num1,
# # # #                 'num2': num2,
# # # #                 'sum': sum_result
# # # #                 })
# # # #           except Exception as e:
# # # #             logger.error(f"Error processing record: {e}")
# # # #   else:
# # # #                   # Assume direct invocation
# # # #       try:
# # # #         num1 = float(event['num1'])
# # # #         num2 = float(event['num2'])

# # # #                       # Function to add two numbers
# # # #         add_numbers = lambda num1, num2: num1 + num2

# # # #                       # Adding numbers
# # # #         sum_result = add_numbers(num1, num2)

# # # #         results.append({
# # # #             'num1': num1,
# # # #             'num2': num2,
# # # #             'sum': sum_result
# # # #             })
# # # #       except Exception as e:
# # # #         logger.error(f"Error processing direct invocation: {e}")

# # # #               # Returning the results
# # # #   return {
# # # #       'statusCode': 200,
# # # #       'body': json.dumps(results)
# # # #       }
# # # #   # # for record in event.get('Records'):
# # # #   # #   logger.info(f"Processing record: {json.dumps(record)}")
# # # #   # #   body = json.loads(record['body'])
# # # #   # #   num2 = int(body['num2',0])
# # # #   # #   logger.info("init Second Number is: %s", num2)
# # # #   # # Extracting messages from the event payload
# # # #   # for record in event.get('Records', []):
# # # #   #   try:
# # # #   #       logger.info(f"Processing record: {json.dumps(record)}")
# # # #   #       body = json.loads(record['body'])
# # # #   #       logger.info(f"Received event: {json.dumps(event)}")
# # # #   #       num1 = float(body['num1'])
# # # #   #       num2 = float(body['num2'])
# # # #   #       # Function to add two numbers
# # # #   #       logger.info("Second Number is: %s", num2)
# # # #   #       add_numbers = num1 + num2 #lambda num1, num2: num1 + num2
# # # #   #                     # Adding numbers
# # # #   #       sum_result = add_numbers(num1, num2)
# # # #   #       results.append({
# # # #   #         'num1': num1,
# # # #   #         'num2': num2,
# # # #   #         'sum': sum_result
# # # #   #       })
# # # #   #   except Exception as e:
# # # #   #       logger.error(f"Error processing record: {e}")
# # # #   #             # Returning the results
# # # #         # return {
# # # #         #   'statusCode': 200,
# # # #         #   'body': json.dumps(results)
# # # #         # }
# # # # # import json
# # # # # import logging
# # # # # logger = logging.getLogger()
# # # # # logger.setLevel(logging.INFO)
# # # # # def lambda_handler(event, context):
# # # # #     results = []

# # # # #               # Extracting messages from the event payload
# # # # #     for record in event.get('Records', []):
# # # # #       body = json.loads(record['body'])# messages = event['Records']
# # # # #     # results = []

# # # # #     # for message in messages:
# # # # #     #   body = json.loads(message['body'])
# # # # #       num1 = int(body['num1', 0])
# # # # #       num2 = int(body['num2', 0])
# # # # #       print("First Number is: %s", num1)
# # # # #       logger.info("First Number is: %s", num1)
# # # # #       logger.info("Second Number is: %s", num2)
# # # # #       add_numbers = lambda num1, num2: num1 + num2
# # # # #       sum_result = add_numbers(num1, num2)
# # # # #       logger.info("Sum of two numbers: %s", sum_result)
# # # # #       results.append({
# # # # #         'num1': num1,
# # # # #         'num2': num2,
# # # # #         'sum': sum_result
# # # # #         })
# # # # #     return {
# # # # #       'statusCode': 200,
# # # # #       'body': json.dumps({
# # # # #         'results':results
# # # # #       })
# # # # #         }