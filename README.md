# My School Teacher

Flutter Android teacher app for Makarem Preparatory School.

## Current feature set

- authentication and session restore
- my weekly teaching schedule
- agenda create, edit, and delete
- batch grade entry create, edit, and delete
- notices create, edit, and delete
- my classes
- all class schedules browse
- class details with students, schedule, and teacher roster
- profile, language, theme, settings, and password change

## Architecture

- `TeacherDataSource` defines the app data contract
- `MockTeacherDataSource` provides deterministic API-shaped demo data
- `TeacherRepository` maps raw payloads into typed models
- feature controllers use `flutter_bloc`
- views stay presentation-only and reuse shared widgets under `lib/ui/widgets/`

The mock datasource is intentionally shaped so a future `ApiTeacherDataSource` can replace it without redesigning the controllers or views.

## Useful commands

Run the app:

```bash
flutter run -d <device-id>
```

Generate localizations:

```bash
flutter gen-l10n
```

Analyze:

```bash
flutter analyze
```

Test:

```bash
flutter test
```

## Related docs

- `../../PRODUCT.md`
- `../../DESIGN.md`
- `../../docs/api-endpoints-teacher.md`
- `HANDOFF.md`
