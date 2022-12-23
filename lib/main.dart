import 'package:firebase/screens/chathomepage.dart';
import 'package:firebase/screens/login.dart';
import 'package:firebase/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../screens/gegister.dart';
import 'screens/spashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: ChatFirebase(),
  ));
}

class ChatFirebase extends StatefulWidget {
  const ChatFirebase({Key? key}) : super(key: key);

  @override
  State<ChatFirebase> createState() => _ChatFirebaseState();
}

class _ChatFirebaseState extends State<ChatFirebase> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        centerTitle: true,
        color: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
      )),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Welcome.id: (context) => const Welcome(),
        Login.id: (context) => const Login(),
        Register.id: (context) => const Register(),
        // Home.id: (context) =>  Home(),
        chatHomePage.id: (context) => const chatHomePage(),
      },
    );
  }
}
