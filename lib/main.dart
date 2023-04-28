// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

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
                  filePath.notifyListeners();
                }
              },
              child: const Text("Locate mp3.txt"),
            ),
            ElevatedButton(
              onPressed: () async {
                String? directoryPath = await getDirectoryPath();
                if (directoryPath != null) {
                  downloadPath.value = directoryPath;
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
                    return ElevatedButton(
                      onPressed: () async {
                        // YoutubeDownloadTest or youtubeMP3
                        if (filePath.value != "" && downloadPath.value != "") {
                          await shell.run(
                              "./YoutubeDownloadTest ${filePath.value} ${downloadPath.value}");
                          isFinished.value = true;
                          filePath.value = "";
                          downloadPath.value = "";

                          isFinished.notifyListeners();
                          filePath.notifyListeners();
                          downloadPath.notifyListeners();
                        }
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
            ),
          ],
        ),
      ),
    );
  }
}
