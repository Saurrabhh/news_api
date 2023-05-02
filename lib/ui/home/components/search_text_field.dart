import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../services/new_service.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.searchController,
    required this.newsService,
  });

  final TextEditingController searchController;
  final NewsService newsService;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      cursorColor: Colors.black,
      onChanged: (value) => newsService.refresh(),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0, 10, 5, 5),
        hintText: "Search in feed",
        enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kSecondaryColor),
      ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kSecondaryColor),
        ),
      ),
    );
  }
}