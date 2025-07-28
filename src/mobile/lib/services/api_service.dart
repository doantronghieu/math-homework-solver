import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for the Flask backend - adjust this for your environment
  static const String baseUrl = 'http://localhost:8000/api';
  // For Android emulator, use: 'http://10.0.2.2:8000/api'
  // For iOS simulator, use: 'http://localhost:8000/api'
  // For real device, use your computer's IP address: 'http://192.168.1.xxx:8000/api'
  
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  /// Check if the API server is healthy
  static Future<bool> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: _defaultHeaders,
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'healthy';
      }
      return false;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }

  /// Solve a homework problem by uploading an image
  static Future<Map<String, dynamic>?> solveProblem(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/solve'),
      );

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      // Send request
      final streamedResponse = await request.send().timeout(
        const Duration(minutes: 2), // Allow up to 2 minutes for LLM processing
      );
      
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data;
        }
      }
      
      debugPrint('Solve problem failed: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('Solve problem error: $e');
      return null;
    }
  }
}