import 'dart:async';
import 'dart:math';

class validator{
  final validEmail=StreamTransformer<String,String>.fromHandlers(handleData: (email,sink){
    if(email.contains('@') && email.contains('.')){
      sink.add(email);
    }
    else if(email.length>0)
      {
        sink.addError("Enter a valid Email");
      }
  });
  final validPassword =StreamTransformer<String,String>.fromHandlers(handleData: (password,sink){
    if(password.isNotEmpty&&password.length>=6)
      {
        sink.add(password);
      }
   else if(password.length>0)
        {
          sink.addError('Password needs atleast 6 characters');
        }
  });
}