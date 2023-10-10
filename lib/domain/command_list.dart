abstract class CommandList {
  List<int> get initializePrinter;
  List<int> get cutPaper;
  List<int> get lineFeed;
  List<int> get print;
  List<int> get printAndFeedOneLine;
  List<int> printAndFeedLines(int lines);
  List<int> get printAndCarriageReturn;
  List<int> get readPrinterStatus;
  List<int> get selectCaracterPrintMode;
  List<int> printBarCode(List<int> barcode);
  List<int> print2DBarCode(List<int> barcode);

  List<int> get kickDrawer;
}
