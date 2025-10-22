import 'package:flutter/material.dart';
import 'package:rockdancecompany/public/home/home_page.dart';
import 'package:rockdancecompany/public/about/about_page.dart';
import 'package:rockdancecompany/public/calendar/calendar_photos_page.dart';
import 'package:rockdancecompany/public/contact/contact_page.dart';

Route<dynamic> appOnGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/about':
      return _page(const AboutPage());
    case '/calendar':
      return _page(const CalendarPhotosPage());
    case '/contact':
      return _page(const ContactPage());
    case '/':
    default:
      return _page(const HomePage());
  }
}

MaterialPageRoute _page(Widget child) =>
    MaterialPageRoute(builder: (_) => child);
