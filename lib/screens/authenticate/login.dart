import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../components/button.dart';
import '../../models/user.dart';
import '../../services/auth.dart';

class Login extends StatefulWidget {
  final Function toggleView;

  const Login({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  bool _passwordObscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String error = '';
  bool _emailError = false;
  bool _passwordError = false;
  final bool _isIphone = Platform.isIOS;

  void showMessage(String message, String title) {
    AlertDialog inputFail = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      content: Text(message, style: const TextStyle(color: Colors.black)),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).canvasColor)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return inputFail;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.only(left: 30.0, bottom: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.person_2_rounded,
                            color: Colors.white,
                            size: 60,
                          )),
                      const Text('Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      const Text('Sign in with email and password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ))
                    ],
                  ),
                )),
            Expanded(
                flex: 10,
                child: Form(
                  key: _formKey,
                  child: Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                _emailError = true;
                                return 'Email cannot be empty.';
                              } else {
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)) {
                                  setState(() {
                                    _emailError = true;
                                  });
                                  return 'Enter a valid email.';
                                } else {
                                  setState(() {
                                    _emailError = false;
                                  });
                                  return null;
                                }
                              }
                            },
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Email',
                              hintText: 'Enter your email',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 0),
                          child: TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                setState(() {
                                  _passwordError = true;
                                });
                                return 'Password cannot be empty.';
                              } else {
                                setState(() {
                                  _passwordError = false;
                                });
                                return null;
                              }
                            },
                            controller: _passwordController,
                            obscureText: _passwordObscure,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordObscure = !_passwordObscure;
                                  });
                                },
                                icon: _passwordObscure
                                    ? Icon(
                                        Icons.visibility,
                                        color: Theme.of(context).canvasColor,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: Theme.of(context).canvasColor,
                                      ),
                              ),
                              border: const OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Password',
                              hintText: 'Enter your password',
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).canvasColor),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: MainButton(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                print('Sign In');
                                dynamic result =
                                    await _auth.SignInEmailAndPassword(
                                        _emailController.text,
                                        _passwordController.text);
                                if (result == null) {
                                  error = 'User does not exist';
                                  showMessage(error, 'Not found');
                                }
                              }
                            },
                            color: Theme.of(context).canvasColor,
                            title: 'Sign In',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 15, left: 15),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  thickness: 1.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Or sign in with',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(
                                top: 15, right: 15, left: 15),
                            child: Row(
                              children: [
                                Expanded(
                                    child: ElevatedButton.icon(
                                  onPressed: () async {
                                    print('Google');
                                    await _auth.signInWithGoogle();
                                  },
                                  icon: Image.asset('assets/google.png',
                                      height: 35),
                                  label: const Text(
                                    'Google',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.deepPurple.shade50),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(0.0),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            const Size.fromHeight(55)),
                                  ),
                                )),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: ElevatedButton.icon(
                                  onPressed: () {
                                    print('Facebook');
                                  },
                                  icon: Image.asset('assets/facebook.png',
                                      height: 35),
                                  label: const Text(
                                    'Facebook',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.deepPurple.shade50),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(0.0),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            const Size.fromHeight(55)),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          widget.toggleView();
                                        },
                                        child: Text(
                                          'Register',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        ))
                                  ],
                                ),
                                const Text(
                                  '2023 - Copyright - DigiSlips',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
