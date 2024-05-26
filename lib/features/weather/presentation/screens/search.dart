import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/features/weather/data/models/location.dart';
import 'package:weather/features/weather/presentation/controllers/current_location_controller.dart';
import 'package:weather/features/weather/presentation/controllers/weather_controller.dart';
import 'package:weather/features/weather/presentation/widgets/search_field.dart';
import 'package:weather/features/weather/utils/hive_box_names.dart';

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
    final currentLocation = ref.watch(currentLocationProvider(HiveBoxes.preferences.name));
    if (controller.text.isNotEmpty) {
      weatherAsyncValue = ref.watch(searchLocationsProvider(controller.text));
    }
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.fromLTRB(size.width * 0.05, 0, size.width * 0.05, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SearchField(
              controller: controller,
              hint: 'Search location',
              onChanged: (value) {},
              onSubmitted: (value) {
                setState(() {});
              },
              onPressed: () {},
              showButton: false,
            ),
            SizedBox(height: size.height * 0.02),
            if (controller.text.isNotEmpty)
              SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.7,
                child: weatherAsyncValue.when(
                  data: (List<SearchedLocation> searches) => ListView.builder(
                    itemCount: searches.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () => ref
                          .read(currentLocationProvider(HiveBoxes.preferences.name).notifier)
                          .setValue(searches[index].name.toString()),
                      title: Text(searches[index].name.toString()),
                      subtitle: Text(
                          '${searches[index].region.toString()} | ${searches[index].country.toString()}'),
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
      ),
    );
  }
}
