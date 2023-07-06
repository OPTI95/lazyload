part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginEmptyState  extends LoginState {}
class LoginLoadedState  extends LoginState {
  final User user;
  LoginLoadedState(this.user);
}

class LoginUploadingImageState extends LoginState{}

class LoginAddingUserState extends LoginState{}

class LoginSendedCodeState extends LoginState{}


class LoginErrorState extends LoginState {}


