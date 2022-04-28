import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/screens/login/login_screen.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/utils/path.dart';

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
    return InkWell(
      onTap: () {},
      child: AutoSizeText(
        'Home/${path.name}',
        maxLines: 2,
      ),
    );
  }
}
