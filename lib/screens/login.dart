import 'package:firebase/screens/gegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component/button.dart';
import '../component/contrast.dart';
import 'chathomepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const String id = 'login';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool? showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => chatHomePage()));
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: Image(
                      image: NetworkImage(
                          'https://play-lh.googleusercontent.com/I6iR-zi371fJJsGnqwnY8uUmeYqv-_erzVbVBhyASixDReX2JUuIhgXjtV9OrA-_nQI')),
                ),
                SizedBox(
                  height: 35,
                ),
                const Text(
                  "Ch??o m???ng b???n tr??? l???i v???i Chat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 34,
                      color: Colors.black,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                TextFormField(
                  controller: emailController,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      prefixIcon: Icon(
                        FontAwesomeIcons.envelope,
                        size: 26,
                      ),
                      hintText: 'Email',
                      hintStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      size: 26,
                    ),
                    hintText: 'M???t kh???u',
                    hintStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(
                //   height: 5.0,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: showSpinner,
                        onChanged: (value) {
                          setState(() {
                            showSpinner = value;
                            print(showSpinner);
                          });
                        }),
                    Text(
                      'L??u th??ng tin ????ng nh???p',
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RoundeButton(
                  title: '????ng nh???p',
                  color: Colors.blueAccent.shade700,
                  onPressed: () async {
                    setState(() {
                      // showSpinner = true;
                    });
                    try {
                      final users = (await _auth.signInWithEmailAndPassword(
                          email: email!, password: password!));
                      if (users != null && showSpinner == true) {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString('email', email!);
                        print(email);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => chatHomePage()));
                        EasyLoading.showSuccess("????ng nh???p th??nh c??ng",
                            maskType: EasyLoadingMaskType.black,
                            duration: Duration(milliseconds: 1300));
                      } else if (showSpinner == false) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => chatHomePage()));
                        EasyLoading.showSuccess(
                          '????ng nh???p th??nh c??ng !',
                          duration: Duration(milliseconds: 1300),
                          maskType: EasyLoadingMaskType.black,
                        );
                      }
                      setState(() {
                        // showSpinner = false;
                      });
                    } catch (e) {
                      EasyLoading.showError('Sai email ho???c m???t kh???u',
                          maskType: EasyLoadingMaskType.black,
                          duration: Duration(milliseconds: 1300));
                      print(e);
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                // RoundeButton(
                //   onPressed: () {
                //     signInWithGoogle(context);
                //   },
                //   title: '????ng nh???p Google',
                //   color: Colors.blueAccent.shade700,
                // ),
                SizedBox(
                  height: 5,
                ),
                RoundeButton(
                  title: 'T???o t??i kho???n m???i',
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
