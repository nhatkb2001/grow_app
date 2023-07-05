import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//colors used in this app

const Color white = Colors.white;
const Color whiteLight = Color(0xFFF5F5F5);

const Color black = Colors.black;

// const Color purple_first = Color(0xFFFFFFFF);
const Color purpleDark = Color(0xFF9857CB);
const Color purpleLight = Color(0xFFF1E9F6);
const Color purpleMain = Color(0xFF4E3EC8);
const Color purpleHide = Color(0xFF6457D2);
const Color purpleHShadow = Color(0xFFD8C4D9);

const Color greyDark = Color(0xFF6F7175);
const Color greyLight = Color(0xFFAAAAAA);
const Color greyUltralight = Color(0xFFC4C4C4);

const Color red = Color(0xFFCB356B);
const Color green = Color(0xFF159957);

const Color doneColor = Color(0xFFF88868);
const Color todoColor = Color(0xFFFFBF3A);
const Color pendingColor = Color(0xFF4E3EC8);

const Color yellowLight = Color(0xFFFFF8E8);
const Color yellowDark = Color(0xFFFABB18);

final Shader redGradient = LinearGradient(
  colors: <Color>[Color(0xFFCB356B), Color(0xFFBD3F32)],
).createShader(
  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
);
