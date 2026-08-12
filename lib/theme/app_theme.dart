import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens ported from the "Minha Costureira" Claude Design prototype
/// (direção 1a — the full clickable flow).
class AppColors {
  AppColors._();

  static const bg = Color(0xFFF7F2EC);
  static const surface = Color(0xFFECE3D8);
  static const text = Color(0xFF23212B);
  static final divider = text.withValues(alpha: 0.16);

  static const accent = Color(0xFF5E69BD);
  static const accent100 = Color(0xFFF0F2FF);
  static const accent200 = Color(0xFFDFE3FB);
  static const accent300 = Color(0xFFC3CAF4);
  static const accent400 = Color(0xFF9EA9E8);
  static const accent500 = Color(0xFF7B86D8);
  static const accent600 = Color(0xFF5E69BD);
  static const accent700 = Color(0xFF47519A);
  static const accent800 = Color(0xFF333A71);
  static const accent900 = Color(0xFF22264D);

  static const accent2 = Color(0xFFC96B7A);
  static const accent2_100 = Color(0xFFFFF0F1);
  static const accent2_200 = Color(0xFFFBDEE1);
  static const accent2_300 = Color(0xFFF4C1C7);
  static const accent2_400 = Color(0xFFE79BA5);
  static const accent2_500 = Color(0xFFD67C88);
  static const accent2_600 = Color(0xFFBB5E6B);
  static const accent2_700 = Color(0xFF984855);
  static const accent2_800 = Color(0xFF70333D);
  static const accent2_900 = Color(0xFF4C2129);

  static const neutral100 = Color(0xFFFAF7F3);
  static const neutral200 = Color(0xFFF1EBE3);
  static const neutral300 = Color(0xFFDED6CB);
  static const neutral400 = Color(0xFFC2B8AB);
  static const neutral500 = Color(0xFFA3998C);
  static const neutral600 = Color(0xFF847B6F);
  static const neutral700 = Color(0xFF665F55);
  static const neutral800 = Color(0xFF49443C);
  static const neutral900 = Color(0xFF2F2B26);

  static const skin = Color(0xFFD9A179);
  static const skinShade = Color(0xFFC4855C);
}

class AppRadius {
  AppRadius._();
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 28.0;
  static const pill = 999.0;
}

class AppShadows {
  AppShadows._();
  static List<BoxShadow> sm = [
    BoxShadow(
      color: AppColors.neutral900.withValues(alpha: 0.15),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  static List<BoxShadow> md = [
    BoxShadow(
      color: AppColors.neutral900.withValues(alpha: 0.17),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
  static List<BoxShadow> lg = [
    BoxShadow(
      color: AppColors.neutral900.withValues(alpha: 0.23),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];
}

TextStyle headingFont({
  required double fontSize,
  Color color = AppColors.text,
  FontWeight weight = FontWeight.w700,
  double? height,
  double letterSpacing = -0.03,
}) {
  return GoogleFonts.bricolageGrotesque(
    fontSize: fontSize,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing * fontSize / 10,
  );
}

TextStyle bodyFont({
  required double fontSize,
  Color color = AppColors.text,
  FontWeight weight = FontWeight.w400,
  double? height,
}) {
  return GoogleFonts.interTight(
    fontSize: fontSize,
    fontWeight: weight,
    color: color,
    height: height,
  );
}

Color textMuted(double opacity) => AppColors.text.withValues(alpha: opacity);

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
      surface: AppColors.bg,
    ),
    fontFamily: GoogleFonts.interTight().fontFamily,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
      fontFamily: GoogleFonts.interTight().fontFamily,
    ),
  );
}
