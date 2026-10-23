// lib/features/jobs/presentation/screens/seeker_feed_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastawekia_app/core/constants/app_colors.dart';
import 'package:mastawekia_app/core/network/api_client.dart';
import 'package:mastawekia_app/core/widgets/atmospheric_background.dart';
import 'package:mastawekia_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mastawekia_app/features/jobs/data/datasources/jobs_remote_datasource.dart';
import 'package:mastawekia_app/features/jobs/presentation/cubit/jobs_cubit.dart';
import 'package:mastawekia_app/features/jobs/presentation/cubit/jobs_state.dart';
import 'package:mastawekia_app/features/jobs/presentation/widgets/job_card.dart';

class SeekerFeedScreen extends StatelessWidget {
  const SeekerFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide JobsCubit with ApiClient
    return BlocProvider(
      create: (context) => JobsCubit(
        remoteDataSource: JobsRemoteDataSourceImpl(client: ApiClient()),
      )..fetchJobs(),
      child: const _SeekerFeedView(),
    );
  }
}

class _SeekerFeedView extends StatefulWidget {
  const _SeekerFeedView();

  @override
  State<_SeekerFeedView> createState() => _SeekerFeedViewState();
}

class _SeekerFeedViewState extends State<_SeekerFeedView> {
  final _searchController = TextEditingController();
  final List<String> _filters = ['ALL', 'FULL_TIME', 'PART_TIME', 'REMOTE', 'CONTRACT'];
  String _selectedFilter = 'ALL';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore Vacancies',
              style: TextStyle(
                color: AppColors.foreground,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            Text(
              'Curated opportunities on Mastawekia',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            tooltip: 'Sign Out',
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: AtmosphericBackground(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: AppColors.foreground, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by title, company, or keyword...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            context.read<JobsCubit>().searchJobs('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.panelSolid,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.panelBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.panelBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                  ),
                ),
                onSubmitted: (val) => context.read<JobsCubit>().searchJobs(val),
              ),
            ),

            // Horizontal Filter Chips
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter.replaceAll('_', ' ')),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                        context.read<JobsCubit>().filterByType(filter);
                      }
                    },
                    selectedColor: AppColors.accent,
                    backgroundColor: AppColors.panelSolid,
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF0F172A) : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? AppColors.accent : AppColors.panelBorder,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Vacancy List with Pull-to-Refresh
            Expanded(
              child: BlocBuilder<JobsCubit, JobsState>(
                builder: (context, state) {
                  if (state is JobsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }

                  if (state is JobsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.foreground),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                              onPressed: () => context.read<JobsCubit>().fetchJobs(),
                              child: const Text('Try Again', style: TextStyle(color: Color(0xFF0F172A))),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is JobsLoaded) {
                    if (state.jobs.isEmpty) {
                      return RefreshIndicator(
                        color: AppColors.accent,
                        backgroundColor: AppColors.panelSolid,
                        onRefresh: () => context.read<JobsCubit>().fetchJobs(),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 120),
                            Center(
                              child: Column(
                                children: [
                                  Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
                                  SizedBox(height: 12),
                                  Text(
                                    'No vacancies found',
                                    style: TextStyle(
                                      color: AppColors.foreground,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Try adjusting your search or filters.',
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.accent,
                      backgroundColor: AppColors.panelSolid,
                      onRefresh: () => context.read<JobsCubit>().fetchJobs(),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: state.jobs.length,
                        itemBuilder: (context, index) {
                          final job = state.jobs[index];
                          return JobCard(
                            job: job,
                            onTap: () {
                              // We will hook this into JobDetailsScreen
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}