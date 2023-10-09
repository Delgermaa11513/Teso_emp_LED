import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cron/cron.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'dart:async';
import 'package:flutter_carousel_media_slider/carousel_media.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class birth extends StatefulWidget {
  const birth({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _birthState createState() => _birthState();
}

class _birthState extends State<birth> {
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  late Timer _timer;
  var employees = [];

  String fileurl =
      "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4";

  static const myList = {"name": "GeeksForGeeks"};

  List users = [];
  List videos = [];

  var apiUrl = 'http://172.16.10.11/erpgw_api/post/teamsAPI/getInfo';
  var date = DateTime.now();
  List<CarouselMedia> media = [];

  @override
  void initState() {
    super.initState();
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 100));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 100));
    final cron = Cron();

    postRequest();
    _controllerCenterRight.play();
    _controllerCenterLeft.play();
    cron.schedule(Schedule.parse('*/8 * * * * *'), () async {
      _controllerCenterRight.play();
      _controllerCenterLeft.play();
    });
    cron.schedule(Schedule.parse('0 2 * * *'), () async {
      postRequest();
      setState(() {
        date = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    super.dispose();
  }

//get EmployeeList
  Future<List> postRequest() async {
    //replace your restFull API here.

    List data = [];
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": "tesoteams",
        "password": "teams@654321",
        "commandmode": "displayName"
      }),
    );

    var responseData = json.decode(response.body);

    if (responseData["status"] == 'success') {
      List result = responseData["message"][0];

      final hbday = result.where((element) =>
          element["BDAY"] != null &&
          DateFormat('MM-dd').format(DateTime.parse(element["BDAY"])) ==
              DateFormat('MM-dd').format(DateTime.now()));
      data = hbday.toList();
      if (data.isNotEmpty) {
        for (var item in data) {
          if (item["PICTURE"] != null) {
            final response2 = await http.post(
              Uri.parse(
                  'http://172.16.10.11/erpgw_api/post/gw_to_erp/get_erp_picture'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({"picture": item["PICTURE"]}),
            );
            var responsePicture = json.decode(response2.body);
            item["pictureBase64"] = responsePicture["result"];
          } else {
            item["pictureBase64"] = null;
          }
        }
      }
    }

    setState(() {
      users = data;
    });

    return data;
  }

//EmployeeList
  List<Widget> get imageSliders => users
      .map((item) => Center(
              child: Row(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Container(
                                width: 400,
                                height: 500,
                                foregroundDecoration: BoxDecoration(
                                    // add border
                                    border: Border.all(
                                        width: 16, color: Colors.red),
                                    // round the corners
                                    borderRadius: BorderRadius.circular(150)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: item['pictureBase64'] != null
                                      ? Image.memory(
                                          base64Decode(item["pictureBase64"]),
                                          width: 400,
                                          height: 500,
                                        )
                                      : Image.asset(
                                          'assets/image/tenor.gif',
                                          width: 400,
                                          height: 500,
                                        ),
                                )),
                          ],
                        )),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 350,
                    width: 350,
                    padding: const EdgeInsets.symmetric(
                        vertical: 80.0, horizontal: 30.0),
                    child: ClipRRect(
                      child: Text(
                        "${item["LASTNAME"][0]}."
                        " "
                        "${item["FIRSTNAME"]}"
                        " "
                        "${item["POSITION_NAME"]}"
                        "    "
                        "${item["COMPANY_NAME"]}"
                        " ",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 9, 17, 124),
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )))
      .toList();
//colorize
  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontFamily: 'Horizon',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  width: 1080,
                  height: 220,
                  //  color: Colors.pinkAccent,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/image/teso.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
          Row(children: [
            Container(
              padding: const EdgeInsets.fromLTRB(800.0, 0.0, 0, 0),
              child: Text(
                '$date',
                style: const TextStyle(
                    fontSize: 40, color: Color.fromARGB(255, 57, 54, 247)),
              ),
            ),
          ]),
          Row(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: ConfettiWidget(
                  confettiController: _controllerCenterLeft,
                  blastDirectionality:
                      BlastDirectionality.explosive, // radial value - LEFT
                  particleDrag: 0.05, // apply drag to the confetti
                  emissionFrequency: 0.5, // how often it should emit
                  numberOfParticles: 10, // number of particles to emit
                  gravity: 0.5, // gravity - or fall speed
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.yellow,
                  ], // manually specify the colors to be used
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: ConfettiWidget(
                      confettiController: _controllerCenterRight,
                      blastDirectionality:
                          BlastDirectionality.explosive, // radial value - LEFT
                      particleDrag: 0.05, // apply drag to the confetti
                      emissionFrequency: 0.5, // how often it should emit
                      numberOfParticles: 5, // number of particles to emit
                      gravity: 0.05, // gravity - or fall speed
                      shouldLoop: false,
                      colors: const [
                        Colors.green,
                        Colors.blue,
                        Colors.pink,
                        Colors.yellow,
                      ], // manually specify the colors to be used
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 1080,
                    height: 650,
                    child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 2.0,
                          // scrollDirection: Axis.vertical,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 10),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 2),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                        ),
                        items: imageSliders),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(150.0, 150.0, 0, 0),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Төрсөн өдрийн мэнд хүргэе',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
