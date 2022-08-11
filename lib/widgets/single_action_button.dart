import 'package:flutter/material.dart';

class SingleActionButton extends StatelessWidget {
  SingleActionButton({
    required this.buttonName,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  void Function()? onPressed;
  String buttonName;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              primary: const Color(0xffFF0000)),
          child: Text(
            buttonName,
            style: TextStyle(fontSize: 16, color: Colors.white),
          )),
    );
  }
}