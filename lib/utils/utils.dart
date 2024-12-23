import 'package:flutter/material.dart';

class Utils {
  // static bool isListView = true;
  static ValueNotifier<bool> isListView = ValueNotifier<bool>(true);
  static String isNewUser = "isNewUser";

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  // Function to get icon based on category name
  static IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'all':
        return Icons.category; // Default icon
      case 'music':
        return Icons.music_note;
      case 'business':
        return Icons.business_center;
      case 'sports':
        return Icons.sports_baseball_sharp;
      case 'workshops':
        return Icons.work; // Or any workshop-related icon
      default:
        return Icons.category; // Default icon
    }
  }

  static void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple, // Background color
        duration: const Duration(seconds: 3), // Duration to display
        behavior: SnackBarBehavior.floating, // Floating behavior
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        margin: const EdgeInsets.all(20), // Margin around the SnackBar
        elevation: 6, // Elevation
        padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
