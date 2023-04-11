import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpamDetectorPage extends StatefulWidget {
  static const routeName="SMS";
  @override
  _SpamDetectorPageState createState() => _SpamDetectorPageState();
}



class _SpamDetectorPageState extends State<SpamDetectorPage> {
  final _headersController = TextEditingController();
   bool _isSpam = false;



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
                labelText: 'SMS Headers',
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
            
          ],
        ),
      ),
    );
  }

  Future<void> _detectSpamSMS() async {
    final headers = _headersController.text;
    final url = 'http://127.0.0.1:5000/detect-spam-sms';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'headers': headers}),
   headers: {'Content-Type': 'application/json'},
    );
    final result = jsonDecode(response.body);
    debugPrint(result);
    setState(() {
      _isSpam = result;
    });
  }
}
