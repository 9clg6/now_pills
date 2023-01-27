import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:now_pills/constants.dart';
import 'package:now_pills/services/notification_service.dart';
import 'package:timezone/timezone.dart';

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
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          "Mes rappels",
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<PendingNotificationRequest>>(
        future: notificationService.localNotificationsPlugin.pendingNotificationRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _buildListView(snapshot);
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Soit vous n'avez aucun rappel 💊. \nSoit on ne s'en rappelle pas..."),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Padding _buildListView(AsyncSnapshot<List<PendingNotificationRequest>> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: ListView.separated(
        itemCount: snapshot.data!.length,
        itemBuilder: (_, index) {
          final current = snapshot.data!.elementAt(index);
          final payLoad = jsonDecode(current.payload!) as Map<String, dynamic>;
          final date = TZDateTime.fromMillisecondsSinceEpoch(local, payLoad["endTime"]);

          return Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [mainShadow],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildDateAndHour(date),
                    _buildPillName(payLoad),
                  ],
                ),
                _buildIcon(current),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 15),
      ),
    );
  }

  Padding _buildPillName(Map<String, dynamic> payLoad) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Text(
        payLoad["pillName"],
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  InkWell _buildIcon(PendingNotificationRequest current) {
    return InkWell(
      onTap: () {
        setState(() {
          notificationService.localNotificationsPlugin.cancel(current.id);
        });
      },
      child: const Icon(
        Icons.delete_outline_outlined,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Column _buildDateAndHour(TZDateTime date) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${date.hour}:${date.minute}",
          style: const TextStyle(color: Colors.white, fontSize: 30),
        ),
        Text(
          "${DateFormat('EEEE', 'fr_FR').format(date)} ${date.day}/${date.month}",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
