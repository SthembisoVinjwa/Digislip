import 'dart:typed_data';
import 'package:digislip/components/button.dart';
import 'package:digislip/components/utils.dart';
import 'package:digislip/models/user.dart';
import 'package:digislip/components/loading.dart';
import 'package:digislip/services/auth.dart';
import 'package:digislip/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:textwrap/textwrap.dart';
import 'package:intl/intl.dart';

class Upload extends StatefulWidget {
  final Function toPage;

  const Upload({Key? key, required this.toPage}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final AuthService _auth = AuthService();
  String _dropdownValue = '';
  final dateController = TextEditingController();
  String title = '';
  Uint8List? _image;
  String filename = '';
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> merchantsData = [];
  List<DropdownMenuItem<String>> merchants = [];

  void populateMerchants() async {
    String? uid = Provider.of<CustomUser?>(context, listen: false)!.uid;
    String? email = Provider.of<CustomUser?>(context, listen: false)!.email;

    merchantsData =
        await DatabaseService(uid: uid, email: email!).getMerchants();

    merchantsData.sort((a, b) {
      String nameA = a['Name']!.toLowerCase();
      String nameB = b['Name']!.toLowerCase();
      return nameA.compareTo(nameB);
    });

    setState(() {
      merchants = merchantsData.map((merchant) {
        String name = merchant['Name']!;
        return DropdownMenuItem(
          value: name,
          child: Text(name),
        );
      }).toList();
    });
  }

  Future<void> selectImage() async {
    Map<String, dynamic> map = await pickImage(ImageSource.gallery);
    setState(() {
      filename = map['filename'].toString().split('/').first;
      title = 'Filename: ${map['filename'].toString().split('/').last}';
      _image = map['image'];
    });
  }

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
  void initState() {
    super.initState();
    populateMerchants();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 28),
                SizedBox(width: 2),
                Text(
                  'DigiSlips',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Positioned(
              right: -10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 28,
                    ),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.toPage(1);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Add Receipt',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Just for padding
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left:12, right: 12, bottom: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    color: Theme.of(context).primaryColor,
                    height: 150,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          dropdownColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(5),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary,
                                  width: 3.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .cardColor,
                                  width: 3.0),
                            ),
                          ),
                          items: merchants,
                          iconEnabledColor: Theme.of(context).cardColor,
                          style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          value: _dropdownValue.isEmpty
                              ? null
                              : _dropdownValue,
                          hint: Text(
                            'Select Merchant',
                            style: TextStyle(
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                          onChanged: (String? value) {
                            if (value is String) {
                              setState(() {
                                _dropdownValue = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Date: dd/mm/yyyy',
                            fillColor: Theme.of(context).cardColor,
                            filled: true,
                          ),
                          controller: dateController,
                          onTap: () async {
                            DateTime? selectedDate =
                                await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.utc(2010, 10, 16),
                              lastDate: DateTime.utc(2090, 10, 16),
                              builder: (BuildContext context,
                                  Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme:
                                        const ColorScheme.light()
                                            .copyWith(
                                      primary: Theme.of(context)
                                          .primaryColor, // Set primary color to green
                                    ), // Set background color to white
                                  ),
                                  child: child ?? const SizedBox(),
                                );
                              },
                            );
                            if (selectedDate != null) {
                              setState(() {
                                dateController.text =
                                    DateFormat('dd/MM/yyyy')
                                        .format(selectedDate);
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              MainButton(
                onTap: () async {
                  await selectImage();
                },
                color: Theme.of(context).colorScheme.secondary,
                title: 'Select Receipt',
                margin: 12.0,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                child: Text(
                  fill(title, width: 32),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Flexible(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: MainButton(
                  onTap: () async {
                    List<String> errors = [];

                    if (_dropdownValue.isEmpty) {
                      errors.add('- Please select a merchant.');
                    }

                    if (dateController.text.isEmpty ||
                        !RegExp(r'^\d{2}/\d{2}/\d{4}$')
                            .hasMatch(dateController.text)) {
                      errors.add(
                          '- Add/Select date with the format: dd-mm-yyyy.');
                    }

                    if (filename.isEmpty) {
                      errors.add(
                          '- Please select an image of your receipt.');
                    }

                    if (errors.isNotEmpty) {
                      showMessage(errors.join('\n\n'),
                          "Missing/Incorrect fields");
                    } else {
                      try {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 20),
                                  Loading(message: 'Uploading Receipt...',),
                                ],
                              ),
                            );
                          },
                        );
                        dynamic pic = _image == null
                            ? ''
                            : await DatabaseService(
                                    uid: user!.uid, email: user.email!)
                                .uploadReceiptPicture(
                                    _image!, filename);
                        String? merchantId = merchantsData.firstWhere(
                            (merchant) =>
                                merchant['Name'] ==
                                _dropdownValue)['Id'];
                        await DatabaseService(
                                uid: user!.uid, email: user.email!)
                            .updateReceiptPicture(
                                'Users/${user.uid}/$filename',
                                dateController.text,
                                merchantId!,
                                _dropdownValue,
                                'Upload');
                        if (mounted) {
                          Navigator.of(context).pop();
                        }

                        // Clear from
                        setState(() {
                          _dropdownValue = '';
                          dateController.clear();
                          _image = null;
                          title = '';
                          filename = '';
                        });
                        showMessage(
                            'Receipt was successfully uploaded.',
                            'Uploaded Receipt');
                      } catch (e) {
                        print(e);
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                        showMessage(
                            'Something went wrong with the upload. Check your internet connection.',
                            'Could not upload');
                      }
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  title: 'Save',
                  margin: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
