import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/screens/login/login_screen.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/edit_item_model.dart';
import 'package:hider/services/item_model.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/utils/strings.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar(this.path, {Key? key}) : super(key: key);
  final HiderPath path;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppBarTitle(path),
      actions: [
        IconButton(
          onPressed: () {
            AuthenticationModel.instance.logout();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false);
          },
          icon: const Icon(Icons.logout),
        )
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
          // axisAlignment: 1,
          child: child,
        );
      },
      child: child,
    );
  }
}

class AppBarTitleView extends StatelessWidget {
  const AppBarTitleView(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      'Home/${path.name}',
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
