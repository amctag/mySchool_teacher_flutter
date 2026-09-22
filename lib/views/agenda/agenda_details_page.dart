import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/core/services/external_link_service.dart';
import 'package:my_school_teacher/models/teacher_agenda_item.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';
import 'package:my_school_teacher/views/widgets/status_badge.dart';

class AgendaDetailsPage extends StatefulWidget {
  const AgendaDetailsPage({
    super.key,
    required this.item,
    this.externalLinkService = const ExternalLinkService(),
  });

  final TeacherAgendaItem item;
  final ExternalLinkService externalLinkService;

  @override
  State<AgendaDetailsPage> createState() => _AgendaDetailsPageState();
}

class _AgendaDetailsPageState extends State<AgendaDetailsPage> {
  late TeacherAgendaItem _item;
  bool _publishing = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final imageLink = _item.imageLink?.trim() ?? '';
    final fileLink = _item.fileLink?.trim() ?? '';
    final hasImage = imageLink.isNotEmpty;
    final hasFile = fileLink.isNotEmpty;
    final showPublish = !_item.published && _item.canPublish;
    final showDelete = _item.isOwn;
    return Scaffold(
      appBar: BrandAppBar(
        title: context.l10n.agendaDetails,
        trailing: _item.isOwn
            ? HeaderAction(
                tooltip: context.l10n.editAgenda,
                icon: Icons.edit_rounded,
                onPressed: _edit,
              )
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _item.title,
                        style: context.textStyles.headlineSmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(
                      label: _item.published
                          ? context.l10n.published
                          : context.l10n.draft,
                      icon: _item.published
                          ? Icons.public_outlined
                          : Icons.lock_outline_rounded,
                      color: _item.published
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFF9A825),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaChip(
                      icon: Icons.groups_2_outlined,
                      label: _item.classLabel,
                    ),
                    _MetaChip(
                      icon: Icons.menu_book_outlined,
                      label: _item.courseTitle,
                    ),
                    _MetaChip(
                      icon: Icons.event_outlined,
                      label: [
                        DateFormat.yMMMMd(locale).format(_item.date),
                        if (_item.time.isNotEmpty) _item.time,
                      ].join(' · '),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Text(
              _item.description,
              style: context.textStyles.bodyLarge,
            ),
          ),
          if (hasImage || hasFile) ...[
            const SizedBox(height: 20),
            Text(
              context.l10n.attachments,
              style: context.textStyles.titleSmall,
            ),
            const SizedBox(height: 8),
            if (hasImage) ...[
              _AttachmentCard(
                key: const Key('agenda_open_image'),
                icon: Icons.image_outlined,
                label: context.l10n.image,
                filename: _linkLabel(imageLink),
                previewUrl: _isHttpUrl(imageLink) ? imageLink : null,
                onTap: () => _openImage(context, imageLink),
              ),
              const SizedBox(height: 8),
            ],
            if (hasFile)
              _AttachmentCard(
                key: const Key('agenda_open_pdf'),
                icon: Icons.picture_as_pdf_outlined,
                label: fileLink.toLowerCase().endsWith('.pdf')
                    ? context.l10n.pdf
                    : context.l10n.file,
                filename: _linkLabel(fileLink),
                onTap: () => _openFile(context, fileLink),
              ),
          ],
          if (_item.published) ...[
            const SizedBox(height: 20),
            Text(
              '${context.l10n.publishedOn} ${DateFormat.yMMMd(locale).format(_item.publishDate)}',
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: !showPublish && !showDelete
          ? null
          : Material(
        color: context.colors.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showPublish)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _busy ? null : _publish,
                      child: _publishing
                          ? const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.l10n.publish),
                    ),
                  ),
                if (showPublish && showDelete) const SizedBox(height: 12),
                if (showDelete)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _busy ? null : _confirmDelete,
                      child: _deleting
                          ? const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.l10n.delete),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get _busy => _publishing || _deleting;

  Future<void> _edit() async {
    if (_busy) {
      return;
    }
    final saved = await AppNavigator.agendaEditor(context, item: _item);
    if (saved && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.delete),
        content: Text(context.l10n.deleteItemQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.close),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !mounted) {
      return;
    }
    setState(() => _deleting = true);
    try {
      await context.read<TeacherRepository>().deleteAgenda(_item.id);
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _deleting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    try {
      await context.read<TeacherRepository>().publishAgenda(_item.id);
      if (!mounted) {
        return;
      }
      setState(() {
        _item = _item.copyWith(published: true);
        _publishing = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _publishing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _openFile(BuildContext context, String link) async {
    if (!_isHttpUrl(link)) {
      return;
    }
    final opened = await widget.externalLinkService.website(link);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.openContactFailed)));
    }
  }

  Future<void> _openImage(BuildContext context, String link) async {
    if (!_isHttpUrl(link)) {
      return;
    }
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.86),
      builder: (context) => _ImagePreviewDialog(link: link),
    );
  }

  static bool _isHttpUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static String _linkLabel(String value) {
    final uri = Uri.tryParse(value);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      final name = uri.pathSegments.last;
      if (name.isNotEmpty) {
        return name;
      }
    }
    return value;
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: context.colors.primary),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.labelMedium?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({
    super.key,
    required this.icon,
    required this.label,
    required this.filename,
    required this.onTap,
    this.previewUrl,
  });

  final IconData icon;
  final String label;
  final String filename;
  final VoidCallback onTap;
  final String? previewUrl;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (previewUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    previewUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _AttachmentIcon(icon: icon),
                  ),
                )
              else
                _AttachmentIcon(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: context.textStyles.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      filename,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                color: context.colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentIcon extends StatelessWidget {
  const _AttachmentIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: context.colors.primary),
    );
  }
}

class _ImagePreviewDialog extends StatelessWidget {
  const _ImagePreviewDialog({required this.link});

  final String link;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InteractiveViewer(
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    link,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 8,
            end: 8,
            child: IconButton.filled(
              tooltip: context.l10n.close,
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
