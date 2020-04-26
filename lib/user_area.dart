import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:image_picker/image_picker.dart';

class Playground extends StatefulWidget {

  FirebaseUser _user;
  GoogleSignIn _googleSignIn;

  Playground(this._user, this._googleSignIn);

  @override
  _PlaygroundState createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  @override
  Widget build(BuildContext context) {
    var img;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Alert(
              context: context,
              style: AlertStyle(backgroundColor: Colors.white),
              title: "Select profile picture",
              buttons: [
                DialogButton(
                  child: Text(
                    "Use Google profile image",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: () {
                    setState(() {
                      img=NetworkImage(widget._user.photoUrl);
                    });
                    Navigator.pop(context);},
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                ),
                DialogButton(
                  child: Text(
                    "Click image",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: () => Navigator.pop(context),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                ),
                DialogButton(
                  child: Text(
                    "Select from gallery",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: ()async{
                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      img=Image.file(image);
                    });
                    Navigator.pop(context);},
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                )
              ],
            ).show();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: CircleAvatar(
                backgroundImage: img==null ? NetworkImage(widget._user.photoUrl) : img,
            ),
          ),
        ),
        title: Column(
          children: [
            Text('Welcome\t', style: TextStyle(fontSize: 25),),
            Text(widget._user.email, style: TextStyle(fontSize: 12),)
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              color: Colors.red,
              child: Text('Sign out'),
              onPressed: () async{
                await widget._googleSignIn.signOut();
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

            ),
          )
        ],
      ),
    );
  }
}

