abstract class Connection {
  Future<bool> connect(String address);
  Future<bool> disconnect();
  Future<bool> write(List<int> bytes);
  Future<List<int>> read();
  Future<bool> status();
}
