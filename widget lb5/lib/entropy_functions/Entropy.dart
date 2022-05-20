import 'dart:math';

String intToHexByte(int value) {
  String hexBytes = (value % 256).toRadixString(16);
  if (hexBytes.length == 1) {
    hexBytes = "0" + hexBytes;
  }
  return hexBytes;
}

String intToBinaryByte(int value) {
  String intToBin = (value % 256).toRadixString(2);
  if (intToBin.length < 8) {
    String nulls = "";
    for (int i = 0; i < 8 - intToBin.length; i++) {
      nulls += "0";
    }
    intToBin = nulls + intToBin;
  }
  return intToBin;
}

String hexStringFromIntList(List<int> list) {
  String result = list.map(intToHexByte).join(" ").toUpperCase();
  return result;
}

double entropy(List<int> list) {
  String binaryString = list.map(intToBinaryByte).join("");
  print(binaryString);
  return entropyFromBinaryString(binaryString);
}

double entropyFromBinaryString(String binaryString) {
  double prob0 = '0'.allMatches(binaryString).length / binaryString.length.toDouble();
  double prob1 = '1'.allMatches(binaryString).length / binaryString.length.toDouble();
  double entropy = -( prob0 * (log(prob0) / log(2) ) + prob1 * (log(prob1) / log(2)) );
  return entropy;
}

List<int> getRandomList() {
  List<int> list = [];
  Random random = Random();
  for (int i = 0; i < 32; i++) {
    list.add(random.nextInt(256));
  }
  return list;
}
