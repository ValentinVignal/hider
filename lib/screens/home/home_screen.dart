import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/screens/login/login_screen.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/item_model.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/widgets/first_fab.dart';
import 'package:hider/widgets/item_widget.dart';
import 'package:hider/widgets/second_fab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    this.path = const HiderPath(),
    Key? key,
  }) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'Home/${path.name}',
          maxLines: 2,
        ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: HomeContent(path: path),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FirstFAB(path),
          const SizedBox(height: 8),
          SecondFAB(path),
        ],
      ),
    );
  }
}

class HomeContent extends ConsumerWidget {
  const HomeContent({
    required this.path,
    Key? key,
  }) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemModel = ref.watch(itemProvider(path));
    return itemModel.map(
      data: (asyncData) {
        return ListView.builder(
          itemCount: asyncData.value.items.length +
              1, // + 1 for the description and all
          itemBuilder: (context, index) {
            if (index == 0) {
              return ItemWidget(path);
            }
            return ListTile(
              title: Text(asyncData.value.items[index - 1].name),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return HomeScreen(
                    path: path.add(asyncData.value.items[index - 1].id),
                  );
                }));
              },
            );
          },
        );
      },
      error: (_) {
        final theme = Theme.of(context);
        return Center(
          child: Text(
            'Error',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        );
      },
      loading: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
