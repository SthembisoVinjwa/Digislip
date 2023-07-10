import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/button.dart';
import '../../services/auth.dart';
import '../home/home.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with WidgetsBindingObserver {
  bool _firstObscure = true;
  bool _secondObscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String error = '';
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmError = false;
  bool isKeyboardOpen = false;

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

  Future<void> registerInWithEmail(String email, String password) async {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  color: Theme.of(context).primaryColor,
                )),
          );
        });

    try {
      dynamic result = await _auth.RegisterEmailAndPassword(email, password);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(), // Replace with your desired screen
          ),
        );
      }
      if (result == null) {
        error = 'Could not create account. Enter a valid email.';
        showMessage(error, 'Not valid');
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      error = 'Could not create account. Enter a valid email.';
      showMessage(error, 'Not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Icon(Icons.receipt_long, size: 28),
                SizedBox(width: 2),
                Text(
                  'DigiSlips',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            /*Positioned(
              right: -10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.exit_to_app_rounded,
                      size: 28,
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Container(
                  color: Theme.of(context).canvasColor,
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
                      const Text('Register',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      const Text('Create your account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ))
                    ],
                  ),
                )),
            Expanded(
                flex: 9,
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
                                setState(() {
                                  _emailError = true;
                                });
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
                          padding: const EdgeInsets.all(15),
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
                            obscureText: _firstObscure,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _firstObscure = !_firstObscure;
                                  });
                                },
                                icon: _firstObscure
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
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                setState(() {
                                  _confirmError = true;
                                });
                                return 'Password cannot be empty.';
                              } else {
                                if (_passwordController.text !=
                                    _confirmController.text) {
                                  setState(() {
                                    _confirmError = true;
                                  });
                                  return 'Passwords do not match.';
                                } else {
                                  setState(() {
                                    _confirmError = false;
                                  });
                                  return null;
                                }
                              }
                            },
                            controller: _confirmController,
                            obscureText: _secondObscure,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _secondObscure = !_secondObscure;
                                  });
                                },
                                icon: _secondObscure
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
                              labelText: 'Confirm Password',
                              hintText: 'Confirm your password',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: MainButton(
                            onTap: () async {
                              await registerInWithEmail(_emailController.text,
                                  _passwordController.text);
                            },
                            color: Theme.of(context).canvasColor,
                            title: 'Register',
                          ),
                        ),
                        Expanded(child: Container()),
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
                                      'Already have an account?',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          widget.toggleView();
                                        },
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
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
