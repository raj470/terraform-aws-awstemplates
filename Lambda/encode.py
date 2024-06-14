import base64
import json

data = {
    "number1": 5,
    "number2": 10
}

# Convert data to JSON string and then encode it in base64
encoded_data = base64.b64encode(json.dumps(data).encode('utf-8')).decode('utf-8')

print("Encoded data:", encoded_data)
