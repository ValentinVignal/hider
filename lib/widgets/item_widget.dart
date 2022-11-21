import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hider/services/edit_item_model.dart';
import 'package:hider/services/item_model.dart';
import 'package:hider/utils/path.dart';
import 'package:hider/utils/strings.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher_string.dart';

class ItemWidget extends ConsumerWidget {
  const ItemWidget(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        final editItemModel = ref.read(editItemProvider(path).notifier);
        if (editItemModel.state) {
          editItemModel.state = !editItemModel.state;
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemValueWidget(path),
          const SizedBox(height: 16),
          ItemDescriptionWidget(path),
        ],
      ),
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
      if (!next.isNullOrEmpty && next != _controller.text) {
        _controller.text = next!;
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
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                await Clipboard.setData(ClipboardData(text: value));
                scaffoldMessenger.showSnackBar(
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
              icon: Icon(_hide
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
            ),
          ],
        ),
      ],
    );
  }
}

class ItemDescriptionWidget extends StatelessWidget {
  const ItemDescriptionWidget(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: theme.textTheme.titleLarge),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 2,
              ),
              child: ItemDescriptionTextWidget(path),
            ),
          ),
        ),
      ],
    );
  }
}

class ItemDescriptionTextWidget extends ConsumerStatefulWidget {
  const ItemDescriptionTextWidget(this.path, {Key? key}) : super(key: key);

  final HiderPath path;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ItemDescriptionWidgetState();
}

class _ItemDescriptionWidgetState
    extends ConsumerState<ItemDescriptionTextWidget> {
  final _controller = TextEditingController();

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(itemProvider(widget.path)).description;

    _controller.addListener(() {
      final itemModel = ref.read(itemProvider(widget.path).notifier);
      itemModel.state = itemModel.state.copyWith(description: _controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
        itemProvider(widget.path).select((value) => value.description),
        (previous, next) {
      if (!next.isNullOrEmpty && next != _controller.text) {
        _controller.text = next!;
      }
    });

    final isEditing = ref.watch(editItemProvider(widget.path));
    final Widget child;

    if (isEditing) {
      child = TextField(
        controller: _controller,
        scrollController: _scrollController,
        expands: false,
        maxLines: null,
        textInputAction: TextInputAction.newline,
      );
    } else {
      child = Markdown(
        controller: _scrollController,
        data: _controller.text,
        selectable: true,
        shrinkWrap: true,
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
        ),
        onTapLink: ((text, href, title) {
          if (href != null) {
            launchUrlString(href);
          }
        }),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}
