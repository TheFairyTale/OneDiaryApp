import 'dart:io';
import 'dart:async';

import 'package:intl/intl.dart'; //date
import '../model/Diary.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart'; //log
import 'package:simple_permissions/simple_permissions.dart';

class FileManager {
  static final FileManager _singleton = new FileManager._internal();

  factory FileManager() {
    return _singleton;
  }

  FileManager._internal();

  Future<String> get _localPath async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final finalPath =
        p.join(directory, "diary"); //path takes strings and not Path objects
    Directory(finalPath)
        .createSync(recursive: true); //create directory if non existant
    return finalPath;
  }

  String getFullFileName(String file, Diary diary) {
    return p.join(file,
        DateFormat('yyyy-MM-dd hh:mm:ss').format(diary.date)); //add timestamp
  }

  Future<File> writeDiary(Diary diary) async {
    var file = await _localPath;
    file = getFullFileName(file, diary);

    // Write the file
    return SimplePermissions.requestPermission(Permission.WriteExternalStorage)
        .then((value) {
      if (value == PermissionStatus.authorized) {
        final diaryJson = diary.toJson();
        return File(file).writeAsString('$diaryJson');
      } else {
        SimplePermissions.openSettings();
        return null;
      }
    });
  }

  Future<FileSystemEntity> deleteDiary(Diary diary) async {
    var file = await _localPath;
    file = getFullFileName(file, diary);

    final exists = await File(file)
        .exists(); //Readme is a file not saved to the filesystem so we first need to check if it exists
    if (exists) {
      return File(file).delete();
    }
    return null;
  }

  Future<List<Diary>> getDiary() async {
    // need file access permission on android. use
    // https://pub.dartlang.org/packages/simple_permissions#-example-tab-
    final file = await _localPath;

    return SimplePermissions.requestPermission(Permission.ReadExternalStorage)
        .then((value) {
      if (value == PermissionStatus.authorized) {
        try {
          var result = Directory(file)
              .list(recursive: false, followLinks: false)
              .asyncMap((fse) {
                if (fse is File) return fse.readAsString();
              })
              .asyncMap((s) => Diary.fromJsonResponse(s))
              .toList();
          return result;
        } catch (e) {
          debugPrint('getDiaryError: $e');
          // If encountering an error, return 0
          return null;
        }
      } else {
        SimplePermissions.openSettings();
        return null;
      }
    });
  }
}
