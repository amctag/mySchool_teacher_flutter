import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:my_school_teacher/core/services/external_link_service.dart';

enum ContactAction { call, whatsapp, directions, website, email }

class ContactActionController extends NotifierController<ContactAction?> {
  ContactActionController({required ExternalLinkService externalLinkService})
    : _externalLinkService = externalLinkService,
      super(null);

  final ExternalLinkService _externalLinkService;

  Future<void> call(String telephone) =>
      _run(ContactAction.call, _externalLinkService.call(telephone));

  Future<void> whatsapp(String mobile) =>
      _run(ContactAction.whatsapp, _externalLinkService.whatsapp(mobile));

  Future<void> directions(String address) =>
      _run(ContactAction.directions, _externalLinkService.directions(address));

  Future<void> website(String website) =>
      _run(ContactAction.website, _externalLinkService.website(website));

  Future<void> email(String email) =>
      _run(ContactAction.email, _externalLinkService.email(email));

  Future<void> _run(ContactAction action, Future<bool> operation) async {
    if (await operation) {
      return;
    }
    if (state != null) {
      emit(null);
    }
    emit(action);
  }
}
