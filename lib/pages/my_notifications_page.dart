import 'package:flutter/material.dart';
import 'package:now_pills/services/notification_service.dart';

class MyNotificationsPage extends StatefulWidget {
  const MyNotificationsPage({Key? key}) : super(key: key);

  @override
  MyNotificationsPageState createState() => MyNotificationsPageState();
}

class MyNotificationsPageState extends State<MyNotificationsPage> {
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: notificationService.localNotificationsPlugin.pendingNotificationRequests(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data!.isNotEmpty){
            return Center(
              child: Container(
                child: Text(snapshot.data!.first.id.toString()),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
