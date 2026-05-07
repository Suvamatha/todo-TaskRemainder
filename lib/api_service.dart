// import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  // static const String baseUrl = 'http://10.0.2.2:3000';

//save token to device storage
  static Future<void> saveToken(String token) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

//get token from device storage
  static Future<String?> getToken()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

//delete token(logout)
static Future<void> deleteToken()async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}

  static Future<List<dynamic>> getTasks() async{
    final response = await http.get(Uri.parse('$baseUrl/tasks'));

    if(response.statusCode == 200){
      return jsonDecode(response.body);

    }else{
      throw Exception("Failed to load Task");
    }
  }
  static Future<void> createTask(String title, String priority, String? dueDate) async{
    await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
        "title":title, 
        "priority": priority,
        "dueDate": dueDate
        }),
    );
  }
//register
static Future<void> register(String email, String password)async{
  await http.post(
    Uri.parse('$baseUrl/auth/register'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"email": email, "password": password}),
  );
}

//login - return token
static Future<String> login(String email, String password)async{
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"email": email, "password": password}),
  );
  if(response.statusCode==200){
    final data = jsonDecode(response.body);
    return data['token'];
  }else{
    throw Exception("Login Failed");
  }
}

  static Future<void>deleteTask(String id)async{
    await http.delete(Uri.parse('$baseUrl/tasks/$id'));
  }
  static Future<void>toggleTask(String id)async{
    await http.patch(Uri.parse('$baseUrl/tasks/$id'));
  }
}