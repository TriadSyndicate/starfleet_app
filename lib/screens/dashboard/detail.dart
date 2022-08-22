// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_place/google_place.dart';

class Detail extends StatefulWidget {
  var attractionData;

  Detail({Key? key, this.attractionData}) : super(key: key);
  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<AutocompletePrediction> predictions = [];
  List<Photo> photosResult = [];
  List<Uint8List> imagesU9List = [];
  GooglePlace googlePlace =
      GooglePlace('AIzaSyDmjtAahfUwAfbXEC2hs6j4enlnfRCirpQ');
  String? placeId;
  String? photoReference;
  String address = '';
  String phone = '';
  String website = '';
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    getPlaceSearch(widget.attractionData!['name']);
    final List<String> imgList = [
      widget.attractionData!['photo']!['images']!['small']!['url']!,
      widget.attractionData!['photo']!['images']!['thumbnail']!['url']!,
      widget.attractionData!['photo']!['images']!['original']!['url']!,
      widget.attractionData!['photo']!['images']!['large']!['url']!,
      widget.attractionData!['photo']!['images']!['medium']!['url']!
    ];
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 500.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    var topNav = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200)),
              child: InkWell(
                child: Center(
                  child: Icon(Icons.arrow_back_ios),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                '${widget.attractionData!['name']}',
                style: GoogleFonts.alatsi(
                    color: Colors.grey.shade900, fontSize: 15.0),
              ),
            )
          ],
        )
      ],
    );
    var description = Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              "${widget.attractionData!['description']}",
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0),
            ),
          ),
        ),
      ],
    );
    var googleMap = Column();
    //Button Row w/ Green Like Button & Red Dislike Button <Save to Wish list on Green>
    var feedBack = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            primary: Colors.green,
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Save Attraction"),
              content: Text("Like ${widget.attractionData!['name']}?"),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Saved'),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'Saving..',
                        onPressed: () {},
                      ),
                    ));
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          child: const Text('Like'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            primary: Colors.red,
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Disliked'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'Saving..',
                onPressed: () {},
              ),
            ));
          },
          child: const Text('Dislike'),
        ),
      ],
    );

    // var testFin = Expanded(
    //     child: SizedBox(
    //   height: 200,
    //   child: ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     itemCount: imagesU9List.length,
    //     itemBuilder: (context, index) {
    //       return Container(
    //         width: 250,
    //         height: 250,
    //         child: Card(
    //           elevation: 4,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0),
    //           ),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(10.0),
    //             child: Image.memory(
    //               imagesU9List[index],
    //               fit: BoxFit.fill,
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // ));

    var fpage = Column(
      children: [
        topNav,
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: 2,
            autoPlay: true,
          ),
          items: imageSliders,
        ),
        description,
        Flexible(child: Text('Rating ${widget.attractionData['rating']}')),
        feedBack
      ],
    );

    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [fpage],
      )),
    );
  }

  void getPlaceSearch(String name) async {
    var result = await googlePlace.autocomplete.get(name);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
        placeId = predictions[0].placeId;
      });
      DetailsResponse? resultx = await googlePlace.details.get(placeId!);
      if (resultx != null) {
        var res = await googlePlace.photos
            .get(resultx.result!.reference!, 10000, 10000);

        if (res != null) {
          setState(() {
            imagesU9List = res as List<Uint8List>;
            address = resultx.result!.formattedAddress!;
            phone = resultx.result!.formattedPhoneNumber!;
            print(resultx.result!.photos.toString());
            website = resultx.result!.website!;
          });
          List<Photo> x = res.cast();
          setState(() {
            photosResult = x;
          });
          // for (var photo in photosResult) {
          //   getPhoto(photo.photoReference!);
          // }
        }
      }
    }
  }

  void getPhoto(String photoReference) async {
    var result = await googlePlace.photos.get(photoReference, 10000, 10000);
    if (result != null && mounted) {
      setState(() {
        imagesU9List.add(result);
      });
    }
  }
}
