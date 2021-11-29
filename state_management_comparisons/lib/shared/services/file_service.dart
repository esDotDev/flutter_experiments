class FileService {
  void loadFile(String fileName) {}
}

class MockFileService extends FileService {
  @override
  void loadFile(String fileName) {
    print("[MockFileService] loadFile");
  }
}
