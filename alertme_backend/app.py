from flask import Flask, request, jsonify
import re
import whois
import ssl
import requests


app = Flask(__name__)

@app.route('/detect-spam-sms', methods=['POST'])
def detect_spam_sms():
    headers = request.json['headers']
    print (headers)
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
        print (recipients)
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

@app.route('/check_domain_reputation')
def check_domain_reputation():
    domain = request.args.get('domain')
    is_trustworthy = True
    message = ''

    # Check WHOIS data
    domain_info = whois.whois(domain)
    if domain_info.creation_date is not None:
        domain_age = (datetime.now() - domain_info.creation_date).days
        if domain_age < 30:
            is_trustworthy = False
            message = 'Domain is too new.'

    # Check SSL certificate
    try:
        ssl_info = ssl.get_server_certificate((domain, 443))
        x509 = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_PEM, ssl_info)
        if x509.has_expired():
            is_trustworthy = False
            message = 'SSL certificate has expired.'
    except Exception as e:
        is_trustworthy = False
        message = 'Failed to check SSL certificate: {}'.format(str(e))

    # Check blacklists
    blacklists = ['https://www.spamhaus.org/lookup/', 'https://transparencyreport.google.com/safe-browsing/search', ...]
    for blacklist in blacklists:
        api_endpoint = '{}{}'.format(blacklist, domain)
        response = requests.get(api_endpoint)
        if response.status_code == 200 and 'not listed' not in response.text:
            is_trustworthy = False
            message = 'Domain is blacklisted on {}.'.format(blacklist)

    return jsonify({'isTrustworthy': is_trustworthy, 'message': message})


if __name__ == '__main__':
    app.run(debug=True)
