import 'package:fall_detect_web_app/data/user_id.dart';
import 'package:fall_detect_web_app/pages/home_page.dart';
import 'package:fall_detect_web_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBNwm2XvrSOsb-KVkdj9LvBFxKVe9G_rl4",
          appId: "1:615856094078:web:42b4c20b8e40bbfc16d12f",
          messagingSenderId: "615856094078",
          projectId: "falldetection-f3724"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        // Add the delegates for MaterialLocalizations
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        // Add the locales your app supports
        Locale('en', 'US'), // English
        // Add more locales if needed
      ],
      title: 'Flutter Demo',
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(), //Navigate to the Login Page
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/homepage') {
          final userId = settings.arguments as UserId?;
          return MaterialPageRoute(
            //Navigate to the Homepage
            builder: (context) => HomePage(userId: userId),
          );
        }
        return null; //if there is not routes suggested here, do not generate any
      },
    );
  }
}
