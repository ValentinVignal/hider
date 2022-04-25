import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/screens/login/login_screen.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/item_model.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/utils/strings.dart';
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
      body: HomeContent(path: path),
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
    final itemModel = ref.watch(originalItemProvider(path));
    final subItemsModel = ref.watch(subItemsProvider(path));
    return itemModel.map(
      data: (asyncData) {
        final length = (subItemsModel.asData?.value.length ?? 0) +
            1; // + 1 for the description and all
        print('leng $length');
        return ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) {
            print('asData ${subItemsModel.asData?.value}');
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ItemWidget(path),
                    const Divider(),
                  ],
                ),
              );
            }
            final name =
                subItemsModel.asData?.value.toList()[index - 1].name ?? '';
            final subtitle = name.isEmpty ? noName : '';
            return ListTile(
              title: Text(
                  subItemsModel.asData?.value.toList()[index - 1].name ?? ''),
              subtitle: Text(subtitle),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) {
                    return HomeScreen(
                      path: path.add(
                          subItemsModel.asData?.value.toList()[index - 1].id ??
                              ''),
                    );
                  },
                ));
              },
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {},
              ),
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
