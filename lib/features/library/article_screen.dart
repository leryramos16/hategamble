import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import 'library_screen.dart';

class ArticleScreen extends ConsumerWidget {
  const ArticleScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final article = ref.watch(articlesProvider).value?.where((a) => a.id == id).firstOrNull;
    return Scaffold(
      appBar: AppBar(),
      body: article == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              children: [
                Text(context.l10n.articleMetaRead(article.category.toUpperCase(), article.minutes),
                    style: t.textTheme.labelSmall?.copyWith(color: t.colorScheme.primary, letterSpacing: 0.8)),
                const SizedBox(height: 8),
                Text(article.title, style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                ..._renderBody(context, article.body),
              ],
            ),
    );
  }

  /// Tiny renderer for the subset of Markdown used in library.json: "## " headings,
  /// "- " bullets and **bold** spans.
  List<Widget> _renderBody(BuildContext context, String body) {
    final t = Theme.of(context);
    final para = t.textTheme.bodyLarge?.copyWith(height: 1.55);
    final widgets = <Widget>[];
    for (final block in body.split('\n\n')) {
      final lines = block.split('\n');
      if (lines.first.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(lines.first.substring(3), style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ));
        lines.removeAt(0);
      }
      for (final line in lines) {
        if (line.startsWith('- ')) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 12),
                  child: CircleAvatar(radius: 3, backgroundColor: t.colorScheme.primary),
                ),
                Expanded(child: Text.rich(_inline(line.substring(2)), style: para)),
              ],
            ),
          ));
        } else if (line.trim().isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text.rich(_inline(line), style: para),
          ));
        }
      }
    }
    return widgets;
  }

  TextSpan _inline(String text) {
    final parts = text.split('**');
    return TextSpan(children: [
      for (var i = 0; i < parts.length; i++)
        TextSpan(text: parts[i], style: i.isOdd ? const TextStyle(fontWeight: FontWeight.w700) : null),
    ]);
  }
}
