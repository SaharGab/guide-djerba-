import 'package:flutter/material.dart';
import 'package:projet_pfe/screens/screens.dart';

Widget buildTextField(String hintText, bool isPassword,
    TextEditingController controller, IconData prefixicon) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        prefixIcon: Icon(prefixicon),
        filled: true,
        fillColor: const Color.fromARGB(150, 166, 166, 166),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: Color.fromARGB(195, 18, 120, 171), width: 2.0)),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 18, color: const Color.fromARGB(255, 59, 58, 58))),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
    style: const TextStyle(color: Colors.white, fontSize: 18),
  );
}

Widget Skip_button(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Page4()),
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(top: 30, left: 330),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(150, 73, 71, 75),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.all(6),
        child: Text(
          'Skip',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
  );
}
