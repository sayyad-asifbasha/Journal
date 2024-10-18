import 'package:flutter/material.dart';
import 'package:project_1/blocs/AuthenticationBloc.dart';

class AuthenticationBlocProvider extends InheritedWidget
{
  final AuthenticatonBloc authenticatonBloc;
  const AuthenticationBlocProvider({Key? key,required Widget child,required this.authenticatonBloc}):super(key: key,child: child);
  static AuthenticationBlocProvider? of(BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>());
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget)=>
      authenticatonBloc!=oldWidget.authenticatonBloc;
}