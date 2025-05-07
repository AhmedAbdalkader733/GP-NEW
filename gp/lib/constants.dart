import 'package:flutter/material.dart';

// Main theme color used throughout the app
const Color mainColor = Color(0xFFC2A04C);

// Gradient colors used in the background
const Color gradientStartColor = Color(0xFFD5B977);
const Color gradientEndColor = Color(0xFF181511);

// Common text styles
const TextStyle headerStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: mainColor,
);

const TextStyle bodyStyle = TextStyle(fontSize: 16, color: Colors.black87);

// Common padding values
const double defaultPadding = 16.0;
const EdgeInsets screenPadding = EdgeInsets.all(18.0);
const EdgeInsets cardPadding = EdgeInsets.symmetric(
  horizontal: 22,
  vertical: 30,
);
