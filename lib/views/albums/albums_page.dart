import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/widgets/controller_consumer.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/state/load_state.dart';
import 'package:my_school_teacher/models/teacher_media.dart';
import 'package:my_school_teacher/controllers/media_controllers.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/state_views.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.albums),
      body: ControllerConsumer<AlbumsController, LoadState<List<TeacherAlbum>>>(
        builder: (context, state) {
          final items = state.data;
          return RefreshIndicator(
            onRefresh: context.read<AlbumsController>().refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                if (items == null && state.isLoading)
                  const SizedBox(height: 240, child: LoadingView())
                else if (items == null && state.status == LoadStatus.failure)
                  SizedBox(
                    height: 240,
                    child: ErrorView(
                      onRetry: context.read<AlbumsController>().load,
                    ),
                  )
                else if (items == null || items.isEmpty)
                  SizedBox(
                    height: 180,
                    child: EmptyView(
                      icon: Icons.photo_library_outlined,
                      message: context.l10n.noAlbums,
                    ),
                  )
                else
                  for (final album in items) ...[
                    _AlbumCard(album: album),
                    if (album != items.last) const SizedBox(height: 12),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({required this.album});

  final TeacherAlbum album;

  @override
  Widget build(BuildContext context) {
    final cover = album.coverImage?.trim() ?? '';
    final hasCover =
        cover.startsWith('http://') || cover.startsWith('https://');
    return SectionCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => AppNavigator.albumDetails(context, album),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasCover) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  cover,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(
                    height: 140,
                    child: ColoredBox(
                      color: Color(0x11000000),
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(album.title, style: context.textStyles.titleMedium),
            const SizedBox(height: 4),
            Text(
              '${album.yearTitle} · ${album.photoCount}',
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              album.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat.yMMMd().format(album.date),
              style: context.textStyles.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumDetailsPage extends StatelessWidget {
  const AlbumDetailsPage({super.key, required this.album});

  final TeacherAlbum album;

  @override
  Widget build(BuildContext context) {
    final photos = album.images
        .where(
          (image) =>
              image.imageLink.startsWith('http://') ||
              image.imageLink.startsWith('https://'),
        )
        .toList(growable: false);
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.albumDetails),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(album.title, style: context.textStyles.titleLarge),
                const SizedBox(height: 8),
                Text(
                  '${album.yearTitle} · ${DateFormat.yMMMd().format(album.date)}',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Text(album.description, style: context.textStyles.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (photos.isEmpty)
            EmptyView(
              icon: Icons.photo_outlined,
              message: context.l10n.noPublishedPhotos,
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                // Keep photo tiles close to their mobile size on wide
                // desktop/browser windows instead of stretching 2 huge cells.
                final columns = (constraints.maxWidth / 160)
                    .floor()
                    .clamp(2, 6);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: photos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        photos[index].imageLink,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: Color(0x11000000),
                          child: Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
