
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text,textAlign: TextAlign.center,));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}