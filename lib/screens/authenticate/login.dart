import 'dart:io';
import 'package:digislip/components/button.dart';
import 'package:digislip/models/user.dart';
import 'package:digislip/screens/authenticate/loading.dart';
import 'package:digislip/screens/authenticate/reset.dart';
import 'package:digislip/services/auth.dart';
import 'package:digislip/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  bool loading = false;

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

  Future<void> signInWithEmail(String email, String password) async {
    try {
      setState(() {
        loading = true;
      });
      dynamic result = await _auth.SignInEmailAndPassword(email, password);
      if (result == null) {
        setState(() {
          loading = false;
          error = 'User does not exist.';
          showMessage(error, 'Not found');
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
        error = 'User does not exist.';
        showMessage(error, 'Not found');
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      setState(() {
        loading = true;
      });
      dynamic result = await _auth.signInWithGoogle();
      if (result == null) {
        setState(() {
          loading = false;
          error = 'Could not sign in with Google.';
          showMessage(error, 'Google Sign in');
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = true;
        error = 'Could not sign in with Google.';
        showMessage(error, 'Google Sign in');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return loading
        ? const Loading()
        : Scaffold(
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
                    children: const [
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
                      flex: (_emailError || _passwordError) ? 2 : 3,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 30.0,
                            bottom:
                                (_emailError || _passwordError) ? 10.0 : 30.0),
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
                      flex: 9,
                      child: Form(
                        key: _formKey,
                        child: Container(
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.only(top: 10.0),
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
                                              color:
                                                  Theme.of(context).canvasColor,
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                              color:
                                                  Theme.of(context).canvasColor,
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
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Reset()));
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                        ))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: MainButton(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await signInWithEmail(
                                          _emailController.text,
                                          _passwordController.text);
                                    }
                                  },
                                  color: Theme.of(context).canvasColor,
                                  title: 'Sign In',
                                  margin: 15.0,
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
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
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: ElevatedButton.icon(
                                            onPressed: () async {
                                              await signInWithGoogle();
                                            },
                                            icon: Image.asset(
                                                'assets/google.png',
                                                height: 35),
                                            label: const Text(
                                              'Google',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .canvasColor
                                                          .withOpacity(0.1)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: const BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              elevation: MaterialStateProperty
                                                  .all<double>(0.0),
                                              minimumSize: MaterialStateProperty
                                                  .all<Size>(
                                                      const Size.fromHeight(
                                                          55)),
                                            ),
                                          )),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
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
                                            icon: Image.asset(
                                                'assets/facebook.png',
                                                height: 35),
                                            label: const Text(
                                              'Facebook',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .canvasColor
                                                          .withOpacity(0.1)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: const BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              elevation: MaterialStateProperty
                                                  .all<double>(0.0),
                                              minimumSize: MaterialStateProperty
                                                  .all<Size>(
                                                      const Size.fromHeight(
                                                          55)),
                                            ),
                                          )),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (_isIphone)
                                        SizedBox(
                                          width: 180,
                                          height: 54,
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              print('Apple');
                                            },
                                            icon: Image.asset(
                                                'assets/apple.png',
                                                height: 35),
                                            label: const Text(
                                              'Apple',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .canvasColor
                                                          .withOpacity(0.1)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: const BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              elevation: MaterialStateProperty
                                                  .all<double>(0.0),
                                              minimumSize: MaterialStateProperty
                                                  .all<Size>(
                                                      const Size.fromHeight(
                                                          55)),
                                            ),
                                          ),
                                        ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
