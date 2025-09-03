import 'package:dio/dio.dart';

class LessonRequestsRepository {
  final Dio dio;
  LessonRequestsRepository(this.dio);

  Future<void> create({
    required int subjectId,
    required String startIso,
    required int durationMinutes,
    int? tutorId,
  }) async {
    await dio.post(
      '/lesson-requests/',
      data: {
        'subject_id': subjectId,
        'start_time': startIso,
        'duration_minutes': durationMinutes,
        if (tutorId != null) 'tutor_id': tutorId,
      },
    );
  }

  Future<List<dynamic>> listMine({required String role, String? status}) async {
    final res = await dio.get(
      '/lesson-requests/',
      queryParameters: {'role': role, if (status != null) 'status': status},
    );
    return (res.data['results'] as List? ?? res.data as List);
  }

  Future<void> updateStatus(int id, String status) async {
    await dio.patch('/lesson-requests/$id/', data: {'status': status});
  }

  Future<List<dynamic>> listOpen({String? status}) async {
    final res = await dio.get(
      '/lesson-requests/',
      queryParameters: {'scope': 'open', if (status != null) 'status': status},
    );
    return (res.data['results'] as List? ?? res.data as List);
  }
}
