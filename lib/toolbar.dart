import 'package:flutter/material.dart';

class EditorToolbar extends StatefulWidget {
  const EditorToolbar({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  final FocusNode focusNode;

  @override
  State createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
  bool _showUrlField = false;
  FocusNode? _urlFocusNode;
  TextEditingController? _urlController;

  @override
  void initState() {
    super.initState();
    _urlFocusNode = FocusNode();
    _urlController = TextEditingController();
  }

  @override
  void dispose() {
    _urlFocusNode!.dispose();
    _urlController!.dispose();
    super.dispose();
  }

  _TextType _getCurrentTextType() {
    return _TextType.paragraph;
  }

  TextAlign _getCurrentTextAlignment() {
    return TextAlign.left;
  }

  void _toggleBold() {
    // TODO:
  }

  void _toggleItalics() {
    // TODO:
  }

  void _toggleStrikethrough() {
    // TODO:
  }

  void _applyLink() {
    // TODO:
  }

  void _changeAlignment(TextAlign? newAlignment) {
    // TODO:
  }

  String _getTextTypeName(_TextType textType) {
    switch (textType) {
      case _TextType.header1:
        return "Header 1";
      case _TextType.header2:
        return "Header 2";
      case _TextType.header3:
        return "Header 3";
      case _TextType.paragraph:
        return "Paragraph";
      case _TextType.blockquote:
        return "Blockquote";
      case _TextType.orderedListItem:
        return "Ordered List Item";
      case _TextType.unorderedListItem:
        return "Unordered List Item";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Conditionally display the URL text field below
        // the standard toolbar.
        if (_showUrlField) //
          _buildUrlField(),
        AnimatedBuilder(
          animation: widget.focusNode,
          builder: (context, child) {
            if (!widget.focusNode.hasFocus) {
              return const SizedBox();
            }

            return _buildToolbar();
          },
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Material(
      shape: const StadiumBorder(),
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...[
              Tooltip(
                message: "Block Type",
                child: DropdownButton<_TextType>(
                  value: _getCurrentTextType(),
                  items: _TextType.values
                      .map((textType) => DropdownMenuItem<_TextType>(
                            value: textType,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(_getTextTypeName(textType)),
                            ),
                          ))
                      .toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  underline: const SizedBox(),
                  elevation: 0,
                  itemHeight: 48,
                  onChanged: (_) {},
                ),
              ),
              _buildVerticalDivider(),
            ],
            Center(
              child: IconButton(
                onPressed: _toggleBold,
                icon: const Icon(Icons.format_bold),
                splashRadius: 16,
                tooltip: "Bold",
              ),
            ),
            Center(
              child: IconButton(
                onPressed: _toggleItalics,
                icon: const Icon(Icons.format_italic),
                splashRadius: 16,
                tooltip: "Italic",
              ),
            ),
            Center(
              child: IconButton(
                onPressed: _toggleStrikethrough,
                icon: const Icon(Icons.strikethrough_s),
                splashRadius: 16,
                tooltip: "Strikethrough",
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.link),
                color: IconTheme.of(context).color,
                splashRadius: 16,
                tooltip: "Link",
              ),
            ),
            // Only display alignment controls if the currently selected text
            // node respects alignment. List items, for example, do not.
            ...[
              _buildVerticalDivider(),
              Tooltip(
                message: "Alignment",
                child: DropdownButton<TextAlign>(
                  value: _getCurrentTextAlignment(),
                  items: [TextAlign.left, TextAlign.center, TextAlign.right, TextAlign.justify]
                      .map((textAlign) => DropdownMenuItem<TextAlign>(
                            value: textAlign,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(_buildTextAlignIcon(textAlign)),
                            ),
                          ))
                      .toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  underline: const SizedBox(),
                  elevation: 0,
                  itemHeight: 48,
                  onChanged: _changeAlignment,
                ),
              ),
            ],
            _buildVerticalDivider(),
            Center(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
                splashRadius: 16,
                tooltip: "More Options",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlField() {
    return Material(
      shape: const StadiumBorder(),
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: 400,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: _urlFocusNode,
                controller: _urlController,
                decoration: const InputDecoration(
                  hintText: 'enter url...',
                  border: InputBorder.none,
                ),
                onSubmitted: (newValue) => _applyLink(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: 20,
              splashRadius: 16,
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  _urlFocusNode!.unfocus();
                  _showUrlField = false;
                  _urlController!.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  IconData _buildTextAlignIcon(TextAlign align) {
    switch (align) {
      case TextAlign.left:
      case TextAlign.start:
        return Icons.format_align_left;
      case TextAlign.center:
        return Icons.format_align_center;
      case TextAlign.right:
      case TextAlign.end:
        return Icons.format_align_right;
      case TextAlign.justify:
        return Icons.format_align_justify;
    }
  }
}

enum _TextType {
  header1,
  header2,
  header3,
  paragraph,
  blockquote,
  orderedListItem,
  unorderedListItem,
}
