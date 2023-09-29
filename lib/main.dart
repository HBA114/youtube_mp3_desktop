// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final Shell shell = Shell();
  final ValueNotifier filePath = ValueNotifier("");
  final ValueNotifier downloadPath = ValueNotifier("");
  final ValueNotifier listLink = ValueNotifier([]);
  final ValueNotifier downloadCount = ValueNotifier(0);
  final ValueNotifier linkCount = ValueNotifier(0);
  final ValueNotifier isFinished = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                const XTypeGroup typeGroup = XTypeGroup(
                  label: 'text files',
                  extensions: <String>['txt'],
                );
                final XFile? file =
                    await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                if (file != null) {
                  filePath.value = file.path.toString();

                  File(filePath.value)
                      .openRead()
                      .map(utf8.decode)
                      .transform(const LineSplitter())
                      .forEach((l) {
                    listLink.value.add(l);
                    linkCount.value += 1;
                  });

                  listLink.notifyListeners();
                  linkCount.notifyListeners();
                  filePath.notifyListeners();
                }
              },
              child: const Text("Locate mp3.txt"),
            ),
            ElevatedButton(
              onPressed: () async {
                String? directoryPath = await getDirectoryPath();
                if (directoryPath != null) {
                  downloadPath.value = "$directoryPath/";
                  downloadPath.notifyListeners();
                }
              },
              child: const Text("Select folder to download musics..."),
            ),
            ValueListenableBuilder(
              valueListenable: filePath,
              builder: (BuildContext context, value, Widget? child) {
                return ValueListenableBuilder(
                  valueListenable: downloadPath,
                  builder: (BuildContext context, value, Widget? child) {
                    return ValueListenableBuilder(
                      valueListenable: listLink,
                      builder: (BuildContext context, value, Widget? child) {
                        return ElevatedButton(
                          onPressed: () async {
                            // YoutubeDownloadTest or youtubeMP3
                            if (filePath.value != "" &&
                                downloadPath.value != "" &&
                                listLink.value.length >= 1) {
                              for (var linkValue in listLink.value) {
                                await shell.run(
                                    "/home/hbasri/Documents/Programming/dotnet-Projects/YoutubeDownloadTest/bin/Release/net7.0/linux-x64/publish/YoutubeDownloadTest ${filePath.value} $linkValue ${downloadPath.value} mp3");
                                downloadCount.value += 1;
                                downloadCount.notifyListeners();
                              }
                              isFinished.value = true;
                              filePath.value = "";
                              downloadPath.value = "";

                              isFinished.notifyListeners();
                              filePath.notifyListeners();
                              downloadPath.notifyListeners();
                            }
                            // if (filePath.value != "" && downloadPath.value != "") {
                            //   await shell.run(
                            //       "/home/hbasri/Documents/Programming/dotnet-Projects/YoutubeDownloadTest/bin/release/net7.0/linux-x64/publishYoutubeDownloadTest ${filePath.value} ${downloadPath.value}");
                            //   isFinished.value = true;
                            //   filePath.value = "";
                            //   downloadPath.value = "";

                            //   isFinished.notifyListeners();
                            //   filePath.notifyListeners();
                            //   downloadPath.notifyListeners();
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                filePath.value != "" && downloadPath.value != ""
                                    ? Colors.blue
                                    : Colors.grey,
                          ),
                          child: const Text("Download"),
                        );
                      },
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: downloadCount,
              builder: (BuildContext context, value, Widget? child) {
                return ValueListenableBuilder(
                  valueListenable: linkCount,
                  builder: (BuildContext context, value, Widget? child) {
                    return downloadCount.value == 0
                        ? const Text("0%")
                        : Text(
                            "${100 * downloadCount.value ~/ linkCount.value}%");
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
