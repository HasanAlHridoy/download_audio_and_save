import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String audioUrl = 'https://onedrive.live.com/download?cid=AEA055348383CF21&resid=AEA055348383CF21%21108&authkey=ANnXJIsiWfm544o';
  void downloadAndSaveAudio(String audioUrl) async {
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        var response = await http.get(Uri.parse(audioUrl));
        Directory? appDirectory = await getExternalStorageDirectory();
        String savePath = '${appDirectory?.path}/audio4545.mp3';
        File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes, flush: true);
        print('Audio downloaded and saved successfully!');
        print(savePath);
        print(response.statusCode);
      } else {
        print('Permission denied');
      }
    } catch (e) {
      print('Error downloading and saving audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  File file = File('/storage/emulated/0/Android/data/com.example.downloadaudio/files/audio4545.mp3');
                  bool exist = await file.exists();
                  print(exist);
                  if (!exist) {
                    downloadAndSaveAudio(audioUrl);
                    print('============================');
                  } else {
                    print('File Already Exists');
                  }
                },
                child: Text('download')),
            ElevatedButton(
                onPressed: () async {
                  final player = AudioPlayer();
                  await player.play(DeviceFileSource('/storage/emulated/0/Android/data/com.example.downloadaudio/files/audio4545.mp3'));
                },
                child: Text('play')),
          ],
        )),
      ),
    );
  }
}
