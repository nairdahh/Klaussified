# Poppins Fonts Setup

## Download Instructions

The Klaussified app uses the **Poppins** font family. Please download the fonts from Google Fonts:

**Download Link:** https://fonts.google.com/specimen/Poppins

## Required Font Files

Download and place the following files in this directory (`assets/fonts/`):

- `Poppins-Regular.ttf` (Weight: 400)
- `Poppins-Medium.ttf` (Weight: 500)
- `Poppins-SemiBold.ttf` (Weight: 600)
- `Poppins-Bold.ttf` (Weight: 700)

## Steps to Download:

1. Go to https://fonts.google.com/specimen/Poppins
2. Click "Download family" button
3. Extract the ZIP file
4. Copy the required font files (listed above) from the extracted folder
5. Paste them into this directory: `assets/fonts/`

## Alternative: Using Google Fonts Package

If you prefer not to download manually, you can use the `google_fonts` package instead:

1. Add to `pubspec.yaml`:
   ```yaml
   dependencies:
     google_fonts: ^6.1.0
   ```

2. Replace font usage in theme files with:
   ```dart
   import 'package:google_fonts/google_fonts.dart';

   textTheme: GoogleFonts.poppinsTextTheme(),
   ```

This will download fonts dynamically at runtime.

## Current Status

**⚠️ Font files are NOT included in this repository.**

Please download them before running the app to avoid font rendering issues.
