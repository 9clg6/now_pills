import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:now_pills/controllers/notification_creation_controller.dart';
import 'package:now_pills/pages/cgu_page.dart';
import 'package:now_pills/pages/home_page.dart';
import 'package:now_pills/services/notification_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting('fr_FR');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  final notifService = NotificationService();
  await notifService.setup();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => NotificationCreationController())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        "/cgu": (_) => const CGUPage(),
        "/": (_) => const HomePage(),
      },
    );
  }
}
