import json
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
def lambda_handler(event, context):
    for message in event['Records']:
        process_message(message)

def process_message(message):
    try:
        print(f"Processed message {message['body']}")
        
        # Assuming message['body'] is a dictionary
        message = json.loads(message['body'])
        num1 = message.get('number1', 0)
        num2 = message.get('number2', 0)
        logger.info("First Number is: %s", num1)
        logger.info("Second Number is: %s", num2)
        if num1 is None or num2 is None:
            logger.error("Missing number1 or number2 in the event")
            return {
                'statusCode': 400,
                'body': json.dumps('Please provide two numbers.')
                }
        # Add the numbers
        # Perform addition
        result = num1 + num2
        # print(f"Sum of two numbers: {num1} + {num2} = {result}")
        logger.info("Sum of two numbers: %s", result)
        
    except Exception as err:
        print("An error occurred")
        # raise err

