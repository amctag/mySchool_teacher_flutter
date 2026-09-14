import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/controllers/all_class_schedules_controller.dart';
import 'package:my_school_teacher/views/classes/my_classes_page.dart';

class AllClassSchedulesPage extends StatelessWidget {
  const AllClassSchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClassesPageScaffold(
      title: context.l10n.allClassSchedules,
      icon: Icons.map_outlined,
      emptyMessage: context.l10n.noClassesAvailable,
      state: context.watch<AllClassSchedulesController>().state,
      onRefresh: context.read<AllClassSchedulesController>().refresh,
    );
  }
}
