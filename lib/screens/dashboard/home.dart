// ignore_for_file: prefer_const_constructors
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
import 'package:starfleet_app/screens/dashboard/side_drawer.dart';
import 'package:starfleet_app/screens/util/backend_call.dart';

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
  String? currentLocation = SideDrawer().locationString;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchControl = new TextEditingController();
  var fpage;
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

    Widget categoryScrollView(List<CategoryModel> x) {
      for (var e in x) {
        int count = 0;
        for (var f in x) {
          if (e.name == f.name) {
            count++;
          }
        }
        e.count = count;
      }
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
                            "${att.attractionData!['photo']['images']['small']['url']}"),
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

    var firstPage = BlocProvider(
        create: (context) => LocationBloc(
              RepositoryProvider.of<APIServices>(context),
            )..add(LoadLocationEvent(currentLocation)),
        child: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is LocationLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LocationLoadedState) {
              List<AttractionModel> attractionList = state.attractions;
              List<CategoryModel> categoryList = state.categories;
              LocationModel locationM = state.location;
              return Container(
                  padding:
                      EdgeInsets.only(right: 10, bottom: 0, left: 10, top: 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          categoryScrollView(categoryList),
                          customScroll(attractionList),
                        ],
                      )));
            }
            if (state is LocationErrorLoadedState) {
              return Text(state.error!);
            } else {
              return Text('ss');
            }
          },
        ));
    final initial = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 0,
          child: Column(
            children: [
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Current Location",
                        style: GoogleFonts.manrope(color: Colors.grey.shade400),
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
                              fontWeight: FontWeight.w700, color: Colors.white),
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
            ],
          ),
        ),
        Flexible(
          flex: 5,
          child: firstPage,
        )
      ],
    );

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [initial],
      ),
    ));
  }
}
