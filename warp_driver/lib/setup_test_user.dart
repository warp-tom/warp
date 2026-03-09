import 'package:supabase/supabase.dart';

void main() async {
  try {
    final client = SupabaseClient(
      'https://rvogjicagenihdpewmgt.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2b2dqaWNhZ2VuaWhkcGV3bWd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI5MzQxNDUsImV4cCI6MjA4ODUxMDE0NX0.ZRgUlsjKmZtGZvkIUw-Hei8EDugvYczFg7O31sTVTDA',
    );
    final res = await client.auth.signUp(
      email: 'driver_mock@warp.com',
      password: 'password123',
    );
    print('USER CREATED: \${res.user?.id}');
  } catch (e) {
    print('ERROR: \${e}');
  }
}
