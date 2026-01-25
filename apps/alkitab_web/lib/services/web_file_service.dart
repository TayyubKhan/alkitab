import 'package:alkitab_core/alkitab_core.dart';

class WebFileService implements FileService {
  @override
  Future<bool> fileExists(String path) async {
    return false; // Files never exist locally on Web
  }
  
  @override
  Future<String> getApplicationDocumentsPath() async {
    return ''; // No persistent path on Web
  }
}
