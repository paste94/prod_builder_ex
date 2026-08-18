import 'dart:convert';
import 'package:frontend/models.dart';
import 'package:http/http.dart' as http;

const String backendUrl = 'http://localhost:8000';

class SalaryApi {
  static Future<SalaryResponse> calculateNetSalary({
    required SalaryRequest salaryRequest,
  }) async {
    final uri = Uri.parse('$backendUrl/api/v1/net-salary-estimates');

    print('Sending to $uri');
    print('body: ${jsonEncode(salaryRequest.toJson())}');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(salaryRequest.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to calculate net salary: ${response.statusCode} ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return SalaryResponse.fromJson(json);
  }
}
