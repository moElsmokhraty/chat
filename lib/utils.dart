import 'package:flutter/material.dart';

void showError(BuildContext context, String error) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      });
}


void showLoading(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Loading'),
          content: Row(
            children: [
              Spacer(),
              CircularProgressIndicator(),
              Spacer(),
            ],
          ),
        );
      });
}

void hideLoading(BuildContext context) {
  Navigator.pop(context);
}