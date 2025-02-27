import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyTextField extends StatefulWidget {
  final String hint;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? value;
  final bool? obscureText;
  final TextEditingController? controller;
  final bool showPasswordToggle;

  const MyTextField({
    Key? key,
    required this.hint,
    this.onChanged,
    this.validator,
    this.value,
    this.obscureText = false,
    this.controller,
    this.showPasswordToggle = false,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.obscureText ?? true;
  }

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.text,
      obscureText: _isPasswordVisible,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      decoration: InputDecoration(
        filled: true,
        errorStyle: const TextStyle(fontSize: 9),
        fillColor: Theme.of(context).colorScheme.background,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        hintText: widget.hint,
        hintStyle: TextStyles.subtitle3Style(
          Theme.of(context).colorScheme.secondary,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: widget.showPasswordToggle
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : null,
      ),
      minLines: 1,
      maxLines: 1,
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
