import 'dart:math';

import 'package:flutter/material.dart';

class HelpingFunctions {
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
  
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }
  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(i, min(i + rowSize, widgets.length));
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }


}
