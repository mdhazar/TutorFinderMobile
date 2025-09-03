import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../models/tutor.dart';
import '../subjects/subjects_filter.dart';
import 'tutor_detail_page.dart';
import '../lesson_requests/my_requests_page.dart';

class TutorsListPage extends ConsumerStatefulWidget {
  const TutorsListPage({super.key});
  @override
  ConsumerState<TutorsListPage> createState() => _TutorsListPageState();
}

class _TutorsListPageState extends ConsumerState<TutorsListPage> {
  final _searchCtrl = TextEditingController();
  int? _subjectId;
  String _ordering = '-rating';

  @override
  Widget build(BuildContext context) {
    final tutorsAsync = ref.watch(
      tutorsProvider((subjectId: _subjectId, search: _searchCtrl.text)),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutors'),
        actions: [
          IconButton(
            tooltip: 'My Requests',
            icon: const Icon(Icons.list_alt),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MyRequestsPage(initialRole: 'student'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SubjectsFilter(
                    selectedId: _subjectId,
                    onChanged: (v) {
                      setState(() => _subjectId = v);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Search name/bio',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _ordering,
                    items: const [
                      DropdownMenuItem(
                        value: '-rating',
                        child: Text('Top rated'),
                      ),
                      DropdownMenuItem(
                        value: 'rating',
                        child: Text('Low->High'),
                      ),
                      DropdownMenuItem(
                        value: 'hourly_rate',
                        child: Text('Price Low->High'),
                      ),
                      DropdownMenuItem(
                        value: '-hourly_rate',
                        child: Text('Price High->Low'),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => _ordering = v ?? '-rating'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: tutorsAsync.when(
                data: (list) {
                  if (list.isEmpty)
                    return const Center(child: Text('No tutors'));
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final Tutor t = list[i];
                      final name = (t.user['username'] ?? '').toString();
                      final rating = t.rating ?? '-';
                      return ListTile(
                        title: Text(name),
                        subtitle: Text(
                          (t.bio ?? '').toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text('⭐ $rating'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TutorDetailPage(tutor: t),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
