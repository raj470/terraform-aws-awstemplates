import json
import base64
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
def lambda_handler(event, context):
  total_sum = 0

  # Function to add two numbers
  def add_numbers(num1, num2):
    return num1 + num2

  # Function to process Kinesis records
  def process_records(records):
    nonlocal total_sum
    for record in records:
      # Decode the record data from base64
      data = base64.b64decode(record['kinesis']['data']).decode('utf-8')
  
     # Parse the data (assuming the data is in JSON format)
      message = json.loads(data)
  
      # Get the two numbers from the message
      num1 = message.get('number1', 0)
      num2 = message.get('number2', 0)
      logger.info("First Number is: %s", num1)
      logger.info("Second Number is: %s", num2)
      #Ensure both numbers are provided
      if num1 is None or num2 is None:
       logger.error("Missing num1 or num2 in the event")
       return {
         'statusCode': 400,
         'body': json.dumps('Please provide two numbers.')
       }
      # Add the numbers
      result = add_numbers(num1, num2)
  
      # Update total sum
      total_sum += result
      logger.info("Sum of two numbers: %s", total_sum)
    # Process records from Kinesis event
  if 'Records' in event:
    process_records(event['Records'])

    # Return the total sum
    return {
    'statusCode': 200,
    'body': json.dumps({
      'total_sum': total_sum
    })
  }




import json
import base64
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
def lambda_handler(event, context):
  total_sum = 0
  

  # Function to add two numbers
  def add_numbers(num1, num2):
    return num1 + num2

  # Function to process Kinesis records
  def process_records(records):
    nonlocal total_sum
    for record in records:
      # Decode the record data from base64
      data = base64.b64decode(record['kinesis']['data']).decode('utf-8')
  
     # Parse the data (assuming the data is in JSON format)
      message = json.loads(data)
  
      # Get the two numbers from the message
      num1 = message.get('number1', 0)
      num2 = message.get('number2', 0)
      logger.info("First Number is: %s", num1)
      logger.info("Second Number is: %s", num2)
      #Ensure both numbers are provided
      if num1 is None or num2 is None:
       logger.error("Missing num1 or num2 in the event")
       return {
         'statusCode': 400,
         'body': json.dumps('Please provide two numbers.')
       }
      # Add the numbers
      result = add_numbers(num1, num2)
  
      # Update total sum
      total_sum += result
      logger.info("Sum of two numbers: %s", total_sum)
    # Process records from Kinesis event
  if 'Records' in event:
    process_records(event['Records'])

    # Return the total sum
    return {
    'statusCode': 200,
    'body': json.dumps({
      'total_sum': total_sum
        })
      }

