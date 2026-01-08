import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class customTextField extends StatefulWidget {
  final String? hint;
  final Color? fillColor;
  final bool? isPass;
  final TextEditingController? controller;
  final bool isNumeric;
  final bool isDouble;
  final Function(String)? onChanged;

  const customTextField({
    Key? key,
    this.hint,
    this.isPass = false,
    this.isNumeric = false,
    this.isDouble = false,
    this.fillColor,
    this.controller,
    this.onChanged
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<customTextField> {
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = widget.isPass ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.0,
      child: TextFormField(
        keyboardType: (widget.isNumeric || widget.isDouble) ? TextInputType.number : TextInputType.text,
        inputFormatters: widget.isNumeric ? [FilteringTextInputFormatter.digitsOnly] : (widget.isDouble ? [FilteringTextInputFormatter(RegExp(r'^\d*\.?\d*$'), allow: true)]  : []),
        obscureText: isPasswordVisible,
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.only(
                left: 8.0,
                bottom: 8.0,
                top: 8.0),
            hintStyle: const TextStyle(
              color: Colors.grey, // Change hint text color as needed
              fontSize: 13,
            ),
            hintText: widget.hint,
            isDense: true,
            filled: true,
            fillColor: widget.fillColor ?? Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amberAccent),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey), // Change enabled border color as needed
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue), // Change focused border color as needed
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: widget.isPass == true
                ? IconButton(
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              icon: Icon(
                isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey, // Change icon color as needed
              ),
            )
                : null
        ),
      ),
    );
  }
}