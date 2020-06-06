import 'package:intl/intl.dart';

class Formatter {
  static String formatDate(String d) {
    DateTime date = DateTime.parse(d);
    final format = DateFormat('E dd, MMMM y H:m');
    return format.format(date).toString();
  }

  static String formatMoney(double d) {
    final f = new NumberFormat("###.0#", "en_US");
    return f.format(d).toString();
  }
}
