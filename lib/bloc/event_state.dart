import 'package:firebase_auth/firebase_auth.dart';

import '../models/category.dart';
import '../models/event.dart';

abstract class EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final Event events;
  final bool isSearch;

  EventLoaded({required this.events, this.isSearch = false});
}

class CategoriesLoaded extends EventState {
  final List<Category> categories;

  CategoriesLoaded({required this.categories});
}

class EventError extends EventState {
  final String errorMessage;

  EventError(this.errorMessage);
}

class SignInWithGoogleSucess extends EventState {
  final UserCredential? userCredential;
  SignInWithGoogleSucess(this.userCredential);
}

class SignOutWithGoogleSucess extends EventState {
  SignOutWithGoogleSucess();
}
