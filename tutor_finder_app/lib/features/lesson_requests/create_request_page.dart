import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../models/subject.dart';
import '../../data/lesson_requests_repository.dart';

class CreateRequestPage extends ConsumerStatefulWidget {
  final int? tutorId;
  const CreateRequestPage({super.key, this.tutorId});
  @override
  ConsumerState<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends ConsumerState<CreateRequestPage> {
  int? _subjectId;
  DateTime? _dateTime;
  final _durationCtrl = TextEditingController(text: '60');
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(subjectsProvider);
    final dio = ref.read(dioProvider);
    final repo = LessonRequestsRepository(dio);

    Future<void> submit() async {
      if (_subjectId == null || _dateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select subject and time')),
        );
        return;
      }
      setState(() => _submitting = true);
      try {
        await repo.create(
          subjectId: _subjectId!,
          startIso: _dateTime!.toUtc().toIso8601String(),
          durationMinutes: int.tryParse(_durationCtrl.text) ?? 60,
          tutorId: widget.tutorId,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Request created')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        if (mounted) setState(() => _submitting = false);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Lesson Request')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            subjectsAsync.when(
              data: (list) => DropdownButtonFormField<int>(
                initialValue: _subjectId,
                items: list
                    .map<DropdownMenuItem<int>>(
                      (Subject s) =>
                          DropdownMenuItem(value: s.id, child: Text(s.name)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _subjectId = v),
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Failed to load subjects: $e'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dateTime == null
                        ? 'No date selected'
                        : _dateTime!.toString(),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final date = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 365)),
                    );
                    if (date == null) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time == null) return;
                    final dt = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                    setState(() => _dateTime = dt);
                  },
                  child: const Text('Pick date/time'),
                ),
              ],
            ),
            TextFormField(
              controller: _durationCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : submit,
                child: _submitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
