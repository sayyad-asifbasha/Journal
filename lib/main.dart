import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:project_1/blocs/AuthenticationBloc.dart';
import 'package:project_1/blocs/HomeBloc.dart';
import 'package:project_1/blocs/AuthenticBlocProvider.dart';
import 'package:project_1/blocs/HomeBlocProvider.dart';
import 'package:project_1/services/Authentication.dart';
import 'package:project_1/services/cloud_firestore.dart';
import 'package:project_1/home.dart';
import 'package:project_1/pages/login_page.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setLanguageCode('en');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService=AuthenticationService();
    final AuthenticatonBloc _authenticationBloc=AuthenticatonBloc(_authenticationService);

    return AuthenticationBlocProvider(
        authenticatonBloc: _authenticationBloc,
        child: StreamBuilder(
          initialData: null,
          stream: _authenticationBloc.user,
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Container(
                  color: Colors.blue.shade50,
                  child:SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: Center(
                      child:  CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Colors.blue.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                );
              }else if(snapshot.hasData)
                {
                  return HomeBlocProvider(
                      snapshot.data,
                      homeBloc: HomeBloc(DbFireStoreService(), _authenticationService),
                      child: _buildMaterialApp(Home()),
                  );
                }
            else{
              return _buildMaterialApp(login());
            }
          },
        ),
    );
  }

  MaterialApp _buildMaterialApp(Widget home) {
    return MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    home: const MyHomePage(title: 'Flutter Demo Home Page'),
  );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
    );
  }
}
