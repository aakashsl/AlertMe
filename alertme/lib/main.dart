import 'package:alertme/sms.dart';
import 'package:alertme/url.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(AlertMe());
  }

class AlertMe extends StatelessWidget {
  const AlertMe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( debugShowCheckedModeBanner: false,
      home:Home() ,
      routes: {
        SpamDetectorPage.routeName:(context) => SpamDetectorPage(),
        MyHtmlWidget.routeName:(context) => MyHtmlWidget(),
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("AlertMe"),
    ),
    body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, SpamDetectorPage.routeName);
        }, child: Text("SMS")),
        SizedBox(height: 10,),
         ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, MyHtmlWidget.routeName);
         }, child: Text("URL"))],
      ),
    ),
    );
  }
}
