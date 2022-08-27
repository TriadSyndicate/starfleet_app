// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starfleet_app/blocs/app_blocs.dart';
import 'package:starfleet_app/blocs/app_events.dart';
import 'package:starfleet_app/blocs/app_states.dart';
import 'package:starfleet_app/models/attraction.model.dart';
import 'package:starfleet_app/models/category.model.dart';
import 'package:starfleet_app/models/location.model.dart';
import 'package:starfleet_app/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starfleet_app/screens/dashboard/detail.dart';
import 'package:starfleet_app/screens/dashboard/side_drawer.dart';
import 'package:starfleet_app/screens/login_screen.dart';
import 'package:starfleet_app/screens/util/backend_call.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  String? currentLocation;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String name = "Brad";
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.currentLocation = "Madrid, Spain";
    var welcomeText = Text(
      'Welcome $name,',
      maxLines: 1,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Roboto'),
    );
    var dummyImgURL =
        'https://media-cdn.tripadvisor.com/media/photo-l/16/d3/75/e7/pond-in-royal-botanical.jpg';

    final drawer = Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Welcome ${loggedInUser.firstName}'),
          ),
          ListTile(
            title: const Text('LogOut'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              logout(context);
              //Navigator.pop(context);
            },
          ),
        ],
      ),
    );

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

    Widget categoryScrollView(List<CategoryModel> x) {
      return Container(
        height: MediaQuery.of(context).size.height / 12,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: x.length,
            itemBuilder: ((context, index) {
              return InkWell(
                onTap: () {
                  print('${x[index].name}');
                },
                child: Card(
                  key: ValueKey(x[index]),
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text('${x[index].name}'),
                      Text('${x[index].count}'),
                    ],
                  ),
                ),
              );
            })),
      );
    }

    Widget cardx(AttractionModel att) {
      return InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${att.attractionData!['name']}"),
            ));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Detail(attractionData: att.attractionData)));
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 13,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                        image: NetworkImage(
                            "${att.attractionData!['photo']!['images']!['small']!['url'] ?? dummyImgURL}"),
                        fit: BoxFit.cover)),
                child: Container(
                  margin:
                      EdgeInsets.only(right: 5, bottom: 20, left: 10, top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "${att.attractionData!['name']}",
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "${att.attractionData!['offer_group']?['lowest_price'] ?? 'KES 500'}",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 10),
                  )
                ],
              ),
            ],
          ));
    }

    Widget customScroll(List<AttractionModel> list) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 3),
            ),
            itemCount: list.length,
            itemBuilder: ((context, index) {
              return cardx(list[index]);
            })),
      );
    }

    Widget initial(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container(
                    //   width: 50,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       border: Border.all(color: Colors.grey.shade200)),
                    //   child: Center(
                    //     child: Icon(Icons.menu),
                    //   ),
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Current Location",
                          style:
                              GoogleFonts.manrope(color: Colors.grey.shade400),
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
                              widget.currentLocation!,
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
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
                        // ignore: avoid_single_cascade_in_expression_statements
                        context.read<LocationBloc>()
                          ..add(ChooseLocationEvent());
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
                            "  Welcome ${loggedInUser.firstName}",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Text(
                                "${loggedInUser.email}",
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
              ],
            ),
          ),
        ],
      );
    }

    var firstPage = BlocProvider(
        create: (context) => LocationBloc(
              RepositoryProvider.of<APIServices>(context),
            )..add(LoadLocationEvent(widget.currentLocation)),
        child: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is LocationLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LocationLoadedState) {
              List<AttractionModel> attractionList = state.attractions;
              List<CategoryModel> categoryList = state.categories;
              List<CategoryModel> categorySum = [];
              for (var e in categoryList) {
                int count = 0;
                for (var t in categoryList) {
                  if (e.name == t.name) {
                    count++;
                  }
                }
                e.count = count;
                bool test = false;
                categorySum.map((ex) => {
                      if (ex.name == e.name)
                        {
                          test = true,
                        }
                    });
                if (!test) {
                  categorySum.add(e);
                }
              }
              LocationModel locationM = state.location;
              widget.currentLocation = state.locationString;
              return Container(
                  padding:
                      EdgeInsets.only(right: 10, bottom: 0, left: 10, top: 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          initial(context),
                          //categoryScrollView(categorySum),
                          customScroll(attractionList),
                        ],
                      )));
            }
            if (state is ChooseLocationState) {
              return SideDrawer();
            }
            if (state is LocationErrorLoadedState) {
              return Text(state.error!);
            } else {
              return Text('ss');
            }
          },
        ));

    return MaterialApp(
      title: 'Recommender App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider(
          create: (context) => APIServices(),
          child: Scaffold(
              appBar: AppBar(
                title: const Text("Recommender App"),
                centerTitle: true,
              ),
              drawer: drawer,
              body: SafeArea(
                child: Stack(
                  children: [firstPage],
                ),
              ))),
    );

    // return Scaffold(
    //     appBar: AppBar(
    //       title: const Text("Recommender App"),
    //       centerTitle: true,
    //     ),
    //     body: SafeArea(
    //       child: Stack(
    //         children: [firstPage],
    //       ),
    //     ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
