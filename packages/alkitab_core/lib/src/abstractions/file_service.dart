abstract class FileService {
  Future<bool> fileExists(String path);
  Future<String> getApplicationDocumentsPath();
}
