import '../domain/printer.dart';
import 'epson_command_list.dart';
import 'network_connection.dart';

class EpsonNetworkPrinter extends Printer {
  EpsonNetworkPrinter() : super(EpsonCommandList(), NetworkConnection());
}
