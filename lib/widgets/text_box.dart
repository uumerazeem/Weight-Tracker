import 'package:flutter/material.dart';

class TextBoxAccounts extends StatelessWidget {
  TextBoxAccounts(
      {Key? key,
      required this.boxHint,
      required this.obsecure,
      this.controller,
      this.prefixIcon,
      this.keyboardType,
      this.validate})
      : super(key: key);
  bool obsecure;
  String boxHint;
  Widget? prefixIcon;
  TextEditingController? controller;
  TextInputType? keyboardType;
  final validate;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    return TextFormField(
      style: const TextStyle(
        fontSize: 14,
      ),
      obscureText: obsecure,
      controller: controller,
      validator: (validate == "") ? () {} : validate,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.black,
      cursorHeight: MediaQuery.of(context).size.height * .034,
      cursorWidth: 2.0,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,

        labelStyle: const TextStyle(fontSize: 14.0),
        focusColor: Colors.grey,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            )),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        // contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
        hintText: boxHint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),
      ),
    );
  }
}