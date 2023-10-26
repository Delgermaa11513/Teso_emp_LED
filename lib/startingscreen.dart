import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/birth.dart';
import 'package:flutter_application_2/ui/home_page.dart';

import 'dart:async';
import 'package:flutter_carousel_media_slider/carousel_media.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_carousel_media_slider/flutter_carousel_media_slider.dart';

// import 'package:video_player/video_player.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';

// ignore: camel_case_types
class startingScreen extends StatefulWidget {
  const startingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _startingScreenState createState() => _startingScreenState();
}

// ignore: camel_case_types
class _startingScreenState extends State<startingScreen> {
  @override

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

  List<CarouselMedia> media = [];

  @override
  void initState() {
    downloadVideo();
    //convertListToVideoFileMobile();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

      var data = [
        CarouselMedia(
          mediaName: 'Video 1',
          mediaUrl: dir + "/teso/teso_properties.mp4",
          mediaType: CarouselMediaType.video,
          carouselImageSource: CarouselImageSource.file,
        ),
        CarouselMedia(
          mediaName: 'Video 2',
          mediaUrl: dir + "/teso/teso_foods.mp4",
          mediaType: CarouselMediaType.video,
          carouselImageSource: CarouselImageSource.file,
        ),
        CarouselMedia(
          mediaName: 'Video 3',
          mediaUrl: dir + "/teso/teso_investment.mp4",
          mediaType: CarouselMediaType.video,
          carouselImageSource: CarouselImageSource.file,
        )
      ];
      setState(() {
        media = data.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
            child: Row(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    width: size.width,
                    height: 180,
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
          ),
          Container(
            height: 300,
            child: HomePage(),
          ),
          Container(height: 770, child: birth()),
          Container(
            height: 614,
            color: Colors.white,
            // padding: const EdgeInsets.all(0.0),
            // child: FlutterCarouselMediaSlider(
            //   carouselMediaList: media,
            //   onPageChanged: (index) {
            //     debugPrint('Page Changed: $index');
            //   },
            // ),
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
