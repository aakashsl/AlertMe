import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpamDetectorPage extends StatefulWidget {
  @override
  static const routeName = "SMS";
  _SpamDetectorPageState createState() => _SpamDetectorPageState();
}

class _SpamDetectorPageState extends State<SpamDetectorPage> {
  final _headersController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSpam = false;
  String _notSpamMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Spam Detector'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _headersController,
              decoration: InputDecoration(
                labelText: 'SMS Message',
                hintText: 'Enter the headers of the SMS message',
              ),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _detectSpamSMS,
              child: Text('Detect Spam'),
            ),
            SizedBox(height: 16),
            if (_isSpam)
              Text(
                'This SMS message is spam',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
             !_isSpam && _headersController.text.length>0?
              Text(
                'Not spam message',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ):Text(""),
              _headersController.text.length==0?
              Text(
                'Enter Message here',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 213, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ):Text(""),
          ],
        ),
      ),
    );
  }
  Future<void> _detectSpamSMS() async {
    final headers = _headersController.text;
    final url = 'https://alertme.pythonanywhere.com/detect-spam-sms';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'headers': headers}),
      headers: {'Content-Type': 'application/json'},
    );
    final result = jsonDecode(response.body);
    setState(() {
      _isSpam = result['is_spam'];
    });
  }
}
