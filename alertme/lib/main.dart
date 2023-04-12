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
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
      title: Text("AlertMe"),
    ),
    body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, SpamDetectorPage.routeName);
        }, 
        child: Container(
                  height: 40,
                  width: 220,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                     ),
                  alignment: Alignment.center,
                  child: Text("SMS",
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 20,
                      )),
                ),),
        SizedBox(height: 10,),
         Container(
          height: 40,
          width: 250,
           child: ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, MyHtmlWidget.routeName);
           }, child: Text("URL", style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 20,
                      ))),
         )],
      ),
    ),
    );
  }
}
