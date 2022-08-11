import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starfleet_app/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class MobileAuth extends StatefulWidget {
  MobileAuth({Key? key}) : super(key: key);

  @override
  State<MobileAuth> createState() => _MobileAuthState();
}

class _MobileAuthState extends State<MobileAuth> {
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final phoneEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final phoneField = IntlPhoneField(
        decoration: InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        initialCountryCode: 'KE',
        onChanged: (phone) {
          phoneEditingController.text = phone.completeNumber;
          Fluttertoast.showToast(msg: "${phoneEditingController.text}");
        });

    //Send Verification button
    final MFA = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 83, 223, 13),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 69,
          onPressed: () {
            SendCode(phoneEditingController.text);
          },
          child: Text(
            "Verify",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        )),
                    Text(
                      'Mobile Authentication',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 44,
                          fontFamily: 'Mono'),
                    ),
                    SizedBox(height: 45),
                    phoneField,
                    SizedBox(height: 15),
                    MFA,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void SendCode(String phone) {
    if (_formKey.currentState!.validate()) {
      print(phone);
    }
  }
}
