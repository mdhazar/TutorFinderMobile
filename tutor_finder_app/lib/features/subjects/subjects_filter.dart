import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../models/subject.dart';

class SubjectsFilter extends ConsumerWidget {
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  const SubjectsFilter({super.key, this.selectedId, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsProvider);
    return subjectsAsync.when(
      data: (list) {
        final items = <DropdownMenuItem<int?>>[
          const DropdownMenuItem(value: null, child: Text('All subjects')),
          ...list.map(
            (Subject s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
          ),
        ];
        return DropdownButtonFormField<int?>(
          initialValue: selectedId,
          items: items,
          onChanged: onChanged,
          decoration: const InputDecoration(labelText: 'Subject'),
        );
      },
      loading: () => const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Failed to load subjects: $e'),
    );
  }
}
