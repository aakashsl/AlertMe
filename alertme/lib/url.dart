import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DomainReputationChecker extends StatefulWidget {
  final String domain;

  DomainReputationChecker({Key? key, required this.domain}) : super(key: key);
  static const routeName = "URL";
  @override
  _DomainReputationCheckerState createState() => _DomainReputationCheckerState();
}

class _DomainReputationCheckerState extends State<DomainReputationChecker> {
  bool _isTrustworthy = false;

  @override
  void initState() {
    super.initState();
    _checkDomainReputation();
  }

  Future<void> _checkDomainReputation() async {
    final apiEndpoint = 'http://localhost:5000/check_domain_reputation?domain=${widget.domain}';
    final response = await http.get(Uri.parse(apiEndpoint));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _isTrustworthy = json['isTrustworthy'];
      });
    } else {
      // Handle error case
      print('Failed to check domain reputation: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_isTrustworthy ? 'This domain is trustworthy.' : 'This domain is not trustworthy.');
  }
}
