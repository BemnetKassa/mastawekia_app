// lib/features/jobs/presentation/cubit/jobs_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastawekia_app/features/jobs/data/datasources/jobs_remote_datasource.dart';
import 'package:mastawekia_app/features/jobs/presentation/cubit/jobs_state.dart';

class JobsCubit extends Cubit<JobsState> {
  final JobsRemoteDataSource _remoteDataSource;
  String _currentQuery = '';
  String _currentType = 'ALL';

  JobsCubit({required JobsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource,
        super(JobsInitial());

  Future<void> fetchJobs({String? query, String? type}) async {
    if (query != null) _currentQuery = query;
    if (type != null) _currentType = type;

    emit(JobsLoading());
    try {
      final jobs = await _remoteDataSource.getJobs(
        query: _currentQuery,
        type: _currentType,
      );
      emit(JobsLoaded(
        jobs: jobs,
        activeFilter: _currentType,
        searchQuery: _currentQuery,
      ));
    } catch (e) {
      emit(JobsError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  void filterByType(String type) {
    _currentType = type;
    fetchJobs(type: type);
  }

  void searchJobs(String query) {
    _currentQuery = query;
    fetchJobs(query: query);
  }
}