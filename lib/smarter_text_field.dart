library smarter_text_field;

import 'package:flutter/material.dart';

class SmartTextFormField extends StatefulWidget {
  const SmartTextFormField({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.decoration,
    this.validator,
    this.obscureText = false,
    this.action = TextInputAction.done,
    this.completeAction,
    this.forceError = false,
    this.autoFillHints = const [],
    this.displayObscureTextToggle = false,
    this.style,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;

  final InputDecoration? decoration;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool displayObscureTextToggle;
  final bool forceError;
  final TextInputAction action;
  final List<String> autoFillHints;
  final Function()? completeAction;
  final TextStyle? style;

  @override
  _SmartTextFormFieldState createState() => _SmartTextFormFieldState();
}

class _SmartTextFormFieldState extends State<SmartTextFormField> {
  late bool obscureText;

  bool hasBeenUnFocusOnce = false;
  bool hasBeenFocusOnce = false;

  bool forceError = false;

  @override
  void initState() {
    super.initState();

    obscureText = widget.obscureText;

    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus && !hasBeenFocusOnce) {
        setState(() {
          hasBeenFocusOnce = true;
        });
      }
      if (!widget.focusNode.hasFocus && hasBeenFocusOnce && mounted) {
        setState(() {
          hasBeenUnFocusOnce = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon;

    if (widget.displayObscureTextToggle)
      suffixIcon = IconButton(
        onPressed: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
        icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
      );

    final InputDecoration decoration = (widget.decoration ??
            InputDecoration()
                .applyDefaults(Theme.of(context).inputDecorationTheme))
        .copyWith(suffixIcon: suffixIcon);

    return TextFormField(
      decoration: decoration,
      validator: widget.validator,
      style: widget.style,
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: obscureText,
      autovalidateMode: hasBeenUnFocusOnce || widget.forceError
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      textInputAction: widget.action,
      autofillHints: widget.autoFillHints,
      onFieldSubmitted: (_) {
        widget.completeAction?.call();
      },
    );
  }
}
