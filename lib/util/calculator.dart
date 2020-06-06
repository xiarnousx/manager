import 'package:manager/models/transaction.dart';

class Calculator {
  static final int K = 1000;

  static double gain(Transaction tnx) {
    double gain = ((tnx.total_amount * (tnx.dealer_rate / K)) -
            (tnx.total_amount * (tnx.customer_rate / K))) /
        (tnx.dealer_rate / K);
    return -1 * gain * K;
  }

  static double customerLira(Transaction tnx) {
    return tnx.total_amount * tnx.customer_rate;
  }

  static double dealerLira(Transaction tnx) {
    return tnx.total_amount * tnx.dealer_rate;
  }
}
