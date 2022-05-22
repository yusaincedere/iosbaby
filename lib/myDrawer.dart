import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/firebaseFunctions.dart';
import 'package:plant_app/postPage/MainTitles.dart';
import 'package:plant_app/signup/SignUpPage.dart';

import 'login/LoginPage.dart';

class MyDrawer extends StatefulWidget{
  @override
  MyDrawerState createState() => new MyDrawerState();


}
class MyDrawerState extends State<MyDrawer>{

  var firebaseUser = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    adminStateGet();

  }

  static bool visibiltyVariable = false;


  @override
  Widget build(BuildContext context) {

    var myheight = MediaQuery.of(context).size.height * .50;
    var mywidth = MediaQuery.of(context).size.width * .50;

    return Container(
      width: mywidth * .75,
      child: Drawer(
        child: Container(
          color: kSecondaryColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: kPrimaryColor,
                  child: CircleAvatar(
                    //backgroundImage: AssetImage("assets/image/baby_0.png"),
                    backgroundColor: kSecondaryColor,
                    radius: 48,
                  ),
                ),
                decoration: BoxDecoration(
                    color: kSecondaryColor),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: visibiltyVariable,
                    child: ListTile(
                      title: Column(
                        children: [
                          Icon(Icons.input, color: kPrimaryColor),
                          Text('Kullanıcı Ekle'),
                        ],
                      ),
                      onTap: () async => {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>RegisterPage())),
                      },
                    ),
                  ),
                  ListTile(
                    title: Column(
                      children: [
                        Icon(Icons.input, color: kPrimaryColor),
                        Text('Post Screen'),
                      ],
                    ),
                    onTap: () async => {
                      visibiltyVariable = await FirebaseService(uid: firebaseUser.uid).getAdminState(),
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>MainTitles(visibiltyVariable: visibiltyVariable))),
                    },
                  ),
                  ListTile(
                    title: Column(
                      children: [
                        Icon(Icons.input, color: Colors.red),
                        Text('Çıkış'),
                      ],
                    ),
                    onTap: () => {
                        FirebaseAuth.instance.signOut(),
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (route) => false),
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  adminStateGet() async {
    visibiltyVariable = await FirebaseService(uid: firebaseUser.uid).getAdminState();
    setState(() {
    });
  }
}