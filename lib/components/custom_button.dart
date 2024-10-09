import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width; // Width parameter
  final double height; // Height parameter
  final double borderRadius; // Border radius parameter

  // Constructor with optional parameters including default values
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = 0.5, // Default width as a percentage of screen width (50%)
    this.height = 0.08, // Default height as a percentage of screen height (10%)
    this.borderRadius = 25.0, // Default border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[700], // Button background color
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(borderRadius), // Use custom border radius
        ),
        padding: EdgeInsets.zero, // Remove default padding
      ),
      child: Container(
        width: screenWidth * width, // Set width based on screen size
        height: screenHeight * height, // Set height based on screen size
        alignment: Alignment.center, // Center the text within the button
        child: Text(
          text,
          overflow: TextOverflow.ellipsis, // Show ellipsis if text overflows
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
