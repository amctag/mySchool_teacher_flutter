import 'package:equatable/equatable.dart';

enum AttendanceStatus {
  present,
  absent,
  late,
  excused;

  static AttendanceStatus fromJson(String value) =>
      AttendanceStatus.values.firstWhere((status) => status.name == value);
}

class AttendanceSummary extends Equatable {
  const AttendanceSummary({
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
    required this.total,
    required this.percentage,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) =>
      AttendanceSummary(
        present: json['present'] as int,
        absent: json['absent'] as int,
        late: json['late'] as int,
        excused: json['excused'] as int,
        total: json['total'] as int,
        percentage: (json['percentage'] as num).toDouble(),
      );

  final int present;
  final int absent;
  final int late;
  final int excused;
  final int total;
  final double percentage;

  @override
  List<Object?> get props => [
    present,
    absent,
    late,
    excused,
    total,
    percentage,
  ];
}

class AttendanceRecord extends Equatable {
  const AttendanceRecord({
    required this.date,
    required this.status,
    this.reason,
    this.description,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      AttendanceRecord(
        date: DateTime.parse(json['date'] as String),
        status: AttendanceStatus.fromJson(json['status'] as String),
        reason: json['reason'] as String?,
        description: json['description'] as String?,
      );

  final DateTime date;
  final AttendanceStatus status;
  final String? reason;
  final String? description;

  bool get isAbsent => status == AttendanceStatus.absent;

  @override
  List<Object?> get props => [date, status, reason, description];
}

class AttendanceMonth extends Equatable {
  const AttendanceMonth({
    required this.childId,
    required this.month,
    required this.summary,
    required this.records,
  });

  factory AttendanceMonth.fromJson(Map<String, dynamic> json) =>
      AttendanceMonth(
        childId: json['child_id'] as int,
        month: DateTime.parse('${json['month'] as String}-01'),
        summary: AttendanceSummary.fromJson(
          json['summary'] as Map<String, dynamic>,
        ),
        records: (json['records'] as List<dynamic>)
            .map(
              (item) => AttendanceRecord.fromJson(item as Map<String, dynamic>),
            )
            .toList(growable: false),
      );

  final int childId;
  final DateTime month;
  final AttendanceSummary summary;
  final List<AttendanceRecord> records;

  @override
  List<Object?> get props => [childId, month, summary, records];
}
