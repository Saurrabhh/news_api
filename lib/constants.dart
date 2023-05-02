import 'package:flutter/material.dart';

String apiUrl = "https://newsapi.org/v2/top-headlines?country=in&apiKey=ba18c7b9ec7c41e68ce8e0347a8128d7&pageSize=100";

addVerticalSpace(double height){
  return SizedBox(height: height);
}

addHorizontalSpace(double width){
  return SizedBox(width: width);
}

const kPrimaryColor = Colors.red;
const kSecondaryColor = Colors.blue;