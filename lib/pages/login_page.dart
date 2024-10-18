import 'package:flutter/material.dart';
import 'package:project_1/services/Authentication.dart';
import 'package:project_1/blocs/login_bloc.dart';
import 'package:project_1/home.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService());
    _loginBloc.loginStatus.listen((status) {
      if (status == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()), // Replace with your home page
        );
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade300,
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.white,
                ),
              )),
        ),
        backgroundColor: Colors.blue.shade50,
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(40),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder(
                          stream: _loginBloc.email,
                          builder: (BuildContext context,
                              AsyncSnapshot snapshot) =>
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    labelStyle: TextStyle(color: Colors.blue),
                                    icon: Icon(
                                      Icons.email_outlined,
                                      color: Colors.blue,
                                    ),
                                    errorText: snapshot.error?.toString(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    )),
                                onChanged: _loginBloc.emailChanged.add,
                              ),
                        ),
                        StreamBuilder(
                          stream: _loginBloc.password,
                          builder: (BuildContext context,
                              AsyncSnapshot snapshot) =>
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.blue),
                                    icon: Icon(
                                      Icons.security,
                                      color: Colors.blue,
                                    ),
                                    errorText: snapshot.error?.toString(),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                      ),
                                    )),
                                onChanged: _loginBloc.passwordChanged.add,
                              ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        _buttons()
                      ],
                    ) ,
                )

            )),
      ),
    );
  }

  Widget _buttons() {
    return StreamBuilder(
        initialData: 'Login',
        stream: _loginBloc.loginOrCreateButton,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == 'Login') {
            return _btnLogin();
          } else if (snapshot.data == 'create Account') {
            return _btnCreate();
          } else {
            return Container();
          }
        });
  }

  Column _btnLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder(
            initialData: false,
            stream: _loginBloc.enableLoginCreateButton,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.transparent,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation:
                    MaterialStateProperty.resolveWith((states) => 16),
                    backgroundColor: MaterialStateColor.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.white;
                      } else
                        return Colors.blue.shade300;
                    }),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                  onPressed: snapshot.data ?? false
                      ? () =>
                      _loginBloc.loginOrCreateChanged.add('Login')
                      : () {},
                ),
              );
            }),
        TextButton(
          child: Text('Create Account'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('create Account');
          },
        ),
      ],
    );
  }

  Column _btnCreate() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder(
            initialData: false,
            stream: _loginBloc.enableLoginCreateButton,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.transparent,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                      elevation:
                      MaterialStateProperty.resolveWith((states) => 16),
                      backgroundColor: MaterialStateColor.resolveWith((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.white;
                        } else
                          return Colors.blue.shade300;
                      })),
                  child: const Text("Create Account",
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                  onPressed: snapshot.data ?? false
                      ? () =>
                      _loginBloc.loginOrCreateChanged
                          .add('create Account')
                      : () {},
                ),
              );
            }),
        TextButton(
          child: Text('Login'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Login');
          },
        ),
      ],
    );
  }
}
