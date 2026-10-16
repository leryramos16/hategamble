import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/profile.dart';
import '../../l10n/l10n.dart';

class Article {
  const Article({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.minutes,
    required this.body,
  });

  final String id;
  final String category;
  final String title;
  final String summary;
  final int minutes;
  final String body;

  factory Article.fromJson(Map<String, dynamic> j) => Article(
        id: j['id'] as String,
        category: j['category'] as String,
        title: j['title'] as String,
        summary: j['summary'] as String,
        minutes: j['minutes'] as int,
        body: j['body'] as String,
      );
}

/// Articles are bundled with the app (one file per language), so they are available offline.
final articlesProvider = FutureProvider<List<Article>>((ref) async {
  final lang = ref.watch(profileProvider.select((p) => p.language));
  final raw = await rootBundle.loadString(
      lang == 'fil' ? 'assets/content/library_fil.json' : 'assets/content/library.json');
  return (jsonDecode(raw) as List).map((e) => Article.fromJson(e as Map<String, dynamic>)).toList();
});

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String? _category;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    final articles = ref.watch(articlesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.navLearn)),
      body: articles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final categories = {for (final a in all) a.category}.toList();
          final category = categories.contains(_category) ? _category : null;
          final shown = category == null ? all : all.where((a) => a.category == category).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text(l.all),
                      selected: !categories.contains(_category),
                      onSelected: (_) => setState(() => _category = null),
                    ),
                    for (final c in categories)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: _category == c,
                          onSelected: (_) => setState(() => _category = c),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              for (final a in shown)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.push('/article/${a.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.articleMeta(a.category.toUpperCase(), a.minutes),
                                style: t.textTheme.labelSmall?.copyWith(
                                  color: t.colorScheme.primary,
                                  letterSpacing: 0.8,
                                )),
                            const SizedBox(height: 6),
                            Text(a.title, style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(a.summary,
                                style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
