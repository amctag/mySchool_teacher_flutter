import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_school_teacher/core/notifications/firebase_web_config.dart';
import 'package:my_school_teacher/core/notifications/push_notification_service.dart';
import 'package:my_school_teacher/services/repositories/teacher_repository.dart';
import 'package:my_school_teacher/controllers/notifications_controller.dart';
import 'package:my_school_teacher/core/extensions/context_x.dart';
import 'package:my_school_teacher/core/navigation/app_navigator.dart';
import 'package:my_school_teacher/models/account.dart';
import 'package:my_school_teacher/views/widgets/brand_app_bar.dart';
import 'package:my_school_teacher/views/widgets/feature_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final destinations = [
      _HomeTile(
        context.l10n.agenda,
        Icons.edit_note_rounded,
        AppNavigator.agenda,
      ),
      _HomeTile(
        context.l10n.grades,
        Icons.grade_rounded,
        AppNavigator.grades,
      ),
      _HomeTile(
        context.l10n.attendance,
        Icons.event_available_rounded,
        AppNavigator.attendances,
      ),
      _HomeTile(
        context.l10n.notices,
        Icons.sticky_note_2_rounded,
        AppNavigator.notices,
      ),
      _HomeTile(
        context.l10n.announcements,
        Icons.campaign_outlined,
        AppNavigator.announcements,
      ),
      _HomeTile(
        context.l10n.myClasses,
        Icons.groups_rounded,
        AppNavigator.myClasses,
      ),
      _HomeTile(
        context.l10n.mySchedule,
        Icons.calendar_view_week_rounded,
        AppNavigator.schedule,
      ),
      _HomeTile(
        context.l10n.activities,
        Icons.celebration_outlined,
        AppNavigator.activities,
      ),
      _HomeTile(
        context.l10n.albums,
        Icons.photo_library_outlined,
        AppNavigator.albums,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 12),
          child: IconButton(
            tooltip: context.l10n.profile,
            onPressed: () => AppNavigator.profile(context),
            icon: CircleAvatar(
              radius: 17,
              backgroundColor: context.colors.onPrimary.withValues(alpha: 0.16),
              foregroundColor: context.colors.onPrimary,
              child: Text(
                account.initials,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        title: Text(context.l10n.appName),
        actions: [
          Consumer<NotificationsController>(
            builder: (context, notifications, _) {
              return HeaderAction(
                buttonKey: const Key('home_notifications'),
                tooltip: context.l10n.notifications,
                icon: Icons.notifications_none_rounded,
                badgeCount: notifications.unreadCount,
                onPressed: () => AppNavigator.notifications(context),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(context),
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      account.fullName,
                      style: context.textStyles.titleLarge,
                    ),
                    if (account.title != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        account.title!,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    if (kIsWeb) const _WebNotificationBanner(),
                    if (kIsWeb) const SizedBox(height: 18),
                    Text(
                      context.l10n.teacherHomeSubtitle,
                      style: context.textStyles.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  // 3 columns on phones, more columns as the window widens so
                  // tiles keep a sane size on tablets and desktop browsers.
                  final columns = (constraints.crossAxisExtent / 160)
                      .floor()
                      .clamp(3, 6);
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 128,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final destination = destinations[index];
                      return FeatureTile(
                        label: destination.label,
                        icon: destination.icon,
                        onTap: () => destination.open(context),
                      );
                    }, childCount: destinations.length),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return context.l10n.goodMorning;
    }
    if (hour < 18) {
      return context.l10n.goodAfternoon;
    }
    return context.l10n.goodEvening;
  }
}

class _WebNotificationBanner extends StatefulWidget {
  const _WebNotificationBanner();

  @override
  State<_WebNotificationBanner> createState() => _WebNotificationBannerState();
}

class _WebNotificationBannerState extends State<_WebNotificationBanner> {
  var _busy = false;
  var _done = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _enable(prompt: false);
    });
  }

  Future<void> _enable({required bool prompt}) async {
    setState(() {
      _busy = prompt;
      _error = null;
    });
    if (kIsWeb && TeacherFirebaseWeb.vapidKey.isEmpty) {
      setState(() {
        _busy = false;
        _error = TeacherFirebaseWeb.vapidConfigError;
      });
      return;
    }
    try {
      final token = await context.read<PushNotificationService>().getToken(
        prompt: prompt,
      );
      if (!mounted) {
        return;
      }
      if (token == null || token.isEmpty) {
        if (!prompt) {
          setState(() => _busy = false);
          return;
        }
        setState(() {
          _busy = false;
          _error = defaultTargetPlatform == TargetPlatform.iOS
              ? 'Could not enable notifications. Open MS Teacher from the home-screen icon (Safari → Add to Home Screen), then try again. iOS 16.4+ is required.'
              : 'Chrome did not allow notifications. Click the lock icon, set Notifications to Allow, then try again.';
        });
        return;
      }
      await context.read<TeacherRepository>().saveFcmToken(token);
      if (!mounted) {
        return;
      }
      setState(() {
        _busy = false;
        _done = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _busy = false;
        _error = prompt
            ? error.toString().replaceFirst('Bad state: ', '')
            : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return const SizedBox.shrink();
    }
    return Material(
      color: context.colors.primaryContainer,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turn on notifications for this browser',
              style: context.textStyles.titleSmall,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _busy ? null : () => _enable(prompt: true),
              child: Text(_busy ? 'Waiting for Chrome...' : 'Allow notifications'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HomeTile {
  const _HomeTile(this.label, this.icon, this.open);

  final String label;
  final IconData icon;
  final void Function(BuildContext context) open;
}
