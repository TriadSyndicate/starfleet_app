// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:starfleet_app/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:starfleet_app/screens/dashboard/side_drawer.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  int _count = 0;
  String name = "Brad";
  String? currentLocation = "Melbourne, Aus";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchControl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var welcomeText = Text(
      'Welcome $name,',
      maxLines: 1,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Roboto'),
    );
    // BUILD Request File
    // var APIURI = Uri(
    //     scheme: 'https',
    //     host: 'recommender-backend-5.herokuapp.com',
    //     path: '/api/v1/location',
    //     port: 80);

    // final response = http.post(APIURI, body: {"locationName": "Nairobi"});
    // response.then((value) => {print(value)});

    final testCard = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffeeeeee), width: 2.0),
        color: Colors.white38,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: const [
          BoxShadow(
            color: Colors.white10,
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.all(8),
      height: 80,
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
              child: Icon(
            Icons.icecream,
            size: 40.0,
            color: Colors.amber,
          )),
          SizedBox(
            height: 4.0,
          ),
          Text(
            'flavor',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.red),
          ),
        ],
      ),
    );

    final List<Map> myProducts = List.generate(
        100000, (index) => {"id": index, "name": "Product $index"}).toList();

    final searchBar = TextField(
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.blueGrey[300],
      ),
      maxLines: 1,
      controller: _searchControl,
    );

    final scrollBar = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            testCard,
            testCard,
            testCard,
            testCard,
            testCard,
          ],
        ));

    // return Container(
    //   alignment: Alignment.center,
    //   decoration: BoxDecoration(
    //       color: Colors.amber, borderRadius: BorderRadius.circular(15)),
    //   child: Text(myProducts[index]["name"]),
    // );
    final customScroll = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 3),
          ),
          itemCount: myProducts.length,
          itemBuilder: ((context, index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(15)),
              child: Text(myProducts[index]["name"]),
            );
          })),
    );

    final firstPage = Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Top Bar w/ Current Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200)),
                      child: Center(
                        child: Icon(Icons.menu),
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Current Location",
                            style: GoogleFonts.manrope(
                                color: Colors.grey.shade400),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_sharp,
                                color: Colors.blue,
                                size: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                currentLocation!,
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200)),
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.sliders),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SideDrawer(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "GET YOUR 10% \nCASHBACK",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Text(
                                "*Expired 20 Dec 2022",
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ))
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image.network(
                          "https://www.pngmart.com/files/16/Modern-House-PNG-Clipart.png")
                    ],
                  ),
                ),
                scrollBar,
                customScroll,
              ],
            )));

    // return SafeArea(
    //     child: Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Recommender'),
    //   ),
    //   body: Container(
    //     child: Container(
    //       color: Colors.white,
    //       child: Padding(
    //         padding: const EdgeInsets.all(36.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             welcomeText,
    //             Text('data'),
    //             searchBar,
    //             /* SizedBox(
    //                 height: 180,
    //                 child: Image.asset(
    //                   "assets/logo.png",
    //                   fit: BoxFit.contain,
    //                 )),*/
    //             SizedBox(height: 45),
    //             scrollBar,
    //             SizedBox(height: 15),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // ));

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [firstPage],
    )));
  }
}
