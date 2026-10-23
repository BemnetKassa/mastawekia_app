// lib/features/jobs/presentation/cubit/jobs_state.dart
import 'package:mastawekia_app/features/jobs/data/models/job_model.dart';

abstract class JobsState {
  const JobsState();
}

class JobsInitial extends JobsState {}

class JobsLoading extends JobsState {}

class JobsLoaded extends JobsState {
  final List<JobModel> jobs;
  final String activeFilter;
  final String searchQuery;

  const JobsLoaded({
    required this.jobs,
    this.activeFilter = 'ALL',
    this.searchQuery = '',
  });
}

class JobsError extends JobsState {
  final String message;
  const JobsError({required this.message});
}