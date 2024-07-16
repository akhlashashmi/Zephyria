import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/features/weather/data/models/location.dart';
import 'package:weather/features/weather/presentation/controllers/current_location_controller.dart';
import 'package:weather/features/weather/presentation/controllers/page_controller.dart';
import 'package:weather/features/weather/presentation/controllers/weather_controller.dart';
import 'package:weather/features/weather/presentation/widgets/search_field.dart';
import 'package:weather/features/weather/utils/hive_constants.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  late AsyncValue<List<SearchedLocation>> weatherAsyncValue;

  @override
  Widget build(BuildContext context) {
    final currentLocation =
        ref.read(currentLocationProvider(HiveBoxes.preferences).notifier);
    if (controller.text.isNotEmpty) {
      weatherAsyncValue = ref.watch(searchLocationsProvider(controller.text));
    }
    final selectedIndexNotifier = ref.read(selectedIndexProvider.notifier);
    final pageController = ref.watch(pageControllerProvider);
    final Size size = MediaQuery.of(context).size;

    void onItemTapped(int index) {
      selectedIndexNotifier.setIndex(index);
      pageController.jumpToPage(index);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.07),
          Padding(
            padding: EdgeInsets.fromLTRB(size.width * 0.05, 0, size.width * 0.05, 0),
            child: SearchField(
              controller: controller,
              hint: 'Search location',
              onChanged: (value) {},
              onSubmitted: (value) {
                setState(() {});
              },
              onPressed: () {},
              showButton: false,
            ),
          ),
          if (controller.text.isNotEmpty)
            SizedBox(
              height: size.height * 0.7,
              width: size.width * 0.95,
              child: weatherAsyncValue.when(
                data: (List<SearchedLocation> searches) => ListView.builder(
                  itemCount: searches.length,
                  itemBuilder: (context, index) => ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    onTap: () {
                      currentLocation
                          .setValue('${searches[index].name.toString()}, ${searches[index].region.toString()}');
                      onItemTapped(0);
                    },
                    title: Text(searches[index].name.toString()),
                    subtitle: Text('${searches[index].region.toString()} | ${searches[index].country.toString()}'),
                  ),
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text(
                  err.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
        ],
      ),
    );
  }
}
