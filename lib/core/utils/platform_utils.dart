import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformUtils {
  PlatformUtils._();

  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;

  static Widget adaptiveProgressIndicator({Color? color, double? strokeWidth}) {
    if (isIOS) {
      return CupertinoActivityIndicator(color: color);
    }
    return CircularProgressIndicator(
      strokeWidth: strokeWidth ?? 4.0,
      valueColor: color != null ? AlwaysStoppedAnimation(color) : null,
    );
  }

  static Future<T?> showAdaptiveDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) {
    if (isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelText != null)
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelText),
              ),
            if (confirmText != null)
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(confirmText),
              ),
          ],
        ),
      );
    }

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
          if (confirmText != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
        ],
      ),
    );
  }
}
