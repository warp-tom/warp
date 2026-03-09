// ignore_for_file: avoid_print, unused_local_variable
import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  final request = await client.postUrl(Uri.parse('https://rvogjicagenihdpewmgt.supabase.co/auth/v1/signup'));
  request.headers.set('apikey', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2b2dqaWNhZ2VuaWhkcGV3bWd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI5MzQxNDUsImV4cCI6MjA4ODUxMDE0NX0.ZRgUlsjKmZtGZvkIUw-Hei8EDugvYczFg7O31sTVTDA');
  request.headers.set('Content-Type', 'application/json');
  request.write(jsonEncode({'email': 'driver_pure@warp.com', 'password': 'password123', 'phone': '+639200000000'}));
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  print('STATUS: \${response.statusCode}');
  print('BODY: \$responseBody');
}
