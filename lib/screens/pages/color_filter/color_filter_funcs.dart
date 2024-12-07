import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'color_filter.dart';
import 'dart:math';

enum ColorblindnessType {
  normal,
  protanopia,
  deuteranopia,
  tritanopia,
  protanomaly,
  deuteranomaly,
  tritanomaly,
  achromatopsia
}

// Protanomaly correction (mild red-green color blindness)
img.Image correctProtanomaly(img.Image image) {
  final result = img.Image.from(image);

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixel = image.getPixel(x, y);
      int r = img.getRed(pixel);
      int g = img.getGreen(pixel);
      int b = img.getBlue(pixel);

      // Enhancement matrix for protanomaly
      int newR = ((0.817 * r + 0.183 * g) * 1.2).round();
      int newG = ((0.333 * r + 0.667 * g) * 1.2).round();
      int newB = b;

      // Clamp values
      newR = min(255, max(0, newR));
      newG = min(255, max(0, newG));
      newB = min(255, max(0, newB));

      result.setPixel(x, y, img.getColor(newR, newG, newB));
    }
  }
  return result;
}
// Protanopia correction (severe red-green color blindness)
img.Image correctProtanopia(img.Image image) {
  final result = img.Image.from(image);

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixel = image.getPixel(x, y);
      int g = img.getGreen(pixel);
      int b = img.getBlue(pixel);

      // Enhancement matrix for protanopia
      int newR = ((0.567 * g + 0.433 * b) * 1.5).round();
      int newG = ((0.558 * g + 0.442 * b) * 1.2).round();
      int newB = ((0.242 * g + 0.758 * b) * 1.0).round();

      // Clamp values
      newR = min(255, max(0, newR));
      newG = min(255, max(0, newG));
      newB = min(255, max(0, newB));

      result.setPixel(x, y, img.getColor(newR, newG, newB));
    }
  }
  return result;
}
// Deuteranomaly correction (mild green-red color blindness)
img.Image correctDeuteranomaly(img.Image image) {
  final result = img.Image.from(image);

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixel = image.getPixel(x, y);
      int r = img.getRed(pixel);
      int g = img.getGreen(pixel);
      int b = img.getBlue(pixel);

      // Enhancement matrix for deuteranomaly
      int newR = ((0.8 * r + 0.2 * g) * 1.2).round();
      int newG = ((0.258 * r + 0.742 * g) * 1.2).round();
      int newB = b;

      // Clamp values
      newR = min(255, max(0, newR));
      newG = min(255, max(0, newG));
      newB = min(255, max(0, newB));

      result.setPixel(x, y, img.getColor(newR, newG, newB));
    }
  }
  return result;
}
// Deuteranopia correction (severe green-red color blindness)
img.Image correctDeuteranopia(img.Image image) {
  final result = img.Image.from(image);

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixel = image.getPixel(x, y);
      int r = img.getRed(pixel);
      int b = img.getBlue(pixel);

      // Enhancement matrix for deuteranopia
      int newR = ((0.625 * r + 0.375 * b) * 1.5).round();
      int newG = ((0.7 * r + 0.3 * b) * 1.2).round();
      int newB = ((0.3 * r + 0.7 * b) * 1.0).round();

      // Clamp values
      newR = min(255, max(0, newR));
      newG = min(255, max(0, newG));
      newB = min(255, max(0, newB));

      result.setPixel(x, y, img.getColor(newR, newG, newB));
    }
  }
  return result;
}
// Tritanomaly correction (mild blue-yellow color blindness)
img.Image correctTritanomaly(img.Image image) {
  final result = img.Image.from(image);

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixel = image.getPixel(x, y);
      int r = img.getRed(pixel);
      int g = img.getGreen(pixel);
      int b = img.getBlue(pixel);

      // Enhancement matrix for tritanomaly
      int newR = r;
      int newG = ((0.875 * g + 0.125 * b) * 1.2).round();
      int newB = ((0.3 * g + 0.7 * b) * 1.3).round();

      // Clamp values
      newR = min(255, max(0, newR));
      newG = min(255, max(0, newG));
      newB = min(255, max(0, newB));

      result.setPixel(x, y, img.getColor(newR, newG, newB));
    }
  }
  return result;
}
// Tritanopia correction (severe blue-yellow color blindness)
img.Image correctTritanopia(img.Image image) {
  final result = img.Image.from(image);

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixel = image.getPixel(x, y);
      int r = img.getRed(pixel);
      int g = img.getGreen(pixel);

      // Enhancement matrix for tritanopia
      int newR = ((0.95 * r + 0.05 * g) * 1.0).round();
      int newG = ((0.433 * r + 0.567 * g) * 1.2).round();
      int newB = ((0.475 * r + 0.525 * g) * 1.4).round();

      // Clamp values
      newR = min(255, max(0, newR));
      newG = min(255, max(0, newG));
      newB = min(255, max(0, newB));

      result.setPixel(x, y, img.getColor(newR, newG, newB));
    }
  }
  return result;
}
// Achromatopsia correction (complete color blindness)
img.Image correctAchromatopsia(img.Image image) {
  final result = img.Image.from(image);

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixel = image.getPixel(x, y);
      int r = img.getRed(pixel);
      int g = img.getGreen(pixel);
      int b = img.getBlue(pixel);

      // Calculate enhanced contrast grayscale
      int luminance = ((0.299 * r + 0.587 * g + 0.114 * b) * 1.5).round();
      luminance = min(255, max(0, luminance));

      // Enhance edges using a simple sharpening technique
      int avgLuminance = 0;
      int count = 0;

      // Calculate average of surrounding pixels
      for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
          if (y + dy >= 0 && y + dy < image.height &&
              x + dx >= 0 && x + dx < image.width) {
            int neighborPixel = image.getPixel(x + dx, y + dy);
            avgLuminance += ((0.299 * img.getRed(neighborPixel) +
                0.587 * img.getGreen(neighborPixel) +
                0.114 * img.getBlue(neighborPixel))).round();
            count++;
          }
        }
      }

      avgLuminance = (avgLuminance / count).round();

      // Apply sharpening
      luminance = min(255, max(0, luminance + (luminance - avgLuminance)));

      result.setPixel(x, y, img.getColor(luminance, luminance, luminance));
    }
  }
  return result;
}

Future<XFile> applyColorblindnessFilter(XFile originalFile, ColorblindnessType filterType) async {
  // Load image data from XFile
  final imageData = await originalFile.readAsBytes();

  // Decode image
  img.Image image = img.decodeImage(imageData)!;

  // Apply the desired colorblindness filter (Protanopia, Deuteranopia, Tritanopia)
  switch (filterType) {
    case ColorblindnessType.protanopia:
      image = correctProtanomaly(image);
      break;
    case ColorblindnessType.deuteranopia:
      image = correctDeuteranopia(image);
      break;
    case ColorblindnessType.tritanopia:
      image = correctTritanopia(image);
      break;
    case ColorblindnessType.achromatopsia:
      image = correctAchromatopsia(image);
      break;
    case ColorblindnessType.deuteranomaly:
      image = correctDeuteranomaly(image);
      break;
    case ColorblindnessType.protanomaly:
      image = correctProtanomaly(image);
      break;
    case ColorblindnessType.tritanomaly:
      image = correctTritanomaly(image);
      break;
    default:
      print('Invalid filter type or normal');
  }

  final newImageBytes = img.encodePng(image!);

  // Create a new temporary file
  final directory = Directory.systemTemp;
  final uniqueFileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';

  // Create a new temporary file path
  final newFilePath = '${directory.path}/$uniqueFileName';

  // Create a new file and write the bytes to it
  final newFile = File(newFilePath);
  // Write the bytes to the new file
  await newFile.writeAsBytes(newImageBytes);

  // Return a new XFile
  return XFile(newFile.path);

}
