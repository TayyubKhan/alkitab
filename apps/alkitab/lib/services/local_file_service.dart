import 'package:alkitab_core/alkitab_core.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class LocalFileService implements FileService {
  @override
  Future<bool> fileExists(String path) async {
    return io.File(path).exists();
  }
  
  @override
  Future<String> getApplicationDocumentsPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
}
