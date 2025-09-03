import 'package:flutter/material.dart';
import 'package:tutor_finder_app/features/lesson_requests/my_requests_page.dart';
import 'package:tutor_finder_app/features/lesson_requests/open_requests_page.dart';

class TutorDashboardPage extends StatelessWidget {
  const TutorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutor Dashboard')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Welcome! Manage your tutoring here.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyRequestsPage(initialRole: 'tutor'),
                ),
              ),
              child: const Text('View Student Requests'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OpenRequestsPage()),
              ),
              child: const Text('Browse Open Requests'),
            ),
          ],
        ),
      ),
    );
  }
}
