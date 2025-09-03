import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../data/lesson_requests_repository.dart';

class OpenRequestsPage extends ConsumerStatefulWidget {
  const OpenRequestsPage({super.key});

  @override
  ConsumerState<OpenRequestsPage> createState() => _OpenRequestsPageState();
}

class _OpenRequestsPageState extends ConsumerState<OpenRequestsPage> {
  bool _busyIdempotent = false;

  @override
  Widget build(BuildContext context) {
    final dio = ref.read(dioProvider);
    final repo = LessonRequestsRepository(dio);
    return Scaffold(
      appBar: AppBar(title: const Text('Open Student Requests')),
      body: FutureBuilder<List<dynamic>>(
        future: repo.listOpen(status: 'pending'),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No open requests'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = items[i] as Map<String, dynamic>;
              final subject = (r['subject']?['name'] ?? '').toString();
              final student = (r['student']?['username'] ?? '').toString();
              final start = (r['start_time'] ?? '').toString();
              return ListTile(
                title: Text(subject),
                subtitle: Text('$student • $start'),
                trailing: TextButton(
                  onPressed: _busyIdempotent
                      ? null
                      : () async {
                          setState(() => _busyIdempotent = true);
                          try {
                            await repo.updateStatus(r['id'] as int, 'accepted');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Accepted')),
                              );
                              // refresh list
                              setState(() => _busyIdempotent = false);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              setState(() => _busyIdempotent = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                  child: const Text('Accept'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
