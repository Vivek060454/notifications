import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notifications/theme.dart';

import 'Notification/notification.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
body: Center(
  child: Padding(
    padding: const EdgeInsets.all(25.0),
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            notificationServices.getDeviceToken().then((value) async{
              var data ={
                'to':value.toString(),
                'priority':'high',
                "collapse_key" : "type",
                'notification':{
                  'title':'Hello',
                  'body':'Task completed'

                },

              };
              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  body: jsonEncode(data),
                  headers: {
                    'Content-Type':'application/json; charset=UTF-8',
                    'Authorization':'key=AAAAM2EgE1Y:APA91bHc1_cE4y_vBRp-RscFwThFkB7ZCkZnVv5aRlX5qrBcvTfjE-fSJxPWC4YcW-6sKpnSN4u3dGVsYJuyctT-bRdfR2n-n92svA_d7NQO82-fICsKqpa4NRhrzSxrP5hKjcH99dZi'
                  }
              );
            });
          },
          child: Container(

            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Mytheme().primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text('Send Notification',

                style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 3.0),
              ),
            ),

          ),
        ),
      ],
    ),
  ),
),
    );
  }
}
