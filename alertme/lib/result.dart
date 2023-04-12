import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DomainReputationChecker extends StatefulWidget {
  const DomainReputationChecker({Key? key}) : super(key: key);
  @override
  
  _DomainReputationCheckerState createState() =>
      _DomainReputationCheckerState();
}

class _DomainReputationCheckerState extends State<DomainReputationChecker> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _domainController;

  @override
  void initState() {
    super.initState();
    _domainController = TextEditingController();
  }

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  void _checkReputation() async {
    final domain = _domainController.text;
    final url = Uri.parse('http://127.0.0.1:5000/');
    final response = await http.post(url, body: {'domain': domain});
    if (response.statusCode == 200) {
      final reputation = response.body;
      // Do something with reputation
    } else {
      throw Exception('Failed to check reputation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Domain Reputation Checker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter a domain:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _domainController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'example.com',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a domain';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _checkReputation();
                  }
                },
                child: Text('Check Reputation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
