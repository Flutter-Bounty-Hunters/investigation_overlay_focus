import 'package:flutter/material.dart';

import 'focusable_content.dart';
import 'toolbar.dart';

/// This demo displays the toolbar in the global overlay.
///
/// The user can press toolbar buttons without losing focus. Also, compared to the custom `Overlay` demo, we don't
/// need to add a `FocusScope` above the global `Overlay`. There's probably some configuration in the global
/// `Overlay` that shares focus. I'm not sure.
///
/// However, when the user taps to open dropdowns, our content loses focus because the dropdown appear in their
/// own route, which steals our focus.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        // PROBLEM:
        // I tried adding a FocusScope here, above the Navigator, so that our primary content could share
        // focus with dropdown menus, which apparently appear in their own route. However, this FocusScope
        // doesn't solve the problem. Opening a dropdown menu still takes the focus from our primary
        // content, causing the toolbar to disappear.
        return child!;
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _appFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();

  OverlayEntry? _toolbarOverlayEntry;

  @override
  void initState() {
    super.initState();
    _contentFocusNode.addListener(_showOrHideToolbar);
  }

  @override
  void dispose() {
    _contentFocusNode
      ..removeListener(_showOrHideToolbar)
      ..dispose();
    super.dispose();
  }

  void _moveFocusToAppLevel() {
    print("Moving focus to app-level");
    _appFocusNode.requestFocus();
  }

  void _showOrHideToolbar() {
    if (_contentFocusNode.hasFocus && _toolbarOverlayEntry == null) {
      _toolbarOverlayEntry = OverlayEntry(builder: (context) {
        return Center(
          child: EditorToolbar(focusNode: _contentFocusNode),
        );
      });

      Overlay.of(context)!.insert(_toolbarOverlayEntry!);
    } else if (!_contentFocusNode.hasFocus && _toolbarOverlayEntry != null) {
      _toolbarOverlayEntry!.remove();
      _toolbarOverlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // The user can tap anywhere outside the primary content to remove focus
      // from the content.
      onTap: _moveFocusToAppLevel,
      child: Scaffold(
        backgroundColor: Colors.yellow,
        // Root level focus for the app.
        body: Focus(
          focusNode: _appFocusNode,
          // This is the primary content, which can gain and lose focus.
          child: FocusableContent(
            focusNode: _contentFocusNode,
          ),
        ),
      ),
    );
  }
}
