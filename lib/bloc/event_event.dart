import 'package:event_explorer/models/category.dart';
import 'package:event_explorer/models/event.dart';

abstract class EventEvent {}

class FetchCategories extends EventEvent {}

class FetchEventsByCategory extends EventEvent {
  final Category category;

  FetchEventsByCategory(this.category);
}

class SignInWithGoogle extends EventEvent {
  SignInWithGoogle();
}

class SignOutWithGoogle extends EventEvent {
  SignOutWithGoogle();
}

class EventSearch extends EventEvent {
  Event localEvent;
  String searchKeybord;

  EventSearch(this.localEvent, this.searchKeybord);
}
