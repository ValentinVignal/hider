import 'package:flutter/material.dart';
import 'package:hider/screens/home/home_screen.dart';
import 'package:hider/services/item.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/utils/strings.dart';

class SubItemWidget extends StatelessWidget {
  const SubItemWidget({
    required this.path,
    required this.item,
    Key? key,
  }) : super(key: key);

  final HiderPath path;
  final Item item;

  @override
  Widget build(BuildContext context) {
    final displayName = item.name.isEmpty ? noName : item.name;
    return ListTile(
      title: Text(displayName),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) {
            return HomeScreen(
              path: path.add(item.id),
            );
          },
        ));
      },
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () {},
      ),
    );
  }
}
