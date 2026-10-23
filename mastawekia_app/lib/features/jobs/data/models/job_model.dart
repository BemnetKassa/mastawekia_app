// lib/features/jobs/data/models/job_model.dart

enum JobType { fullTime, partTime, contract, remote, internship }

class JobModel {
  final String id;
  final String title;
  final String description;
  final String companyName;
  final String location;
  final String? salary;
  final String jobType;
  final DateTime createdAt;

  const JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.companyName,
    required this.location,
    this.salary,
    required this.jobType,
    required this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: (json['id'] ?? '') as String,
      title: (json['title'] ?? 'Untitled Position') as String,
      description: (json['description'] ?? '') as String,
      companyName: (json['companyName'] ?? json['company']?['name'] ?? 'Confidential') as String,
      location: (json['location'] ?? 'Remote / Flexible') as String,
      salary: json['salary'] as String?,
      jobType: (json['jobType'] ?? json['type'] ?? 'FULL_TIME') as String,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}