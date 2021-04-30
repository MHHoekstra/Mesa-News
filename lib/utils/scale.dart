import 'dart:ui';

final screenWidth = window.physicalSize.width / window.devicePixelRatio;
final screenHeight = window.physicalSize.height / window.devicePixelRatio;

const baseHeight = 812;
const baseWidth = 375;

double roundToNearestPixel(double size) {
  final ratio = window.devicePixelRatio;
  return (size * ratio).round() / ratio;
}

double scale(double size) {
  if (screenHeight >= baseHeight) {
    return roundToNearestPixel((screenWidth / baseWidth) * size * 0.95);
  }
  return roundToNearestPixel(
      (screenWidth / baseWidth) * (screenHeight / baseHeight) * size);
}
