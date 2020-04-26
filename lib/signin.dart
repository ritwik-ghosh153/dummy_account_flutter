import 'package:dummy_account/user_area.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signin extends StatelessWidget {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user;
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      user = await _auth.currentUser();
    }
    else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      user = (await _auth.signInWithCredential(credential)).user;
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 85),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('log in with google\t'),
                  Icon(Icons.search),
                ],
              ),
              onPressed: () async{
                FirebaseUser user = await _handleSignIn();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Playground(user, _googleSignIn)));
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            SizedBox(height: 30,),
            MaterialButton(
                color: Colors.blueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('log in with phone number\t'),
                    Icon(Icons.phone)
                  ],
                ),
                onPressed: (){
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
          ],
        ),
      ),
    );
  }
}
