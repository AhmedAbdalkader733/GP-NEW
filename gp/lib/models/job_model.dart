class Job {
  final String? id;
  final String title;
  final String description;
  final String location;
  final String companyId;
  final String? companyName;
  final String? companyLogo;
  final double salary;
  final String currency;
  final String jobType; // full-time, part-time, contract, etc.
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Job({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.companyId,
    this.companyName,
    this.companyLogo,
    required this.salary,
    required this.currency,
    required this.jobType,
    this.createdAt,
    this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      companyLogo: json['companyLogo'],
      salary: json['salary']?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      jobType: json['jobType'] ?? 'full-time',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'companyId': companyId,
      'salary': salary,
      'currency': currency,
      'jobType': jobType,
    };
  }
}
