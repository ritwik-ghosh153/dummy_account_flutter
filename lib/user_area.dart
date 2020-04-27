import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class Playground extends StatefulWidget {

  FirebaseUser _user;
  GoogleSignIn _googleSignIn;

  Playground(this._user, this._googleSignIn);

  @override
  _PlaygroundState createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {

  final List<String> items=[];
  final _firestore= Firestore.instance;
  var img;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) =>GestureDetector(
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
                        showSnack(context);
                      });
                      Navigator.pop(context);},
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(116, 116, 191, 1.0),
                      Color.fromRGBO(52, 138, 199, 1.0)
                    ]),
                  ),
                  DialogButton(
                    child: Text(
                      "Click picture",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () async{
                      var image = await ImagePicker.pickImage(source: ImageSource.camera);
                      setState(() {
                        img=FileImage(image);
                        showSnack(context);
                      });
                      Navigator.pop(context);},
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
                        img=FileImage(image);
                        showSnack(context);
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
                  backgroundImage: img ==null ? NetworkImage(widget._user.photoUrl) : img,
              ),
            ),
          ),
        ),
        title: Column(
          children: [
            Text('Logged in as', style: TextStyle(fontSize: 25),),
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
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              String textVal;
              Alert(
                context: context,
                style: AlertStyle(backgroundColor: Colors.white),
                title: "Enter note",
                content: TextField(
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(Icons.message, color: Colors.blueGrey,),
                    hintText: 'Enter custom note here',
                    hintStyle: TextStyle(color: Colors.grey),
                    focusColor: Colors.black,
                  ),
                  cursorColor: Colors.blueGrey[400],
                  onChanged: (value){
                    textVal=value;
                    print(value);
                  },
                ),
                buttons: [
                  DialogButton(
                    child: Text(
                      "Add note",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () async{
                      setState(() {
                        if(textVal!=null)
                          items.add(textVal);
                      });
//                      await _firestore.collection(widget._user.uid).add(
//                      {'text':textVal});
                      Navigator.pop(context);
                      },
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(116, 116, 191, 1.0),
                      Color.fromRGBO(52, 138, 199, 1.0)
                    ]),
                  ),
                ],
              ).show();
            },
          )
        ],
      ),

      body: ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return GestureDetector(
          child: Dismissible(

            key: Key(item),

            onDismissed: (direction) {
              setState(() {
                items.removeAt(index);
              });

              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Note dismissed',
                  style: TextStyle(letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.w600),),
                duration: Duration(milliseconds: 2000),
                backgroundColor: Colors.grey[500],
              ));
            },
            background: Container(
              decoration: BoxDecoration(color: Colors.red),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Delete',style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  Text('Delete',style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.black)
              ),
              child: ListTile(
                title: Text('$item', style: TextStyle(color: Colors.black),),
              ),
            ),
          ),
          onTap: (){
            print('tapped');
            final TextEditingController _myController = TextEditingController()..text=item;
            String textVal;
            Alert(
              context: context,
              style: AlertStyle(backgroundColor: Colors.white),
              title: "Edit note",
              content: TextField(
                controller: _myController,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  icon: Icon(Icons.message, color: Colors.blueGrey,),
                  hintText: 'Enter custom note here',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusColor: Colors.black,
                ),
                cursorColor: Colors.blueGrey[400],
                onChanged: (value){
                  textVal=value;
                  print(value);
                },
              ),
              buttons: [
                DialogButton(
                  child: Text(
                    "Save note",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: () async{
                    setState(() {
                      items.removeAt(index);
                      if(textVal!=null)
                        items.insert(index,textVal);
                    });
//                      await _firestore.collection(widget._user.uid).add(
//                      {'text':textVal});
                    Navigator.pop(context);
                  },
                ),
              ],
            ).show();
          },
        );
      },
      ),
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnack(BuildContext context){
  return Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('Image Updated',
        style: TextStyle(letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.w600),
    ),
    duration: Duration(milliseconds: 2000),
    backgroundColor: Colors.grey[500],
  ));
}