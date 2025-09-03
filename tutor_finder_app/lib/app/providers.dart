import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/api_client.dart';
import '../data/subjects_repository.dart';
import '../data/tutors_repository.dart';

final storageProvider = Provider((_) => const FlutterSecureStorage());
final dioProvider = Provider((ref) {
  final dio = Dio();
  final storage = ref.read(storageProvider);
  return ApiClient(dio, storage).dio;
});

final subjectsRepoProvider = Provider(
  (ref) => SubjectsRepository(ref.read(dioProvider)),
);
final tutorsRepoProvider = Provider(
  (ref) => TutorsRepository(ref.read(dioProvider)),
);

final subjectsProvider = FutureProvider(
  (ref) => ref.read(subjectsRepoProvider).list(),
);

final tutorsProvider = FutureProvider.family((
  ref,
  ({int? subjectId, String? search}) args,
) {
  return ref
      .read(tutorsRepoProvider)
      .list(subjectId: args.subjectId, search: args.search);
});
