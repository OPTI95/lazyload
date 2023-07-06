import 'package:lazyload/servers/Repository/UserRepository.dart';

class UserPresenter{
  final UserRepository userRepository;

  UserPresenter({required this.userRepository});

  Future <List<User>?> getUserList() async{
    try{
     return await userRepository.getUserList();
    }catch(e){
      throw Exception("Возникла ошибка ${e.toString()}");
    }
  }
}