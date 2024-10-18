import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class FormatDates{
  String DateFormatShortMonthYear(String date)
  {
    return DateFormat.yMMMd().format(DateTime.parse(date));
  }
  String DayNumber(String day)
  {
    return DateFormat.d().format(DateTime.parse(day));
  }
  String DayName(String day)
  {
    return DateFormat.E().format(DateTime.parse(day));
  }
}