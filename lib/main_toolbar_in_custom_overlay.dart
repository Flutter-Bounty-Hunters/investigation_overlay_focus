import 'package:flutter/material.dart';

import 'focusable_content.dart';
import 'toolbar.dart';

/// This demo displays a popover toolbar in an `Overlay` widget that we add to the widget tree, ourselves.
/// The global `Overlay` is NOT used in this demo.
///
/// Using a `FocusScope` widget above `Overlay`, we can tap toolbar buttons without losing focus. However,
/// I haven't found a way to open dropdown menus without losing focus.
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
        return FocusScope(
          child: child!,
        );
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

  final _overlayKey = GlobalKey();
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

      (_overlayKey.currentState as OverlayState).insert(_toolbarOverlayEntry!);
    } else if (!_contentFocusNode.hasFocus && _toolbarOverlayEntry != null) {
      _toolbarOverlayEntry!.remove();
      _toolbarOverlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This FocusScope let's the user tap on toolbar buttons without completely removing
    // focus from the primary content. Without this FocusScope, when the user taps any button
    // on the toolbar, the primary content would lose focus, and the toolbar would disappear.
    // This FocusScope must appear above a common ancestor that includes both the primary content
    // and the toolbar. In this case, the closest common ancestor that we control is the Overlay
    // widget.
    return FocusScope(
      child: Overlay(
        key: _overlayKey,
        initialEntries: [
          OverlayEntry(
            builder: (context) {
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
            },
          ),
        ],
      ),
    );
  }
}
