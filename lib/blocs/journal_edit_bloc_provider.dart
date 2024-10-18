import 'package:flutter/material.dart';
import 'package:project_1/blocs/journal_edit_bloc.dart';
import 'package:project_1/models/modal.dart';

class journalEditBlocProvider extends InheritedWidget{
  JournalEditBloc? journalEditBloc;
  journalEditBlocProvider({Key?key,required Widget child,bool?add,Journal?journal,this.journalEditBloc}):super(key:key,child: child);
  static journalEditBlocProvider?of(BuildContext context){
    return(context.dependOnInheritedWidgetOfExactType<journalEditBlocProvider>());
  }

  @override
  bool updateShouldNotify(journalEditBlocProvider oldWidget)=>
    journalEditBloc!=oldWidget.journalEditBloc;
}