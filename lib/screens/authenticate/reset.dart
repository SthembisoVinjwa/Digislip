import 'package:digislip/components/button.dart';
import 'package:digislip/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Reset extends StatefulWidget {
  const Reset({Key? key}) : super(key: key);

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String error = '';
  String status = '';

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
    final x = MediaQuery.of(context).size.height;
    final smallScreen = x < 700;

    return Scaffold(
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
                Icon(Icons.receipt_long, size: 28),
                SizedBox(width: 2),
                Text(
                  'DigiSlips',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 20),
                SizedBox(width: 20),
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
                      Text('Reset your password',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: smallScreen ? 22 : 32,
                              fontWeight: FontWeight.bold)),
                      Text('Use email to change your password',
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
                            style: TextStyle(fontSize: smallScreen ? 14 : 16),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Email cannot be empty.';
                              } else {
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)) {
                                  return 'Enter a valid email.';
                                } else {
                                  return null;
                                }
                              }
                            },
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: smallScreen
                                ? const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 20, 20, 3),
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
                          padding: const EdgeInsets.only(top: 10),
                          child: MainButton(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                dynamic result = await _auth.ResetPassword(
                                    _emailController.text);

                                if (result.runtimeType ==
                                    FirebaseAuthException) {
                                  showMessage(
                                      result.message.toString(),
                                      result.code.toString()[0].toUpperCase() +
                                          result.code.toString().substring(1));
                                } else {
                                  showMessage(
                                      'Email was sent to ${_emailController.text}',
                                      'Email Sent');
                                }
                              }
                            },
                            color: Theme.of(context).canvasColor,
                            title: 'Send email',
                            margin: 15.0,
                          ),
                        ),
                        if (error.isNotEmpty)
                          Container(
                              height: 30,
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                error,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.red[800]),
                              )),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '2023 - Copyright - DigiSlips',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: smallScreen ? 14 : 16),
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
