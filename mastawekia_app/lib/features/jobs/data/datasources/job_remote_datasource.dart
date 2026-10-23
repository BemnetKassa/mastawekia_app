// lib/features/jobs/data/datasources/jobs_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:mastawekia_app/core/constants/api_endpoints.dart';
import 'package:mastawekia_app/core/network/api_client.dart';
import 'package:mastawekia_app/features/jobs/data/models/job_model.dart';

abstract class JobsRemoteDataSource {
  Future<List<JobModel>> getJobs({String? query, String? type});
}

class JobsRemoteDataSourceImpl implements JobsRemoteDataSource {
  final ApiClient _client;

  JobsRemoteDataSourceImpl({required ApiClient client}) : _client = client;

  @override
  Future<List<JobModel>> getJobs({String? query, String? type}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (query != null && query.trim().isNotEmpty) {
        queryParams['search'] = query.trim();
      }
      if (type != null && type.isNotEmpty && type != 'ALL') {
        queryParams['type'] = type;
      }

      final response = await _client.dio.get(
        ApiEndpoints.jobs,
        queryParameters: queryParams,
      );

      final dynamic data = response.data;
      final List<dynamic> list = data is List
          ? data
          : (data['jobs'] ?? data['data'] ?? []);

      return list.map((item) => JobModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Failed to load vacancies';
      throw Exception(message is List ? message.first : message);
    }
  }
}