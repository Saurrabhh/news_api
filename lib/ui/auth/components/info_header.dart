import 'package:flutter/material.dart';

import '../../../constants.dart';
class InfoHeader extends StatelessWidget {
  const InfoHeader({
    super.key,
    required this.info,
  });
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10.0),
      child: Text(
        info,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 32, color: kPrimaryColor),
      ),
    );
  }
}