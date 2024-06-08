import 'package:flutter/material.dart';
import 'package:mynotes/utilities/generics/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: "Delete note",
      content: "Are you sure you want to delete this note?",
      optionBuilder: () => {
        'No': false,
        'Yes': true,
      }).then(
        (value) => value ?? false,
  );
}
