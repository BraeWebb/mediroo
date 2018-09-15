import 'package:flutter/material.dart';

import 'package:mediroo/util.dart' show Auth;

/// Create a new snack bar to prompt people to verify their email
SnackBar getVerifySnack(Auth auth) {
  return new SnackBar(
    content: new Text("Please Verify Your Email"),
    action: SnackBarAction(
      label: 'Resend',
      onPressed: () {
        auth.sendVerifyEmail();
      },
    ),
  );
}