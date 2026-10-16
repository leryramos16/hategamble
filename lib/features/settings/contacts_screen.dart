import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/db/database.dart';
import '../../core/messenger.dart';
import '../../core/native.dart';
import '../../core/providers.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';

/// Opens a chat with [contact] in Messenger. Used here and on the SOS screen.
class MessengerButton extends ConsumerWidget {
  const MessengerButton({super.key, required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: context.l10n.messageOnMessenger,
      icon: const Icon(Icons.forum_outlined),
      onPressed: () async {
        final ok = await openMessengerChat(ref.read(nativeProvider), contact.messenger);
        if (!ok && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.messengerNotInstalled)));
        }
      },
    );
  }
}

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final name = TextEditingController();
    final phone = TextEditingController();
    final messenger = TextEditingController();
    var hotline = false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.addContactTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l.name),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: l.phoneNumber),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: messenger,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: l.messengerLabel,
                    helperText: l.messengerHelper,
                    helperMaxLines: 3,
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: hotline,
                  onChanged: (v) => setState(() => hotline = v!),
                  title: Text(l.isHelpline),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            DialogPrimaryButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.add)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final handle = normalizeMessengerHandle(messenger.text);
    if (messenger.text.trim().isNotEmpty && handle.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.messengerInvalid)));
      }
      return;
    }
    // A contact needs a name and at least one way to reach them.
    if (name.text.trim().isNotEmpty && (phone.text.trim().isNotEmpty || handle.isNotEmpty)) {
      await ref.read(databaseProvider).addContact(ContactsCompanion.insert(
            name: name.text.trim(),
            phone: phone.text.trim(),
            messenger: Value(handle),
            isHotline: Value(hotline),
          ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final contacts = ref.watch(contactsProvider).value ?? const <Contact>[];
    return Scaffold(
      appBar: AppBar(title: Text(l.peopleHelplines)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.person_add_alt),
        label: Text(l.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          Text(
            l.contactsIntro,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (contacts.isEmpty)
            EmptyHint(l.noContacts, icon: Icons.people_outline)
          else
            for (final c in contacts)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: Icon(c.isHotline ? Icons.support_agent : Icons.person_outline),
                    title: Text(c.name),
                    subtitle: Text(c.phone.isNotEmpty ? c.phone : 'Messenger'),
                    onTap: c.phone.isEmpty ? null : () => launchUrl(Uri(scheme: 'tel', path: c.phone)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (c.messenger.isNotEmpty) MessengerButton(contact: c),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            if (await confirmDialog(context,
                                title: l.removeContact(c.name), body: '', confirm: l.remove)) {
                              await ref.read(databaseProvider).deleteContact(c.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
