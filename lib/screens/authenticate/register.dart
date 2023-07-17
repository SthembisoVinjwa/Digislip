import 'package:digislip/components/button.dart';
import 'package:digislip/screens/authenticate/auth_loading.dart';
import 'package:digislip/services/auth.dart';
import 'package:flutter/material.dart';

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

  Future<void> registerInWithEmail(String email, String password) async {
    try {
      setState(() {
        loading = true;
      });
      dynamic result = await _auth.RegisterEmailAndPassword(email, password);
      if (result == null) {
        setState(() {
          loading = false;
          error = 'Could not create account. Enter a valid email.';
          showMessage(error, 'Not valid');
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
        error = 'Could not create account. Enter a valid email.';
        showMessage(error, 'Not valid');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.height;
    final smallScreen = x < 700;
    print(x);

    return loading
        ? const AuthLoading(
            message: 'Creating your account...',
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).canvasColor,
              centerTitle: true,
              title: const Stack(
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
                      flex: smallScreen ? 2 : 3,
                      child: Container(
                        color: Theme.of(context).canvasColor,
                        padding: EdgeInsets.only(
                            left: 30.0, bottom: smallScreen ? 10 : 30.0),
                        child: Column(
                          mainAxisAlignment: smallScreen
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            if (!smallScreen)
                              Container(
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person_2_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  )),
                            Text('Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: smallScreen ? 22 : 32,
                                    fontWeight: FontWeight.bold)),
                            Text('Create your account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: smallScreen ? 14 : 16,
                                ))
                          ],
                        ),
                      )),
                  Expanded(
                      flex: smallScreen ? 12 : 9,
                      child: Form(
                        key: _formKey,
                        child: Container(
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: smallScreen ? 10 : 15,
                                  bottom: smallScreen ? 10 : 15,
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: smallScreen ? 14 : 16),
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
                                  decoration: smallScreen
                                      ? const InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20, 20, 20, 3),
                                          border: OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: 'Email',
                                          hintText: 'Enter your email',
                                        )
                                      : const InputDecoration(
                                          border: OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: 'Email',
                                          hintText: 'Enter your email',
                                        ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: smallScreen ? 10 : 15,
                                  bottom: smallScreen ? 10 : 15,
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: smallScreen ? 14 : 16),
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
                                  decoration: smallScreen
                                      ? InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20, 20, 20, 3),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _firstObscure = !_firstObscure;
                                              });
                                            },
                                            icon: _firstObscure
                                                ? Icon(
                                                    Icons.visibility,
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                  )
                                                : Icon(
                                                    Icons.visibility_off,
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                  ),
                                          ),
                                          border: const OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: 'Password',
                                          hintText: 'Enter your password',
                                        )
                                      : InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _firstObscure = !_firstObscure;
                                              });
                                            },
                                            icon: _firstObscure
                                                ? Icon(
                                                    Icons.visibility,
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                  )
                                                : Icon(
                                                    Icons.visibility_off,
                                                    color: Theme.of(context)
                                                        .canvasColor,
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
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: smallScreen ? 10 : 15,
                                  bottom: smallScreen ? 10 : 15,
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: smallScreen ? 14 : 16),
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
                                  decoration: smallScreen
                                      ? InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20, 20, 20, 3),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _secondObscure =
                                                    !_secondObscure;
                                              });
                                            },
                                            icon: _secondObscure
                                                ? Icon(
                                                    Icons.visibility,
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                  )
                                                : Icon(
                                                    Icons.visibility_off,
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                  ),
                                          ),
                                          border: const OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText: 'Confirm Password',
                                          hintText: 'Confirm your password',
                                        )
                                      : InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _secondObscure =
                                                    !_secondObscure;
                                              });
                                            },
                                            icon: _secondObscure
                                                ? Icon(
                                                    Icons.visibility,
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                  )
                                                : Icon(
                                                    Icons.visibility_off,
                                                    color: Theme.of(context)
                                                        .canvasColor,
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
                                padding: const EdgeInsets.only(top: 10),
                                child: MainButton(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await registerInWithEmail(
                                          _emailController.text,
                                          _passwordController.text);
                                    }
                                  },
                                  color: Theme.of(context).canvasColor,
                                  title: 'Register',
                                  margin: 15.0,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Already have an account?',
                                            style: TextStyle(
                                                fontSize:
                                                    smallScreen ? 14 : 16),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                widget.toggleView();
                                              },
                                              child: Text(
                                                'Sign In',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: smallScreen ? 14 : 16,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ))
                                        ],
                                      ),
                                      Text(
                                        '2023 - Copyright - DigiSlips',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: smallScreen ? 14 : 16),
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
