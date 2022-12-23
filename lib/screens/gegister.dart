import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/component/contrast.dart';
import 'package:firebase/screens/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../component/button.dart';
import '../screens/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static const String id = 'register';
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final fullNameEdittingController = new TextEditingController();
  final emailEdittingController = new TextEditingController();
  final passwordEdittingController = new TextEditingController();
  final confirmpasswordEdittingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fullNameField = TextFormField(
      autofocus: false,
      controller: fullNameEdittingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Tên không được để trống");
        }
        if (!regex.hasMatch(value)) {
          return ("Phải lớn hơn 3 kí tự");
        }
        return null;
      },
      onSaved: (value) {
        fullNameEdittingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(
          Icons.person,
          size: 30,
        ),
        hintText: "Họ và tên",
      ),
    );
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEdittingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Email không được để trống");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Nhập lớn hơn 3 kí tự");
        }
        return null;
      },
      onSaved: (value) {
        emailEdittingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(
          Icons.email,
          size: 30,
        ),
        hintText: "Email",
      ),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEdittingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Mật khẩu không được để trống");
        }
        if (!regex.hasMatch(value)) {
          return ("Mật khẩu phải lớn hơn 6 kí tự");
        }
      },
      onSaved: (value) {
        passwordEdittingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(
          Icons.lock,
          size: 30,
        ),
        hintText: "Mật khẩu",
      ),
    );
    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmpasswordEdittingController,
      obscureText: true,
      validator: (value) {
        if (passwordEdittingController.text !=
            confirmpasswordEdittingController.text) {
          return "Nhập lại mật khẩu";
        }
        return null;
      },
      onSaved: (value) {
        confirmpasswordEdittingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(
          Icons.lock,
          size: 30,
        ),
        hintText: "Nhập lại mật khẩu",
      ),
    );
    final signButton = RoundeButton(
        title: 'ĐĂNG KÝ',
        color: Colors.blueAccent.shade700,
        onPressed: () async {
          signUp(emailEdittingController.text, passwordEdittingController.text);
        });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://support.delta.chat/uploads/default/optimized/1X/768ded5ffbef90faa338761be1c5633d91cc35e3_2_654x1024.jpeg'),
                  fit: BoxFit.cover)),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    child: Image(
                        image: NetworkImage(
                            'https://iconarchive.com/download/i86037/graphicloads/100-flat-2/chat-2.ico')),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  fullNameField,
                  SizedBox(
                    height: 15,
                  ),
                  emailField,
                  SizedBox(
                    height: 15,
                  ),
                  passwordField,
                  SizedBox(
                    height: 15,
                  ),
                  confirmpasswordField,
                  SizedBox(
                    height: 50,
                  ),
                  signButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(),
              })
          .catchError((e) {
        EasyLoading.showError("Đăng ký không thàng công",
            maskType: EasyLoadingMaskType.black,
            duration: Duration(milliseconds: 1300));
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email!;
    userModel.uid = user.uid;
    userModel.userName = fullNameEdittingController.text;
    userModel.status = 'Chưa xác định';

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    EasyLoading.showSuccess('Đăng ký thành công',
        maskType: EasyLoadingMaskType.black,
        duration: Duration(milliseconds: 1300));
    Navigator.pushNamed(context, Login.id);
  }
}
