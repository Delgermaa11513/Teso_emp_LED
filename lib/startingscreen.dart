import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cron/cron.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'dart:async';
import 'package:flutter_carousel_media_slider/carousel_media.dart';
import 'package:flutter_carousel_media_slider/flutter_carousel_media_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

// import 'package:video_player/video_player.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';

// ignore: camel_case_types
class startingScreen extends StatefulWidget {
  const startingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _startingScreenState createState() => _startingScreenState();
}

class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");

    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(String bytes, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name');
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsString(bytes);
  }
}

// ignore: camel_case_types
class _startingScreenState extends State<startingScreen> {
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

  List<CarouselMedia> media = [
    CarouselMedia(
      mediaName: 'Video 2',
      mediaUrl: "/storage/emulated/0/Download/teso/teso.mp4",
      mediaType: CarouselMediaType.video,
      carouselImageSource: CarouselImageSource.file,
    )
  ].toList();

  @override
  void initState() {
    downloadVideo();
    convertListToVideoFileMobile();

    super.initState();
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));

    postRequest();
    final cron = Cron();
    cron.schedule(Schedule.parse('0 2 * * *'), () async {
      postRequest();
    });

    cron.schedule(Schedule.parse('*/8 * * * * *'), () async {
      _controllerCenterRight.play();
      _controllerCenterLeft.play();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    super.dispose();
  }

  // void downloadVideo() async {
  //   final taskId = await FlutterDownloader.enqueue(
  //     url: 'https://www.youtube.com/watch?v=4AoFA19gbLo',
  //     headers: {}, // optional: header send with url (auth token etc)
  //     savedDir: '/assets/',
  //     showNotification:
  //         true, // show download progress in status bar (for Android)
  //     openFileFromNotification:
  //         true, // click on notification to open downloaded file (for Android)
  //   );
  // }

  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    print(status);
    if (!status.isGranted) {
      print("test");
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  Future downloadVideo() async {
    var dir = await getExternalDocumentPath();

    if (dir != null) {
      String savename = "/teso/teso.mp4";
      String savePath = dir + "$savename";
      // print(savePath + "zzzzzzzzzzzzzzzzz");

      var data = CarouselMedia(
        mediaName: 'Video 1',
        mediaUrl: savePath,
        mediaType: CarouselMediaType.video,
        carouselImageSource: CarouselImageSource.file,
      );

      setState(() {
        media = [data];
      });

      //output:  /storage/emulated/0/Download/banner.png

      // try {
      //   await Dio().download(fileurl, savePath,
      //       onReceiveProgress: (received, total) {
      //     if (total != -1) {
      //       print((received / total * 100).toStringAsFixed(0) + "%");
      //       //you can build progressbar feature too
      //     }
      //   });
      //   print("File is saved to download folder.");
      // } on DioError catch (e) {
      //   print(e.message);
      // }
    }
  }

  Future<void> convertListToVideoFileMobile() async {
    Directory _directory = Directory("");

    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }
    String data = _directory.path + "/teso/teso.mp4";

    setState(() {
      videos = [data];
    });
    print(data);

    // return directory.path;
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
          DateFormat('MM-DD').format(DateTime.parse(element["BDAY"])) ==
              DateFormat('MM-DD').format(DateTime.now()));
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
                    margin: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            item['pictureBase64'] != null
                                ? Image.memory(
                                    base64Decode(item["pictureBase64"]),
                                    width: 400,
                                  )
                                : Image.asset(
                                    'assets/image/tenor.gif',
                                    width: 400,
                                  ),
                          ],
                        )),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 280,
                    width: 340,
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 20.0),
                    child: ClipRRect(
                      child: Text(
                        "${item["DISPLAYNAME"]}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
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
      // bottomNavigationBar: const SizedBox(
      //   height: 50,
      //   child: BottomAppBar(
      //     shape: CircularNotchedRectangle(),
      //     color: Color.fromARGB(255, 64, 140, 255),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => const Poem(),
      //         ));
      //   },
      //   backgroundColor: const Color(0xff13195b),
      //   child: const Icon(
      //     Icons.play_circle_fill_sharp,
      //     color: Colors.white,
      //   ),
      // ),

      body: Center(
          child: Column(
        children: [
          Container(
            height: 1220,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipPath(
                      clipper: WaveClipperTwo(),
                      child: Container(
                        width: 1080,
                        height: 180,
                        //  color: Colors.pinkAccent,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/image/friends.jpg"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: ConfettiWidget(
                        confettiController: _controllerCenterLeft,
                        blastDirectionality: BlastDirectionality
                            .explosive, // radial value - LEFT
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
                            blastDirectionality: BlastDirectionality
                                .explosive, // radial value - LEFT
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
                          height: 600,
                          child: CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 2.0,
                                // scrollDirection: Axis.vertical,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 5),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 5000),
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
                        padding: const EdgeInsets.all(150),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'Төрсөн өдрийн мэнд хүргэе',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                            ),
                            ColorizeAnimatedText(
                              'Өдрийг сайхан өнгөрүүлээрэй',
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
          ),
          Container(
            height: 640,
            color: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: FlutterCarouselMediaSlider(
              carouselMediaList: media,
              onPageChanged: (index) {
                debugPrint('Page Changed: $index');
              },
            ),
          ),
        ],
      )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // First parameter will data you want store .
      //     // It must be a in form of string
      //     // Second parameter will be the file name with extensions.
      //     // print("daragdlaa");
      //     FileStorage.writeCounter(myList.toString(), "geeksforgeeks.txt");
      //   },
      //   tooltip: 'Save File',
      //   child: const Icon(Icons.save),
      // ),
    );
  }
}
