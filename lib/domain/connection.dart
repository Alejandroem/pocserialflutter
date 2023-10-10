abstract class Connection {
  Future<bool> connect(String address);
  Future<bool> disconnect();
  Future<bool> write(List<int> bytes);
  Future<bool> status();
}
