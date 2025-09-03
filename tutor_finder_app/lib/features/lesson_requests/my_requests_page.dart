import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../data/lesson_requests_repository.dart';

class MyRequestsPage extends ConsumerStatefulWidget {
  final String? initialRole; // 'student' or 'tutor'
  const MyRequestsPage({super.key, this.initialRole});
  @override
  ConsumerState<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends ConsumerState<MyRequestsPage> {
  String _role = 'student';
  String? _status;

  @override
  void initState() {
    super.initState();
    _role = widget.initialRole ?? 'student';
  }

  @override
  Widget build(BuildContext context) {
    final dio = ref.read(dioProvider);
    final repo = LessonRequestsRepository(dio);

    return Scaffold(
      appBar: AppBar(title: const Text('My Requests')),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _role,
                items: const [
                  DropdownMenuItem(value: 'student', child: Text('As Student')),
                  DropdownMenuItem(value: 'tutor', child: Text('As Tutor')),
                ],
                onChanged: (v) => setState(() => _role = v ?? 'student'),
              ),
              const SizedBox(width: 16),
              DropdownButton<String?>(
                value: _status,
                hint: const Text('Status'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'accepted', child: Text('Accepted')),
                  DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                ],
                onChanged: (v) => setState(() => _status = v),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: repo.listMine(role: _role, status: _status),
              builder: (ctx, snap) {
                if (!snap.hasData) {
                  if (snap.hasError)
                    return Center(child: Text('Error: ${snap.error}'));
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snap.data!;
                if (items.isEmpty)
                  return const Center(child: Text('No requests'));
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final r = items[i] as Map<String, dynamic>;
                    final subject = (r['subject']?['name'] ?? '').toString();
                    final status = (r['status'] ?? '').toString();
                    final start = (r['start_time'] ?? '').toString();
                    return ListTile(
                      title: Text(subject),
                      subtitle: Text('$status • $start'),
                      trailing: _role == 'tutor'
                          ? TextButton(
                              onPressed: () async {
                                try {
                                  await repo.updateStatus(
                                    r['id'] as int,
                                    'cancelled',
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cancelled'),
                                      ),
                                    );
                                    setState(() {});
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Cancel'),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
