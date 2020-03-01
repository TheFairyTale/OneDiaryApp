
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileOperater {
  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/record.txt');
  }

  
}