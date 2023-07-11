import 'package:digislip/components/button.dart';
import 'package:flutter/material.dart';
import '../../../../../services/auth.dart';
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
  List<DropdownMenuItem<String>> merchants = const [
    DropdownMenuItem(
      value: 'Merchant 1',
      child: Text('Merchant 1'),
    ),
    DropdownMenuItem(
      value: 'Merchant 2',
      child: Text('Merchant 2'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
        child: Card(
          elevation: 5.0,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: const EdgeInsets.all(12),
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                        padding: const EdgeInsets.all(20.0),
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
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(5),
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
                                    hintText: 'Date: dd-mm-yyyy',
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
                                                ColorScheme.light().copyWith(
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
                                            DateFormat('dd-MM-yyyy')
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
                        onTap: () {},
                        color: Theme.of(context).primaryColor,
                        title: 'Select Receipt',
                        margin: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Colors.red,
                            height: 180,
                            width: 130,
                          ),
                        ),
                      ),
                      Text('My picture.png')
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
