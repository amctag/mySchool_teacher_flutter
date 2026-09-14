# Frontend Handoff

## App Details

- **App**: `frontend/my_school_teacher`
- **Stack**: Flutter 3.38.8 / Dart 3.10.7 / Material 3 / `flutter_bloc`
- **Data mode**: API-shaped mock datasource behind repository contracts
- **Current feature pages**: Home, My Schedule, Agenda, Grades, Notices, My Classes, All Class Schedules, Class Details, Profile, Settings, Change Password

## Key Files

- `lib/app.dart` — root app shell and teacher session gate
- `lib/core/navigation/app_navigator.dart` — typed route entry points
- `lib/data/datasources/teacher_data_source.dart` — teacher app data contract
- `lib/data/datasources/mock_teacher_data_source.dart` — deterministic mock backend with mutable write flows
- `lib/data/repositories/teacher_repository.dart` — typed repository facade
- `lib/features/agenda/` — teacher agenda history and CRUD editor
- `lib/features/grades/` — batch grade assessment history and entry editor
- `lib/features/notices/` — teacher notices history and target-aware CRUD editor
- `lib/features/classes/` — assigned classes, all schedules browse, and class details
- `test/` — repository, auth, login, navigation, and class-details coverage

## Current State

- Teacher app is a separate Flutter package copied from the parent baseline and reshaped to the teacher domain.
- Home exposes teacher quick actions only: schedule, agenda, grades, notices, classes, all class schedules.
- Deep feature pages (Agenda, Grades, Notices, My Schedule, My Classes) were redesigned to match the parent app visual language: body-first `TeacherFeatureIntroCard` + card list, no FABs, no CRUD-heavy admin look. Titles are `Agenda`/`Grades`/`Notices` (not "Add ...").
- Sign-in works with the demo path: the `Demo data` chip (ActionChip) fills teacher/school and submits; real auth error text is surfaced. Settings gear was removed from the home app bar and the profile settings row was removed; the home Settings tile was deleted.
- A navigation change adding About/Contact school pages + removing the All Class Schedules tile was made and then REVERTED per user request ("i made a mistake") — `All class schedules` home tile, route, and smoke-test entry are restored; school pages/controllers were deleted.
- My Schedule renders a full timetable grid: `DataTable` always showing all 7 days (Mon–Sun) and at least 7 period rows, blank cells where empty. Fixed `MockTeacherDataSource.fetchTeacherSchedule()` to normalize assignments (`assignment_id`, `class_label` derived) before building schedule days.
- Schedule, Agenda, and Grades editor dropdowns use `isExpanded: true` + `maxLines: 1` / `TextOverflow.ellipsis` to prevent RenderFlex overflow on compact widths.
- Profile, Language, Theme, and Change Password are included in v1.

## Verification

- `flutter gen-l10n`
- `flutter analyze`
- `flutter test`

Latest verification in this session passed with no analyzer issues and the full teacher test suite green. Regression coverage added this session:
`test/ui/schedule_page_test.dart` (7-day/7-period grid), `test/ui/compact_forms_test.dart` (320×800 editor overflow), `test/ui/login_page_test.dart` (demo sign-in), `test/ui/navigation_smoke_test.dart` (no Settings, All class schedules present).

Last re-verified Aug 10 2026: analyze clean + 14 tests green (one-line smoke pass while parent skeleton/age/force changes landed — teacher app untouched).

## Next Steps

1. Replace `MockTeacherDataSource` with a real `ApiTeacherDataSource` once backend endpoints exist.
2. Decide whether agenda should later support richer attachments than the current URL/token field.
3. Decide whether grade editing should expose per-student comments in the UI, not only mock detail data.
4. Decide whether notices should later support course-group targeting in addition to student/section.
5. OPEN QUESTION (Aug 06): user asked to "divide into cells" while running the PARENT app on Android — if the request actually targets the teacher app or returns with more detail, confirm the screen before implementing.
