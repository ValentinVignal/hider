import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/screens/home/home_app_bar.dart';
import 'package:hider/services/item_model.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/widgets/first_fab.dart';
import 'package:hider/widgets/item_widget.dart';
import 'package:hider/widgets/second_fab.dart';
import 'package:hider/widgets/sub_item_widget.dart';

/// The screen of one item.
/// It contains:
/// - The item's fields.
/// - The item's sub-items.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    this.path = const HiderPath(),
    super.key,
  });

  final HiderPath path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(path),
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
    super.key,
  });

  final HiderPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subItemsModel = ref.watch(subItemsProvider(path));
    return LayoutBuilder(builder: (context, constraints) {
      final isBig = constraints.maxWidth >= 600;

      return Row(
        children: [
          if (isBig) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ItemWidget(path),
              ),
            ),
            const VerticalDivider()
          ],
          Expanded(
            child: ListView.builder(
              itemCount: (subItemsModel.asData?.value.length ?? 0) +
                  (isBig ? 0 : 1), // +1 for the item's fields.
              itemBuilder: (context, index) {
                if (!isBig && index == 0) {
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
                return subItemsModel.when<Widget>(
                  error: (_, __) {
                    final theme = Theme.of(context);
                    return Center(
                      child: Text(
                        'Error',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  data: (data) {
                    final subItem = data.toList()[index - (isBig ? 0 : 1)];
                    return Hero(
                      tag: subItem.id,
                      child: SubItemWidget(
                        path: path,
                        item: subItem,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
