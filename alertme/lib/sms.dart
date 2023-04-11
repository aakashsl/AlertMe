import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class SpamDetectorPage extends StatefulWidget {
  static const routeName = "SMS";
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
              onPressed: () {
                sendPostRequest(_headersController.text);
              },
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

  Future<void> sendPostRequest(headers) async {
    final url = Uri.parse('https://example.com/api/post');

    final body = {'headers': headers};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      // Handle success response
      print('Post request successful');
    } else {
      // Handle error response
      print('Post request failed with status: ${response.statusCode}');
    }
  }
}
