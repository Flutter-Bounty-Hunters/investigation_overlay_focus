import 'package:flutter/material.dart';

/// Represents some primary content in an app that can receive focus, such as a document editor.
///
/// This widget changes its appearance when it gains/loses focus, for easy visual reference.
class FocusableContent extends StatelessWidget {
  const FocusableContent({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Focus(
        focusNode: focusNode,
        child: AnimatedBuilder(
          animation: focusNode,
          builder: (context, child) {
            print("Building content. Has focus? ${focusNode.hasFocus}");
            return GestureDetector(
              onTap: () {
                print("Requesting focus for primary content");
                focusNode.requestFocus();
                print("Has focus? ${focusNode.hasFocus}");
              },
              child: Container(
                width: 600,
                height: 400,
                color: focusNode.hasFocus ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    focusNode.hasFocus ? "HAS FOCUS" : "NOT FOCUSED",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
