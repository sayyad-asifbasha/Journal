import 'package:project_1/services/authentication_api.dart';
import 'dart:async';
class AuthenticatonBloc
{
   late final AuthenticationApi  authenticationApi;
 final StreamController<String> _authenticationController=StreamController<String>();
  Sink<String> get addUser=>_authenticationController.sink;
  Stream<String> get user=>_authenticationController.stream;

  final StreamController<bool> _logoutController=StreamController<bool>();
  Sink<bool> get logoutUser=>_logoutController.sink;
  Stream<bool> get listLogoutuser=>_logoutController.stream;


   AuthenticatonBloc(this.authenticationApi)
  {
    onAuthChanged();
  }
  void dispose()
  {
    _logoutController.close();
    _authenticationController.close();
  }
  void onAuthChanged()
  {
    authenticationApi.getFirebaseAuth().authStateChanges().listen((user){
      if(user!=null)
        {
      final String?uid=user?.uid;
      addUser.add(uid!);
        }else
          {
            addUser.add('');
          }
    });
    _logoutController.stream.listen((logout){
      if(logout==true)
        {
          _signOut();
        }
    });
  }

  void _signOut()
  {
    authenticationApi.signOut();
  }
}