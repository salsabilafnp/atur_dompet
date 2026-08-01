import 'package:intl/intl.dart';

class FormatHelper {
  static final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
}
