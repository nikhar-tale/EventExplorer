import 'package:event_explorer/bloc/event_bloc.dart';
import 'package:event_explorer/bloc/event_event.dart';
import 'package:event_explorer/utils/utils.dart';
import 'package:event_explorer/widgets.dart/shimmer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event_state.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../widgets.dart/event_card.dart';

class ListingScreen extends StatefulWidget {
  final Category category;

  const ListingScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen>
    with SingleTickerProviderStateMixin {
  final EventBloc eventBloc = EventBloc();
  final EventBloc searchBloc = EventBloc();
  // ScrollController? listViwController = ScrollController();
  // ScrollController? grideViwController = ScrollController();
  // Track the current view mode
  TextEditingController controller = TextEditingController();

  Event localEvent = Event();
  static ValueNotifier<bool> isSearch = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    eventBloc.add(FetchEventsByCategory(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: appbar(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[appbar(innerBoxIsScrolled: innerBoxIsScrolled)];
          },
          body: ValueListenableBuilder<bool>(
              valueListenable: isSearch,
              builder: (BuildContext context, bool value, child) {
                return BlocBuilder<EventBloc, EventState>(
                  bloc: isSearch.value ? searchBloc : eventBloc,
                  builder: (context, state) {
                    if (state is EventLoading) {
                      Event event = Event(
                          count: 4,
                          request: Request(),
                          item: [Item(), Item(), Item(), Item()]);

                      Widget listview =
                          _buildListView(event: event, isLoading: true);
                      Widget gridview =
                          _buildGridView(event: event, isLoading: true);

                      return ValueListenableBuilder<bool>(
                          valueListenable: Utils.isListView,
                          builder: (BuildContext context, bool value, child) {
                            if (Utils.isListView.value) {
                              return listview;
                            }
                            return gridview;
                          });
                    } else if (state is EventLoaded) {
                      Event event = state.events;

                      Widget listview = _buildListView(
                        event: event,
                      );
                      Widget gridview = _buildGridView(
                        event: event,
                      );

                      return ValueListenableBuilder<bool>(
                          valueListenable: Utils.isListView,
                          builder: (BuildContext context, bool value, child) {
                            if (Utils.isListView.value) {
                              return listview;
                            }
                            return gridview;
                          });
                    } else if (state is EventError) {
                      return Center(child: Text(state.errorMessage));
                    } else {
                      return const Center(child: Text('Unknown state'));
                    }
                  },
                );
              }),
        ),
      ),
    );
  }

  Widget _buildListView({required Event event, bool isLoading = false}) {
    List<Item> items = event.item ?? [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eventDetails(event: event, isLoading: isLoading),
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Text(
                    'No Events Found!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.separated(
                  // controller: listViwController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 10,
                    );
                  },
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final Item item = items[index];
                    return EventCard(
                      item: item,
                      isLoading: isLoading,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGridView({required Event event, bool isLoading = false}) {
    List<Item> items = event.item ?? [];

    return Column(
      children: [
        eventDetails(event: event, isLoading: isLoading),
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            const Text(
                              'No Events Found!',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final Item item = items[index];
                        return EventCard(
                          item: item,
                          isLoading: isLoading,
                          gridView: true,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  appbar({bool innerBoxIsScrolled = false}) {
    IconData iconData = Utils.getCategoryIcon(widget.category!.category ?? '');

    return SliverAppBar(
      pinned: false,
      floating: false,
      elevation: 4,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Hero(
            transitionOnUserGestures: true,
            tag: widget.category.category ?? 'Unknown Category',
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(88, 44, 3, 115),
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            (widget.category.category ?? ''),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: Utils.isListView,
          builder: (BuildContext context, bool value, child) {
            return IconButton(
              icon: Icon(
                Utils.isListView.value
                    ? Icons.grid_view_sharp
                    : Icons.list_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Utils.isListView.value = !Utils.isListView.value;
              },
            );
          },
        ),
      ],
    );
  }

  eventDetails({required Event event, bool isLoading = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShimmerLoading(
                    isLoading: isLoading,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ShimmerLoading(
                    isLoading: isLoading,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Events in ${Utils.capitalizeFirstLetter(event.request!.cityDisplay ?? "")}',
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
              ShimmerLoading(
                isLoading: isLoading,
                child: SizedBox(
                  height: 22,
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(190, 104, 58, 183),
                    child: Text(
                      '${event.count}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Add more icons and text as needed
        ],
      ),
    );
  }

  void onSearchTextChanged(String value) {
    if (value == null || value.isEmpty) {
      isSearch.value = false;
      return;
    }
    searchBloc.add(EventSearch(localEvent, value));
    isSearch.value = true;
  }
}
