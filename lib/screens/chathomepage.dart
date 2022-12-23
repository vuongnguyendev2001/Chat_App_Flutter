import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/login.dart';
import 'package:firebase/screens/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';

class chatHomePage extends StatefulWidget {
  static const String id = 'id';
  const chatHomePage({Key? key}) : super(key: key);
  @override
  State<chatHomePage> createState() => _chatHomePageState();
}

class _chatHomePageState extends State<chatHomePage>
    with WidgetsBindingObserver {
  var searchText = '';
  Map<String, dynamic>? userMap;
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();
  final messsageTextController = TextEditingController();
  String? messageText;
  String? imageUrl;
  final CollectionReference _allUser =
      FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Đang hoạt động");
    getCurrentUser();
  }

  void setStatus(String status) async {
    await _allUser.doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Đang hoạt động");
    } else {
      //offline
      setStatus("Vừa mới truy cập");
    }
  }

  void getCurrentUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      print(loggedInUser.uid);
      setState(() {});
    });
  }

  String chatRoomId(String user1, String user2) {
    var result = user1.compareTo(user2);
    if (result > 0) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    String? avatar, userName, email;
    avatar = loggedInUser.avatar;
    print(loggedInUser.uid);
    userName = loggedInUser.userName;
    email = loggedInUser.email;
    return Scaffold(
      // drawer: Drawer(
      //   width: MediaQuery.of(context).size.width * 0.8,
      //   child: Column(
      //     children: [
      //       Container(
      //         padding: EdgeInsets.only(bottom: 20),
      //         height: 250,
      //         width: double.infinity,
      //         color: Colors.blueAccent.shade700,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           children: [
      //             Container(
      //               height: 100,
      //               width: 100,
      //               decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   image: DecorationImage(
      //                     image: NetworkImage(avatar!),
      //                   )),
      //             ),
      //             SizedBox(
      //               height: 5,
      //             ),
      //             Text(
      //               userName! != null ? userName : 'Loading',
      //               style: TextStyle(fontSize: 25, color: Colors.white),
      //             ),
      //             SizedBox(
      //               height: 5,
      //             ),
      //             Text(
      //               email! != null ? email : 'Loading',
      //               style: TextStyle(
      //                   fontSize: 25,
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.w200),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: avatar != null
              ? InkWell(
                  splashColor: Colors.grey,
                  onTap: () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15))),
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                              )),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(avatar!),
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                userName!,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.account_circle,
                                            color: Colors.black, size: 30),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Chỉnh sửa tài khoản',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: GestureDetector(
                                  onTap: () async {
                                    final SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    preferences.remove('email');
                                    Navigator.pushNamed(context, Login.id);
                                    setStatus("Vừa mới truy cập");
                                    EasyLoading.showSuccess(
                                      'Đăng xuất thành công!',
                                      duration: Duration(milliseconds: 1300),
                                      maskType: EasyLoadingMaskType.black,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Đăng xuất',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        );
                      }),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: DecorationImage(image: NetworkImage(avatar))),
                  ),
                )
              : CircularProgressIndicator(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Đoạn chat',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.penToSquare,
                  color: Colors.blue.shade800,
                  size: 27,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) => setState(() {
                    searchText = val;
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                child: StreamBuilder(
                    stream: _allUser
                        .where("userName", isGreaterThanOrEqualTo: searchText)
                        .orderBy("userName")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Something went wrong"),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading"),
                        );
                      }
                      ;
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];
                            return loggedInUser.email !=
                                    documentSnapshot['email']
                                ? GestureDetector(
                                    onTap: () {
                                      String roomId = chatRoomId(
                                          loggedInUser.email!,
                                          documentSnapshot['email']);
                                      print(roomId);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Chat(
                                                    chatRoomId: roomId,
                                                    documentSnapshot:
                                                        documentSnapshot,
                                                  )));
                                      print(roomId);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          documentSnapshot[
                                                              'avatar']))),
                                            ),
                                            SizedBox(
                                              height: 18,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              documentSnapshot['userName'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              documentSnapshot['email'],
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                : Container();
                          });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
