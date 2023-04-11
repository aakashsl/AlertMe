from flask import Flask, request, jsonify
import re
from flask_cors import CORS, cross_origin

app = Flask(__name__)

@app.route('/')
def welcome():
    return "welcome to the backend"

@cross_origin()
@app.route('/detect-spam-sms', methods=['POST'])
def detect_spam_sms():
    headers = request.json['headers']
    result = is_spam_sms(headers)
    return jsonify({'is_spam': result})

def is_spam_sms(headers):
    # Check for common spam keywords in the headers
    keywords = ['win', 'free', 'prize', 'offer', 'congratulations']
    for keyword in keywords:
        if keyword in headers.lower():
            return True
    
    # Check for suspicious sender IDs
    sender_id = re.search(r'Sender: (.+)', headers)
    if sender_id:
        sender_id = sender_id.group(1).strip()
        if sender_id.isdigit() or sender_id.lower().startswith('text'):
            return True
    
    # Check for shortcodes, which are often used for spam
    shortcode = re.search(r'SMSC: Shortcode=(\d+)', headers)
    if shortcode:
        return True
    
    # Check for multiple recipients, which can indicate a spam campaign
    recipients = re.search(r'To: (.+)', headers)
    if recipients:
        recipients = recipients.group(1).strip()
        if ',' in recipients or ';' in recipients:
            return True
    
    return False

@app.after_request
def after_request_func(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Credentials', 'true')
    response.headers.add('Access-Control-Allow-Headers', 'Origin, Content-Type, Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET, PUT, POST, DELETE, OPTIONS')
    return response

if __name__ == '__main__':
    app.run(debug=True)
