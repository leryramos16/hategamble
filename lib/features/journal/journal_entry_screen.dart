import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/db/database.dart';
import '../../core/photos.dart';
import '../../core/providers.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';
import 'journal_widgets.dart';

/// Writes a new journal entry for today, or edits an existing one ([entryId]).
class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({super.key, this.entryId});
  final int? entryId;

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _note = TextEditingController();
  JournalEntry? _existing;
  DateTime _at = DateTime.now();
  bool _loaded = false;

  // Photo file names: what's saved, and what's shown now. A photo picked but
  // never saved is deleted when the screen closes, so no files are orphaned.
  String _savedPhoto = '';
  String _photo = '';
  bool _saved = false;

  JournalPhotos get _photos => ref.read(journalPhotosProvider);

  @override
  void initState() {
    super.initState();
    ref.read(journalEntriesProvider.future).then((entries) {
      if (!mounted) return;
      setState(() {
        _existing = entries.where((e) => e.id == widget.entryId).firstOrNull;
        if (_existing != null) {
          _at = _existing!.at;
          _note.text = _existing!.note;
          _savedPhoto = _photo = _existing!.photo;
        }
        _loaded = true;
      });
    });
  }

  @override
  void dispose() {
    _note.dispose();
    if (!_saved && _photo != _savedPhoto) _photos.delete(_photo);
    super.dispose();
  }

  void _setPhoto(String name) {
    if (_photo != _savedPhoto) _photos.delete(_photo);
    setState(() => _photo = name);
  }

  Future<void> _choosePhoto() async {
    final l = context.l10n;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l.takePhoto),
              onTap: () => Navigator.pop(ctx, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l.chooseFromGallery),
              onTap: () => Navigator.pop(ctx, 'gallery'),
            ),
            if (_photo.isNotEmpty)
              ListTile(
                leading: Icon(Icons.delete_outline, color: Theme.of(ctx).colorScheme.error),
                title: Text(l.removePhoto, style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
                onTap: () => Navigator.pop(ctx, 'remove'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    if (action == 'remove') return _setPhoto('');
    final name = await _photos.pick(action == 'camera' ? ImageSource.camera : ImageSource.gallery);
    if (name != null && mounted) _setPhoto(name);
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final note = _note.text.trim();
    if (note.isEmpty && _photo.isEmpty) return;
    if (_existing == null) {
      // Guard the four-a-day limit even if the book changed meanwhile.
      final today = dayOnly(DateTime.now());
      final todays = (await ref.read(journalEntriesProvider.future)).where((e) => dayOnly(e.at) == today);
      if (todays.length >= AppDatabase.maxJournalEntriesPerDay) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.journalDayFull)));
        }
        return;
      }
      await db.addJournalEntry(JournalEntriesCompanion.insert(
        at: DateTime.now(),
        note: Value(note),
        photo: Value(_photo),
      ));
    } else {
      await db.updateJournalEntry(_existing!.id, note: note, photo: _photo);
    }
    _saved = true;
    if (_photo != _savedPhoto) await _photos.delete(_savedPhoto); // replaced or removed
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l = context.l10n;
    if (!await confirmDialog(context,
        title: l.journalDeleteTitle, body: l.journalDeleteBody, confirm: l.delete, destructive: true)) {
      return;
    }
    await ref.read(databaseProvider).deleteJournalEntry(_existing!.id);
    await _photos.delete(_savedPhoto);
    if (_photo != _savedPhoto) await _photos.delete(_photo);
    _saved = true;
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: Text(l.journalWrite),
        actions: [
          if (_existing != null)
            IconButton(tooltip: l.delete, icon: const Icon(Icons.delete_outline), onPressed: _delete),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          JournalPage(controller: _note, date: _at, hint: l.checkInJournalHint, photo: _photos.file(_photo)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _choosePhoto,
              icon: Icon(_photo.isEmpty ? Icons.add_a_photo_outlined : Icons.photo_camera_back_outlined),
              label: Text(_photo.isEmpty ? l.addPhoto : l.changePhoto),
            ),
          ),
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: _note,
            builder: (context, _) => FilledButton(
              onPressed: _note.text.trim().isEmpty && _photo.isEmpty ? null : _save,
              child: Text(l.journalSave),
            ),
          ),
        ],
      ),
    );
  }
}
