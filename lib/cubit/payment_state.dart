part of 'payment_cubit.dart';

@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}
class PaymentLoadingState extends PaymentState {}
class PaymentLoadedState extends PaymentState {
  final bool donePay;

  PaymentLoadedState(this.donePay);
}


