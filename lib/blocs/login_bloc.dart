import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_1/classes/validators.dart';
import 'package:project_1/services/authentication_api.dart';
class LoginBloc extends validator
{
  final AuthenticationApi authenticationApi;
  String ?_email;
  String ?_password;
   bool ?_emailValid;
  bool ?_passwordValid;

  final StreamController<String> _emailController=StreamController<String>.broadcast();
  Sink<String> get emailChanged=>_emailController.sink;
  Stream<String> get email=>_emailController.stream.transform(validEmail);

  final StreamController<String> _passwordController=StreamController<String>.broadcast();
  Sink<String> get passwordChanged=>_passwordController.sink;
  Stream<String> get password=>_passwordController.stream.transform(validPassword);

  final StreamController<bool> _enableLoginCreateButtonController =
  StreamController<bool>.broadcast();
  Sink<bool> get enableLoginCreateButtonChanged => _enableLoginCreateButtonController.
  sink;
  Stream<bool> get enableLoginCreateButton => _enableLoginCreateButtonController.
  stream;

  final StreamController<String> _loginOrCreateButtonController = StreamController<String>.broadcast();
  Sink<String> get loginOrCreateButtonChanged => _loginOrCreateButtonController.sink;
  Stream<String> get loginOrCreateButton => _loginOrCreateButtonController.stream;

  final StreamController<String> _loginOrCreateController = StreamController<String>.broadcast();
  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  final StreamController<String> _loginStatusController = StreamController<String>.broadcast();
  Stream<String> get loginStatus => _loginStatusController.stream;

  LoginBloc(this.authenticationApi)
  {
    FirebaseAuth.instance.setLanguageCode('en');
    _startListnersIfEmailPasswordValid();
  }
  void dispose()
  {
    _emailController.close();
    _passwordController.close();
    _enableLoginCreateButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();
    _loginStatusController.close();
  }
  void _startListnersIfEmailPasswordValid()
  {
    email.listen((email){
      _email=email;
      _emailValid=true;
      _updateLoginButtonStream();
    }).onError((error){
      _email='';
      _emailValid=false;
      _updateLoginButtonStream();
    });

    password.listen((password){
      _password=password;
      _passwordValid=true;
      _updateLoginButtonStream();
    }).onError((error){
      _passwordValid=false;
      _password='';
      _updateLoginButtonStream();
    });
    loginOrCreate.listen((action){
      print('Action received: $action'); // Debugging
      if (action == 'Login') {
        _login();
      } else {
        _createLogin();
      }

    });
  }

  void _updateLoginButtonStream()
  {
    if(_emailValid==true && _passwordValid==true)
      {
        enableLoginCreateButtonChanged.add(true);
      }else
        {
          enableLoginCreateButtonChanged.add(false);
        }
  }

Future<String> _login() async
{
  String _result='';
  if(_emailValid!&&_passwordValid!)
    {
      try {
        await authenticationApi.signInWithEmailAndPassword(email: _email, password: _password);
        _loginStatusController.sink.add("success"); // Broadcast success
      } catch (error) {
        _loginStatusController.sink.add(error.toString()); // Broadcast error
      }
      return _result;
    }else
      {
        _loginStatusController.sink.add('Email and Password are not valid');
        return 'Email and Password are not valid';
      }
}

  Future<String> _createLogin() async
  {
    String _result='';
    if(_emailValid!&&_passwordValid!)
    {
      try {
        await authenticationApi.createUserWithEmailAndPassword(email: _email, password: _password);
        _loginStatusController.sink.add("success"); // Broadcast success
      } catch (error) {
        _loginStatusController.sink.add(error.toString()); // Broadcast error
      }
      return _result;
    }else
    {
      _loginStatusController.sink.add('Error in creating user');
      return 'Error in creating user';
    }
  }
}
