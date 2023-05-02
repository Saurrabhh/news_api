import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:quantum_assignment/constants.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.suffixIcon,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: labelText == "Password",
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.fromLTRB(0,10,5,5),
          hintStyle: const TextStyle(fontSize: 18),
          labelStyle:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 24),
            labelText: labelText,
            hintText: hintText,
            suffixIcon: Icon(suffixIcon, color: kPrimaryColor,),),
      ),
    );
  }
}

class PhoneNoTextField extends StatelessWidget {
  const PhoneNoTextField({Key? key, required this.controller, required this.onChanged}) : super(key: key);
  final TextEditingController controller;
  final Function(CountryCode) onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Contact No",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18),),
        Row(
          children: [
            CountryCodePicker(
              onChanged: onChanged,
              initialSelection: 'IN',
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
            ),
            Flexible(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0,14,5,5),
                  hintText: "9876543210",
                  hintStyle: TextStyle(fontSize: 18),
                  suffixIcon: Icon(Icons.phone,color: kPrimaryColor,),),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
