import 'package:flutter/material.dart';
import 'package:now_pills/pages/my_notifications_page.dart';
import 'package:now_pills/pages/welcoming_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          WelcomingPage(),
          MyNotificationsPage(),
        ],
      ),
    );
  }
}
