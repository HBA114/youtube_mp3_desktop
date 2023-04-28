import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final Shell shell = Shell();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Center(
              child: Text('Hello World!'.toString()),
            ),
            TextButton(
              onPressed: () async {
                // YoutubeDownloadTest or youtubeMP3
                await shell.run(
                    "./YoutubeDownloadTest /home/hbasri/Desktop/mp3.txt /home/hbasri/Desktop/musics/");
              },
              child: const Text("Download"),
            ),
          ],
        ),
      ),
    );
  }
}
