import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/services/edit_item_model.dart';
import 'package:hider/services/item_model.dart';
import 'package:hider/utils/path.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemValueWidget(path),
        // ItemValueView(item.value),
        // Text('Description', style: theme.textTheme.titleLarge),
        // Text(item.description),
      ],
    );
  }
}

class ItemValueWidget extends ConsumerStatefulWidget {
  const ItemValueWidget(this.path, {Key? key}) : super(key: key);
  final HiderPath path;

  @override
  ConsumerState<ItemValueWidget> createState() => _ItemValueWidgetState();
}

class _ItemValueWidgetState extends ConsumerState<ItemValueWidget> {
  var _hide = true;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(itemProvider(widget.path)).value;

    _controller.addListener(() {
      final itemModel = ref.read(itemProvider(widget.path).notifier);
      itemModel.state = itemModel.state.copyWith(value: _controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
        itemProvider(widget.path).select((value) => value.value),
        (previous, next) {
      if (previous == null && next != null) {
        _controller.text = next;
      }
    });
    final value = ref.watch(
      originalItemProvider(widget.path)
          .select((value) => value.value?.value ?? ''),
    );

    final isEditing = ref.watch(editItemProvider(widget.path));
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Value', style: theme.textTheme.titleLarge),
            IconButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Copied")),
                );
              },
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _controller,
                    obscureText: _hide,
                    readOnly: !isEditing,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _hide = !_hide;
                });
              },
              icon: const Icon(Icons.visibility),
            ),
          ],
        ),
      ],
    );
  }
}
