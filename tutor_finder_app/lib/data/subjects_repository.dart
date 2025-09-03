import 'package:dio/dio.dart';
import 'package:tutor_finder_app/models/subject.dart';

class SubjectsRepository {
  final Dio dio;
  SubjectsRepository(this.dio);

  Future<List<Subject>> list() async {
    final res = await dio.get('/subjects/');
    final results = (res.data['results'] as List? ?? res.data as List);
    return results.map((e) => Subject.fromJson(e)).toList();
  }
}
