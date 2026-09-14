import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/models/teacher_announcement.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/section_card.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  const AnnouncementDetailsPage({super.key, required this.announcement});

  final TeacherAnnouncement announcement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(title: context.l10n.announcementDetails),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: context.textStyles.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  announcement.scopeLabel,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMd().format(announcement.publishedAt),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  announcement.content,
                  style: context.textStyles.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
