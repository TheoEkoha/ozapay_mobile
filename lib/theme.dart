import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

const primaryColor = Color(0xFF00B9C7);
const secondaryColor = Color(0xFFF0F1F5);
const blueColor = Color(0xFF1D75BD);
const greyColor = Color(0xFF75759E);
const redColor = Color(0xFFE35882);
const shadowColor = Color(0x16171a1f);
const dividerColor = Color(0xFFf3f4f6);
const scaffoldBackground = Color(0xFF24262D);
const yellowColor = Color(0xFFF9D16F);
const borderRadius = kSpacing * 3;
const defaultPadding = kSpacing * 2;
const disabledColor = Color(0xFFC8C8D3);
const lightGreyColor = Color(0xFFB0B0BC);
const darkGrey = Color(0xFF9E9EA9);
const greyDarker = Color(0xFF646464);
const darkBlue = Color(0xFF272459);
const greenColor = Color(0xFF52E34F);
const businessOfferColor = Color(0xFF6A6A6A);

const bodyFont = "Montserrat";
const defaultTextStyle = TextStyle(
  fontFamily: bodyFont,
  color: Colors.black,
);

const lightThemeBgColor = Colors.white;

// Shimmer colors
const shimmerBaseColor = Color.fromARGB(91, 88, 88, 88);
const shimmerHighlightColor = Color.fromARGB(255, 65, 65, 65);

ThemeData theme(BuildContext context) {
  final aspectRatio = MediaQuery.of(context).size.aspectRatio;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: redColor,
      surface: lightThemeBgColor,
      onPrimary: lightThemeBgColor,
      onSecondary: Colors.black87,
      onSurface: Colors.black87,
    ),
    fontFamily: bodyFont,
    appBarTheme: const AppBarTheme(
      backgroundColor: scaffoldBackground,
      foregroundColor: Colors.white,
      shadowColor: Colors.transparent,
      titleSpacing: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontFamily: bodyFont,
        fontWeight: FontWeight.w600,
      ),
      toolbarHeight: 56,
    ),
    scaffoldBackgroundColor: scaffoldBackground,

    // buttons
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: bodyFont,
          letterSpacing: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius * 2),
        ),
        foregroundColor: lightThemeBgColor,
        backgroundColor: primaryColor,
        padding: const EdgeInsets.all(kSpacing * 2),
        disabledForegroundColor: Colors.white,
        disabledBackgroundColor: disabledColor,
        fixedSize: const Size.fromHeight(50),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: bodyFont,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius * 2),
        ),
        foregroundColor: lightThemeBgColor,
        backgroundColor: primaryColor,
        padding: const EdgeInsets.all(kSpacing * 2),
        disabledForegroundColor: Colors.white,
        disabledBackgroundColor: disabledColor,
        fixedSize: const Size.fromHeight(50),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: bodyFont,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius * 2),
        ),
        //side: const BorderSide(color: primaryColor),
        foregroundColor: primaryColor,
        padding: const EdgeInsets.all(kSpacing * 2),
        fixedSize: const Size.fromHeight(50),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: bodyFont,
        ),
        foregroundColor: primaryColor,
        padding: const EdgeInsets.all(kSpacing * 2),
        fixedSize: const Size.fromHeight(50),
      ),
    ),

    // text field
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(borderRadius).copyWith(topRight: Radius.zero),
        borderSide: const BorderSide(color: secondaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(borderRadius).copyWith(topRight: Radius.zero),
        borderSide: const BorderSide(color: secondaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(borderRadius).copyWith(topRight: Radius.zero),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(borderRadius).copyWith(topRight: Radius.zero),
        borderSide: BorderSide(color: Colors.red[700]!, width: 1.5),
      ),
      outlineBorder: const BorderSide(color: primaryColor),
      errorBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(borderRadius).copyWith(topRight: Radius.zero),
        borderSide: BorderSide(color: Colors.red[700]!, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: kSpacing * 2, vertical: kSpacing * 1.75),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith(
        (states) {
          if (states.contains(WidgetState.error)) {
            return TextStyle(color: Colors.red[700]!);
          }
          return const TextStyle(color: primaryColor);
        },
      ),
      hintStyle: const TextStyle(
        fontSize: kSpacing * 2,
        fontWeight: FontWeight.w400,
        color: Color(0xFFBDBDBD),
      ),
      labelStyle: const TextStyle(color: secondaryColor),
      iconColor: primaryColor,
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return secondaryColor;
        }
        return primaryColor;
      }),
      suffixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return secondaryColor;
        }
        return primaryColor;
      }),
      filled: true,
      fillColor: secondaryColor,
      errorMaxLines: 3,
      errorStyle: TextStyle(
        fontSize: 12,
        color: Colors.red[700],
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      headerHeadlineStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      dayStyle: const TextStyle(fontSize: 14),
      headerHelpStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      // headerForegroundColor: lightColor,
      // headerBackgroundColor: primaryColor,
      backgroundColor: lightThemeBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kSpacing * 1.5),
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: lightThemeBgColor,
      shadowColor: shadowColor,
      surfaceTintColor: lightThemeBgColor,
      margin: const EdgeInsets.all(kSpacing * 0.5),
      elevation: 3.5,
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1.5,
      color: dividerColor,
      space: kSpacing * 3,
    ),
    textTheme: TextTheme(
      headlineLarge: defaultTextStyle.copyWith(
        fontSize: aspectRatio > 2 ? 40 : null,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: defaultTextStyle,
      headlineSmall: defaultTextStyle,
      titleLarge: defaultTextStyle.copyWith(
        fontSize: aspectRatio > 2 ? 20 : 18,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: defaultTextStyle.copyWith(
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: defaultTextStyle,
      bodyMedium: defaultTextStyle,
      bodySmall: defaultTextStyle,
      labelLarge: defaultTextStyle,
      labelMedium: defaultTextStyle,
      labelSmall: defaultTextStyle,
    ),
    sliderTheme: SliderThemeData(
      thumbColor: lightThemeBgColor,
      inactiveTrackColor: const Color(0xFFC3EAC7),
      trackHeight: 4,
      overlayShape: SliderComponentShape.noThumb,
      rangeThumbShape: const RoundRangeSliderThumbShape(
        enabledThumbRadius: 10,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: lightThemeBgColor,
      surfaceTintColor: lightThemeBgColor,
    ),

    // Menu
    popupMenuTheme: PopupMenuThemeData(
      color: lightThemeBgColor,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(lightThemeBgColor),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.resolveWith(
          (states) {
            return const Size.square(kSpacing * 4);
          },
        ),
      ),
    ),
    canvasColor: Colors.white,
    dividerColor: Colors.transparent,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) {
        return const Icon(
          OzapayIcons.caret_left,
          size: 28,
        );
      },
    ),
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(
        color: Color(0xFFC7C8CA),
        width: 1,
      ),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
      splashRadius: 18,
    ),
  );
}
