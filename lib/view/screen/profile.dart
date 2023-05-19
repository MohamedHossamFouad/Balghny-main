import 'dart:io';
import 'package:balghny/view/screen/EditProfileScreen.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_app_check/firebase_app_check.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _pickImageAndUpload() async {

   
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get a reference to the Firebase Storage location
      final storageRef = FirebaseStorage.instance.ref()
          .child('profile_images')
          .child(FirebaseAuth.instance.currentUser!.uid + '.jpg');

      // Upload the file to Firebase Storage
      await storageRef.putFile(File(pickedFile.path));

      // Update the user's photo URL in Firestore
      final photoUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'photoUrl': photoUrl});
      
      setState(() {
        myPhotoUrl = photoUrl;
      });
    }
  }
  var myEmail = "";
  var myName = "";
  var myPhotoUrl; // add this variable to store the user's photo URL
  var myPhoneNumber = "";
  var myCity = "" ;


  @override
  void initState() {
    super.initState();
    _fetch();
    FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: 'RECAPTCHA_SITE_KEY');
  }
  
  Future<void> _fetch() async {
  final firebaseUser = await FirebaseAuth.instance.currentUser!;
  if (firebaseUser != null) {
    await FirebaseFirestore.instance
      .collection('users')
      .doc(firebaseUser.uid)
      .get()
      .then((ds) {
        setState(() {
          myEmail = ds.data()!["email"] ?? "";
          myName = ds.data()!["name"] ?? "";
          myPhotoUrl = ds.data()!["photoUrl"]; // get the user's photo URL
          myPhoneNumber = ds.data()!['phoneNumber'] ?? '';
          myCity = ds.data()!['city'] ?? ''; // set the value of myCity
        });
        
        print(myEmail);
        print(myName);
        print(myPhotoUrl);
        print(myPhoneNumber);
        print(myCity);

      }).catchError((e) {
        print(e);
      });
  }
}
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green,
    ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: 
      SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImageAndUpload,
                          child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            border: Border.all(width: 5, color: Colors.grey),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(myPhotoUrl ??
                          'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y'),
                          )
                          )
                      ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    child: Icon(Icons.camera_alt),
                    onPressed: _pickImageAndUpload,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  SizedBox(
                      height: 5,
                    ),
                  Text(
                    myName ?? "",
                    style: TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  Text(
                      "Phone",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                       myPhoneNumber ?? "01122529191",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                     SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Email",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      myEmail ?? "karim@",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "City",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      myCity ?? "",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                    child: Icon(Icons.edit),
                    onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen()),
                        );
                        } 
                        )
               
              ],
            ),
          ],
        ),
      ),
      
    ),
  );
}
}