import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/router/routes.dart';
import 'package:hider/services/item.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/utils/strings.dart';

import '../router/router.dart';

class SubItemWidget extends ConsumerWidget {
  const SubItemWidget({
    required this.path,
    required this.item,
    Key? key,
  }) : super(key: key);

  final HiderPath path;
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = item.name.isEmpty ? noName : item.name;
    return ListTile(
      title: Text(displayName),
      onTap: () {
        router.push(ItemRoute(path.add(item.id).toUri()).location);
      },
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: item.value));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Copied")),
          );
        },
      ),
    );
  }
}
