// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

void main() async {
  final url = 'https://rvogjicagenihdpewmgt.supabase.co/auth/v1/signup';
  final anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2b2dqaWNhZ2VuaWhkcGV3bWd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI5MzQxNDUsImV4cCI6MjA4ODUxMDE0NX0.ZRgUlsjKmZtGZvkIUw-Hei8EDugvYczFg7O31sTVTDA';
  
  final client = HttpClient();
  try {
    final request = await client.postUrl(Uri.parse(url));
    request.headers.set('apikey', anonKey);
    request.headers.set('Content-Type', 'application/json');
    request.add(utf8.encode(jsonEncode({
      'email': 'driver@warp.com',
      'password': 'password123',
    })));
    
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    
    print('Status Code: ${response.statusCode}');
    print('Response Body: $body');
  } catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
