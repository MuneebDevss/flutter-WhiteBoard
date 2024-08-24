import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_board/Feature/MainPage/Presentation/TextFieldBloc/textfield_bloc.dart';

class MyTextfield extends StatefulWidget {
  const MyTextfield({
    super.key,
    required this.style,
    required this.node,
    required this.controller,
    required this.convertTextFieldToText,
  });

  final TextStyle style;
  final FocusNode node;
  final VoidCallback convertTextFieldToText;
  final TextEditingController controller;

  @override
  _MyTextfieldState createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  @override
  void initState() {
    super.initState();
    widget.node.requestFocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      autocorrect: true,
      focusNode: widget.node,
      onSubmitted: (value) {
        context
            .read<TextfieldBloc>()
            .add(ChangeEvent(func: widget.convertTextFieldToText));
      },
      onTap: () {
        if (!widget.node.hasFocus) {
          context.read<TextfieldBloc>().add(ChangeEvent(func: () {
            widget.node.requestFocus();
          }));
        }
      },
      style: widget.style,
      decoration: const InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
