// event_bloc.dart

import 'package:event_explorer/models/network_response.dart';
import 'package:event_explorer/services/network_service.dart';
import 'package:event_explorer/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';
import '../models/event.dart';
import '../services/test_env.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final NetworkService networkService = NetworkService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TestEnv testEnv = TestEnv();
  EventBloc() : super(EventLoading()) {
    on<EventEvent>((event, emit) async {
      if (event is FetchCategories) {
        try {
          List<Category> categories = await fetchCategories();

          emit(CategoriesLoaded(categories: categories));
        } catch (e) {
          emit(EventError('Failed to fetch Categories: $e'));
        }
      }

      if (event is FetchEventsByCategory) {
        try {
          Event events = await fetchEventsByCategory(event);

          emit(EventLoaded(events: events));
        } catch (e) {
          emit(EventError('Failed to fetch Categories: $e'));
        }
      }

      if (event is SignInWithGoogle) {
        try {
          emit(EventLoading());
          emit(SignInWithGoogleSucess(await _signInWithGoogle()));
        } catch (e) {
          emit(EventError('Failed to SignIn With Google: $e'));
        }
      }
      if (event is SignOutWithGoogle) {
        try {
          emit(EventLoading());
          await _signOut();
          emit(SignOutWithGoogleSucess());
        } catch (e) {
          emit(EventError('Failed to SignOut With Google: $e'));
        }
      }

      if (event is EventSearch) {
        try {
          emit(EventLoading());

          Event events = await onSearchText(event);
          emit(EventLoaded(events: events, isSearch: true));
        } catch (e) {
          emit(EventError('Failed to SignOut With Google: $e'));
        }
      }
    });
  }

  Future<Event> onSearchText(EventSearch event) async {
    Event _localEvent = event.localEvent;
    String _searchKeybord = event.searchKeybord;

    List<Item>? _searchResult = [];
    _localEvent.item!.forEach((Item item) {
      if (item.eventnameRaw!.contains(_searchKeybord) ||
          item.location!.contains(_searchKeybord)) {
        print("found");
        _searchResult.add(item);
      }
    });

    _localEvent.item = _searchResult;
    return _localEvent;
  }

  Future<dynamic> _signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await _auth.signOut();
      await _googleSignIn.signOut();

      await prefs.setBool(Utils.isNewUser, true);

      return;
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? _isNewUser = prefs.getBool(Utils.isNewUser);
      if (_isNewUser == true) {
        await _auth.signOut();
        await _googleSignIn.signOut();
      }
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await prefs.setBool(Utils.isNewUser, false);
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      ResponseModel response =
          await networkService.get(testEnv.testCategoriesURL);

      if (response.statusCode == 200) {
        return response.data
            .map<Category>((i) => Category.fromJson(i))
            .toList();
      }
      throw (response.statusCode);
    } catch (e) {
      rethrow;
    }
  }

  fetchEventsByCategory(FetchEventsByCategory event) async {
    try {
      String _url = event.category.data!;
      ResponseModel response = await networkService.get(_url);

      if (response.statusCode == 200) {
        return Event.fromJson(response.data);
      }
      throw (response.statusCode);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
