import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

class DashboardItems extends StatefulWidget {
  const DashboardItems({Key? key}) : super(key: key);

  @override
  State<DashboardItems> createState() => _DashboardItemsState();
}

class _DashboardItemsState extends State<DashboardItems> {
  List<ItemModel> items = [
    ItemModel(
        "Reciepts",
        Icons.receipt_long_rounded),
    ItemModel("Upload",
        Icons.cloud_upload_rounded),
    ItemModel(
        "Codes",
         Icons.qr_code_scanner_rounded),
    ItemModel("Vouchers",
        Icons.local_offer_rounded),
  ];

  Widget _DashboardOptionCardStyle(ItemModel item) {
    return Row(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(item.Icon, color: Theme.of(context).cardColor),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).cardColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).cardColor),
          ],
        ),
      ],
    );
  }

  Widget _DashboardOptionCard(ItemModel item) {
    return GestureDetector(
      onTap: () {
        print(true);
      },
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 760),
        tween: Tween(begin: -1, end: 0.5),
        builder: (context, value, child) => Transform.translate(
          offset: Offset(value * 200 - 100, 0),
          child: child,
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 150),
          width: 120,
          height: 70,
          padding: const EdgeInsets.fromLTRB(10, 16, 16, 10),
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
              stops: [0.4, 1.0], // 30% secondary color, 70% primary color
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)],
          ),
          child: DelayedDisplay(
            delay: Duration(seconds: 1),
            child: _DashboardOptionCardStyle(item),
          ),
        )
      ),
    );
  }

  Widget _DashboardList() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items.elementAt(index);
        return _DashboardOptionCard(item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: _DashboardList(),
    );
  }
}

class ItemModel {
  final String title;
  final Icon;

  ItemModel(this.title, this.Icon);
}
