import 'package:dio/dio.dart';
import 'package:tutor_finder_app/models/tutor.dart';

class TutorsRepository {
  final Dio dio;
  TutorsRepository(this.dio);

  Future<List<Tutor>> list({
    int? subjectId,
    String? search,
    String ordering = '-rating',
  }) async {
    final res = await dio.get(
      '/tutors/',
      queryParameters: {
        if (subjectId != null) 'subject': subjectId,
        if (search != null && search.isNotEmpty) 'search': search,
        'ordering': ordering,
      },
    );
    final results = (res.data['results'] as List? ?? res.data as List);
    return results.map((e) => Tutor.fromJson(e)).toList();
  }
}
