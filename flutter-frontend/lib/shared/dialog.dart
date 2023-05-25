import 'package:flutter/material.dart';

class DialogUtils {
  static Future<void> showDeleteConfirmationDialog(BuildContext context, Function() onDelete) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(); // Call the provided callback function
              },
            ),
          ],
        );
      },
    );
  }
}
