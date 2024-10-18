import 'package:flutter/material.dart';
import 'package:project_1/blocs/HomeBloc.dart';

class HomeBlocProvider extends InheritedWidget
{
  final HomeBloc homeBloc;
  final String uid;
  const HomeBlocProvider(this.uid, {Key? key,required Widget child,required this.homeBloc}):super(key:key,child: child);

  static HomeBlocProvider? of(BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<HomeBlocProvider>());
  }
  @override
  bool updateShouldNotify(HomeBlocProvider old)=>homeBloc!=old.homeBloc;
}