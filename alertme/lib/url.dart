import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MyHtmlWidget extends StatelessWidget {
  static const routeName = "URL";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("URl - AlertMe"),),
      body: SingleChildScrollView(

        child: Html(
          data: '<div width="100%" height="100%" ><iframe src="https://nediveil.in" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0"></iframe></div>',
        ),
      ),
    );
  }
}
