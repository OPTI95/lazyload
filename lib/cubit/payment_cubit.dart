import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  void get(){
    emit(PaymentInitial());
  }
  Future<void> pay() async{
    emit(PaymentLoadingState());
    await Future.delayed(Duration(seconds: 3));
    bool random = Random().nextBool();
    emit(PaymentLoadedState(random));
  }
}
