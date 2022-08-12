import 'package:flutter/material.dart';

import 'focusable_content.dart';
import 'toolbar.dart';

/// This demo displays a popover toolbar above the primary content, within a `Stack`.
///
/// By adding a `FocusScope` above the `Stack`, we're able to retain focus when the user presses toolbar
/// buttons. However, our content loses focus when the user opens a dropdown because the dropdown displays
/// itself in a new route, which steals focus from our content.
void main() {
  runApp(const MyApp());
}

final _scopeNode = FocusScopeNode();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return FocusScope(
              node: _scopeNode,
              child: const MyHomePage(),
            );
          },
        );
      },
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
  final _toolbarFocusNode = FocusNode();

  @override
  void dispose() {
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _moveFocusToAppLevel() {
    print("Moving focus to app-level");
    _appFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        // Root level focus for the app.
        focusNode: _appFocusNode,
        child: GestureDetector(
          // The user can tap anywhere outside the primary content to remove focus
          // from the content.
          onTap: _moveFocusToAppLevel,
          // This FocusScope let's the user tap on toolbar buttons without completely removing
          // focus from the primary content. Without this FocusScope, when the user taps any button
          // on the toolbar, the primary content would lose focus, and the toolbar would disappear.
          child: FocusScope(
            child: Stack(
              children: [
                // This is the primary content, which can gain and lose focus.
                FocusableContent(
                  focusNode: _contentFocusNode,
                ),
                // When the primary content has focus, this toolbar builds at the center
                // of the primary content.
                Center(
                  child: EditorToolbar(focusNode: _contentFocusNode),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
