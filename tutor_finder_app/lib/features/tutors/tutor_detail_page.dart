import 'package:flutter/material.dart';
import '../../models/tutor.dart';
import '../lesson_requests/create_request_page.dart';

class TutorDetailPage extends StatelessWidget {
  final Tutor tutor;
  const TutorDetailPage({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    final name = (tutor.user['username'] ?? '').toString();
    final rating = tutor.rating ?? '-';
    final subjectNames = (tutor.subjects)
        .map((e) => (e is Map && e['name'] != null) ? e['name'].toString() : '')
        .where((s) => s.isNotEmpty)
        .join(', ');

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rating: $rating'),
            const SizedBox(height: 8),
            Text('Subjects: $subjectNames'),
            const SizedBox(height: 12),
            Text(tutor.bio ?? ''),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateRequestPage(
                        tutorId: null,
                      ), // or set tutorId if you want binding
                    ),
                  );
                },
                child: const Text('Ders Talep Et'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
