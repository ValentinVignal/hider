import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/edit_item_model.dart';
import 'package:hider/services/item.dart';
import 'package:hider/services/item_model.dart';
import 'package:hider/utils/download_file/download_file.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/utils/strings.dart';

import '../../services/firestore/firestore_item_service.dart';
import '../../widgets/confirm_dialog.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar(this.path, {Key? key}) : super(key: key);
  final HiderPath path;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppBarTitle(path),
      actions: [
        PopupMenu(path),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarTitle extends ConsumerWidget {
  const AppBarTitle(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editItemProvider(path));
    final child = isEditing ? AppBarTitleEdit(path) : AppBarTitleView(path);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          child: child,
        );
      },
      child: child,
    );
  }
}

class AppBarTitleView extends ConsumerWidget {
  const AppBarTitleView(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsModel = ref.watch(allItemsOfPathProvider(path));
    final nameList = [
      'Home',
      for (final item in itemsModel.value ?? const <Item>[])
        item.name.isEmpty ? noName : item.name,
    ];
    return AutoSizeText(
      nameList.join('/'),
      maxLines: 2,
    );
  }
}

class AppBarTitleEdit extends ConsumerStatefulWidget {
  const AppBarTitleEdit(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  ConsumerState<AppBarTitleEdit> createState() => _AppBarTitleEditState();
}

class _AppBarTitleEditState extends ConsumerState<AppBarTitleEdit> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(itemProvider(widget.path)).name;

    _controller.addListener(() {
      final itemModel = ref.read(itemProvider(widget.path).notifier);
      itemModel.state = itemModel.state.copyWith(name: _controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: noName,
      ),
      controller: _controller,
    );
  }
}

enum _PopupMenuOption {
  export,
  delete,
  logout,
}

class PopupMenu extends ConsumerWidget {
  const PopupMenu(this.path, {Key? key}) : super(key: key);
  final HiderPath path;

  Future<void> _onSelected(
    BuildContext context,
    WidgetRef ref,
    _PopupMenuOption option,
  ) async {
    switch (option) {
      case _PopupMenuOption.export:
        _export(context);
        break;
      case _PopupMenuOption.delete:
        final confirm = await showDialog<bool>(
              context: context,
              builder: (context) {
                return const ConfirmDialog(title: 'Delete?');
              },
            ) ??
            false;
        if (confirm) {
          await FirestoreItemService.delete(path);
          if (context.mounted) {
            GoRouter.of(context).pop();
          }
        }
        break;
      case _PopupMenuOption.logout:
        final confirm = await showDialog<bool>(
              context: context,
              builder: (context) {
                return const ConfirmDialog(title: 'Logout?');
              },
            ) ??
            false;
        if (confirm) {
          AuthenticationModel.instance.logout();
        }
        break;
    }
  }

  Future<void> _export(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting...')),
    );
    final data = await FirestoreItemService.getAll();
    saveFileLocally(
      'hider.json',
      Uint8List.fromList(jsonEncode(data).codeUnits),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exported')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editItemProvider(path));
    return PopupMenuButton<_PopupMenuOption>(
      onSelected: (option) => _onSelected(context, ref, option),
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: _PopupMenuOption.export,
            child: ListTile(
              leading: Icon(Icons.file_download),
              title: Text('Export'),
            ),
          ),
          if (isEditing && path.isNotEmpty)
            const PopupMenuItem(
              value: _PopupMenuOption.delete,
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
              ),
            ),
          const PopupMenuItem(
            value: _PopupMenuOption.logout,
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            ),
          ),
        ];
      },
    );
  }
}
