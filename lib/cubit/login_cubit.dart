import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:lazyload/servers/Repository/ImgurRepository.dart';
import 'package:lazyload/servers/Repository/Presenter/UserPresenter.dart';
import 'package:lazyload/servers/Repository/UserRepository.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginEmptyState());
  late User userReg;
  int code = 0;
  Future<User?> checkEmail(MaskedTextController controller) async {
    UserPresenter _presenter = UserPresenter(userRepository: UserRepository());
    List<User>? userList = await _presenter.getUserList();
    try {
      userReg = userList!.firstWhere(
          (user) => user.emailUser == controller.unmasked + "@gmail.com");
      return userReg;
    } catch (e) {
      return null;
    }
  }

  Future<void> checkLoginAndPassword(String login, String password) async {
    emit(LoginEmptyState());
    await Future.delayed(Duration(seconds: 2));
    UserPresenter _presenter = UserPresenter(userRepository: UserRepository());
    List<User>? userList = await _presenter.getUserList();
    try {
      User user = userList!.firstWhere(
          (user) => user.emailUser == login && user.passwordUser == password);
      emit(LoginLoadedState(user));
    } catch (e) {
      emit(LoginErrorState());
    }
  }

  void addInfoUser(
      TextEditingController secondNameContoller,
      TextEditingController firstNameContoller,
      TextEditingController emailContoller,
      TextEditingController passwordContoller,
      MaskedTextController numberPhoneContoller) {
    userReg = User(
        idUser: 0,
        nameUser: firstNameContoller.text,
        secondNameUser: secondNameContoller.text,
        emailUser: emailContoller.text + "@gmail.com",
        passwordUser: passwordContoller.text,
        phoneNumberUser: numberPhoneContoller.unmasked,
        adressUser: "",
        profileImageUser: "");
  }

  Future<void> uploadImage(String image) async {
    emit(LoginUploadingImageState());
    ImgurRepository imgurRepository = ImgurRepository();
    final response = await imgurRepository.UploadImage(image);
    if (response != "Ошибка") {
      userReg.profileImageUser = response;
    }
  }

  Future<void> sendEmail() async {
    var random = Random();
    var min = 8000;
    var max = 9000;

    code = min + random.nextInt(max - min + 1);
    final smtpServer =
        await gmail('majesticbotrp@gmail.com', 'ipiruoywprbrcsls');
    final message = await Message()
      ..from = Address('majesticbotrp@gmail.com', 'OPTIFOOD')
      ..recipients.add(userReg.emailUser)
      ..subject = 'Код проверки'
      ..text = 'Ваш код проверки: ' + code.toString();
    final sendReport = await send(message, smtpServer);
    // Вывести отчет о доставке в консоль.
    print('Message sent: ' + sendReport.toString());
    print(code);

    emit(LoginEmptyState());
  }

  Future<bool> changePasswordUser(MaskedTextController controller) async {
    UserRepository userRepository = UserRepository();
    userReg.passwordUser = controller.text;
    bool create = await userRepository.changePasswordUser(userReg);
    if (create) {
      emit(LoginLoadedState(userReg));
      return true;
    } else {
      emit(LoginEmptyState());

      return false;
    }
  }

  Future<bool> addUser(TextEditingController controller) async {
    emit(LoginAddingUserState());
    if (controller.text == code.toString()) {
      UserRepository userRepository = UserRepository();
      bool create = await userRepository.createUser(userReg);
      if (create) {
        emit(LoginLoadedState(userReg));
        return true;
      } else {
        emit(LoginEmptyState());

        return false;
      }
    } else {
      return false;
    }
  }
}
