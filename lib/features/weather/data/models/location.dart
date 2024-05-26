class SearchedLocation {
  int id;
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String url;

  SearchedLocation({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  // Constructor with default values
  SearchedLocation.defaults()
      : id = 0,
        name = '',
        region = '',
        country = '',
        lat = 0.0,
        lon = 0.0,
        url = '';

  // Named constructor for creating a copy
  SearchedLocation.copy(SearchedLocation location)
      : id = location.id,
        name = location.name,
        region = location.region,
        country = location.country,
        lat = location.lat,
        lon = location.lon,
        url = location.url;

  // Method to convert to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'country': country,
      'lat': lat,
      'lon': lon,
      'url': url,
    };
  }

  // Method to create from a map (JSON)
  factory SearchedLocation.fromJson(Map<String, dynamic> json) {
    return SearchedLocation(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
      url: json['url'],
    );
  }
}

// class Location {
//   String name;
//   double lat;
//   double lon;

//   Location({required this.name, required this.lat, required this.lon});

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       name: json['name'],
//       lat: json['lat'],
//       lon: json['lon'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'lat': lat,
//       'lon': lon,
//     };
//   }
// }