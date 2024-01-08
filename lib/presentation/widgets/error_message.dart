import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String? image;
  final String? message;
  final Function()? onPressed;

  const ErrorMessage({
    super.key,
    required this.image,
    required this.message,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image ?? "",
            height: 80,
            width: 80,
          ),
          Text(
            message ?? "",
          ),
          const SizedBox(height: 18),
          if (onPressed != null)
            ElevatedButton(
              onPressed: onPressed,
              child: const Text(
                'Refresh',
              ),
            ),
        ],
      ),
    );
  }
}
