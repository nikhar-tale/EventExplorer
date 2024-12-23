import 'package:event_explorer/models/category.dart';
import 'package:event_explorer/screens/listing.dart';
import 'package:event_explorer/screens/logout.dart';
import 'package:event_explorer/widgets.dart/shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventBloc eventBloc = EventBloc();

  String sectionTitle = 'Categories';
  String title = 'Event Explorer';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  @override
  void initState() {
    super.initState();

    eventBloc.add(FetchCategories());
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    var column = Column(
      children: [
        eventDetails(title: sectionTitle),
        Expanded(
          child: BlocBuilder<EventBloc, EventState>(
            bloc: eventBloc,
            builder: (context, state) {
              if (state is EventLoading) {
                // Display shimmer loading effect
                return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      Object tag = index;
                      return categoryCard(
                          category: Category(), tag: tag, isLoading: true);
                    });
              } else if (state is CategoriesLoaded &&
                  state.categories.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final Category category = state.categories[index];
                    Object tag = category.category ?? 'Unknown Category';
                    return categoryCard(category: category, tag: tag);
                  },
                );
              } else if (state is EventError) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'No Categories Found!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            if (user != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogoutScreen()),
                        );
                      },
                      child: Hero(
                        tag: user!.email!,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user!.photoURL ?? ''),
                          radius: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        body: column,
      ),
    );
  }

  Widget categoryCard(
      {Category? category, bool isLoading = false, required Object tag}) {
    IconData iconData = Utils.getCategoryIcon(category!.category ?? '');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isLoading) return;
          // Navigate to events of the selected category
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListingScreen(
                    category: category,
                  )));
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Hero(
                  transitionOnUserGestures: true,
                  tag: tag,
                  child: ShimmerLoading(
                    isLoading: isLoading,
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(
                        iconData,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ShimmerLoading(
                    isLoading: isLoading,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      height: 24,
                      child: Text(
                        category.category ?? 'Unknown Category',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  eventDetails({required title, bool isLoading = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 15),
                  ShimmerLoading(
                    isLoading: isLoading,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Add more icons and text as needed
        ],
      ),
    );
  }
}
