import 'package:flutter/material.dart';
import 'package:mynotes/utilities/generics/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: "Log out",
      content: "Are you sure you want to log out?",
      optionBuilder: () => {
            'No': false,
            'Yes': true,
          }).then(
    (value) => value ?? false,
  );
}
