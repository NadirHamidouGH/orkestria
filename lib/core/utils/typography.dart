import 'package:flutter/material.dart';
import '../constants.dart';

// Font Weights Constants
/// Light font weight, used for subtle text or emphasis
const FontWeight fontWeightLight = FontWeight.w300;

/// Regular font weight for standard text, typically for body text
const FontWeight fontWeightRegular = FontWeight.w400;

/// Medium font weight for moderate emphasis, often used in subheadings
const FontWeight fontWeightMedium = FontWeight.w500;

/// Semi-bold font weight, useful for section headings or emphasized text
const FontWeight fontWeightSemiBold = FontWeight.w600;

/// Bold font weight for strong emphasis, typically for major headings
const FontWeight fontWeightBold = FontWeight.w700;

// Typography Styles

////////////////////heading//////////////////////

/// Main heading style, typically used for primary titles or section headers
const TextStyle heading1 = TextStyle(
  fontSize: fontSizeHeading,
  fontWeight: fontWeightBold,
  height: lineHeightTight,
  color: Colors.white,
);

/// Secondary heading style for sub-titles or secondary titles
const TextStyle heading2 = TextStyle(
  fontSize: fontSizeExtraLarge,
  fontWeight: fontWeightSemiBold,
  height: lineHeightNormal,
  color: Colors.white,
);

////////////////////subtitle//////////////////////

/// Subtitle style, used for secondary headings or key information
const TextStyle subtitle1 = TextStyle(
  fontSize: fontSizeLarge,
  fontWeight: fontWeightMedium,
  height: lineHeightNormal,
  color: Colors.white,
);

/// A smaller subtitle style, often used for less emphasized headings
const TextStyle subtitle2 = TextStyle(
  fontSize: fontSizeMedium,
  fontWeight: fontWeightRegular,
  height: lineHeightRelaxed,
  color: Colors.white,
);
/// Subtitle style, used for secondary headings or key information
const TextStyle subtitle3 = TextStyle(
  fontSize: fontSizeLarge,
  fontWeight: fontWeightLight,
  height: lineHeightTight,
  color: Colors.white70,
);

/// A smaller subtitle style, often used for less emphasized headings
const TextStyle subtitle4 = TextStyle(
  fontSize: fontSizeMedium,
  fontWeight: fontWeightLight,
  height: lineHeightRelaxed,
  color: Colors.white60,
);

/// Subtitle style, used for secondary headings or key information
const TextStyle subtitle1Regular = TextStyle(
  fontSize: fontSizeRegular,
  fontWeight: fontWeightMedium,
  height: lineHeightNormal,
  color: Colors.white,
);

/// A smaller subtitle style, often used for less emphasized headings
const TextStyle subtitle2Regular = TextStyle(
  fontSize: fontSizeSmall,
  fontWeight: fontWeightRegular,
  height: lineHeightRelaxed,
  color: Colors.white,
);
/// Subtitle style, used for secondary headings or key information
const TextStyle subtitle3Regular = TextStyle(
  fontSize: fontSizeSmall,
  fontWeight: fontWeightLight,
  height: lineHeightTight,
  color: Colors.white70,
);

/// A smaller subtitle style, often used for less emphasized headings
const TextStyle subtitle4Regular = TextStyle(
  fontSize: fontSizeSmall,
  fontWeight: fontWeightLight,
  height: lineHeightRelaxed,
  color: Colors.white60,
);


////////////////////bodyText///////////////////////

/// Primary body text style, used for paragraphs and regular content
const TextStyle bodyText1 = TextStyle(
  fontSize: fontSizeRegular,
  fontWeight: fontWeightRegular,
  height: lineHeightNormal,
  color: Colors.white70,
);

/// Secondary body text style, for less emphasized body text
const TextStyle bodyText2 = TextStyle(
  fontSize: fontSizeSmall,
  fontWeight: fontWeightRegular,
  height: lineHeightRelaxed,
  color: Colors.white54,
);

///////////////////////////////////////////


/// Caption style for very small text like footnotes or tooltips
const TextStyle caption = TextStyle(
  fontSize: fontSizeExtraSmall,
  fontWeight: fontWeightLight,
  height: lineHeightRelaxed,
  color: Colors.white38,
);

/// Button text style, used for primary action buttons
const TextStyle buttonText = TextStyle(
  fontSize: fontSizeMedium,
  fontWeight: fontWeightMedium,
  height: lineHeightNormal,
  color: Colors.white,
);

/// Link text style, for clickable or interactive text elements
const TextStyle linkText = TextStyle(
  fontSize: fontSizeMedium,
  fontWeight: fontWeightRegular,
  height: lineHeightNormal,
  color: primaryColor,
  decoration: TextDecoration.underline,
);

/*
*
*

Explanation of the Typography Constants:
Font Sizes:

Extra Small: Use this size for footnotes, tiny labels, or annotations.
Small: Suitable for captions, smaller descriptions, or auxiliary text.
Regular: Ideal for body text in paragraphs or general information.
Medium: For content that's slightly larger than regular text, used in subheadings or callouts.
Large: Primarily for section headings or important content.
Extra Large: Great for major headings or titles that need emphasis.
Heading: For primary titles, large headings, or key sections.
Line Heights:

Tight: Use for minimal spacing between lines, typically in headings.
Normal: Default line height for readability in body text.
Relaxed: More spaced-out text, perfect for larger paragraphs or long content for better readability.
Font Weights:

Light: Subtle emphasis, used for light text or fine details.
Regular: Default weight for most body text and content.
Medium: Slightly emphasized text, useful for subheadings or emphasis.
Semi-Bold: More emphasized for section titles or highlights.
Bold: Strong emphasis, perfect for headings or important items.
Typography Styles:

heading1: Primary heading style for top-level titles or significant headings.
heading2: Secondary heading style for important but less significant titles.
subtitle1: Used for subtitles or key information that needs emphasis.
subtitle2: Smaller subtitles or less emphasized secondary text.
bodyText1: Main body text style for paragraphs and regular content.
bodyText2: Secondary body text style for less important content.
caption: For captions or small annotations.
buttonText: Text style for buttons, typically used for actions.
linkText: For text elements that act as links, with an underline for interactivity.
*
* */