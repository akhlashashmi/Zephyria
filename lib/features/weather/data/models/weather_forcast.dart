import 'package:json_annotation/json_annotation.dart';

part 'weather_forcast.g.dart';

@JsonSerializable()
class WeatherForcast {
    @JsonKey(name: "location")
    final Location location;
    @JsonKey(name: "current")
    final Current current;
    @JsonKey(name: "forecast")
    final Forecast forecast;

    WeatherForcast({
        required this.location,
        required this.current,
        required this.forecast,
    });

    WeatherForcast copyWith({
        Location? location,
        Current? current,
        Forecast? forecast,
    }) => 
        WeatherForcast(
            location: location ?? this.location,
            current: current ?? this.current,
            forecast: forecast ?? this.forecast,
        );

    factory WeatherForcast.fromJson(Map<String, dynamic> json) => _$WeatherForcastFromJson(json);

    Map<String, dynamic> toJson() => _$WeatherForcastToJson(this);
}

@JsonSerializable()
class Current {
    @JsonKey(name: "last_updated_epoch")
    final int lastUpdatedEpoch;
    @JsonKey(name: "last_updated")
    final String lastUpdated;
    @JsonKey(name: "temp_c")
    final double tempC;
    @JsonKey(name: "temp_f")
    final double tempF;
    @JsonKey(name: "is_day")
    final int isDay;
    @JsonKey(name: "condition")
    final Condition condition;
    @JsonKey(name: "wind_mph")
    final double windMph;
    @JsonKey(name: "wind_kph")
    final double windKph;
    @JsonKey(name: "wind_degree")
    final int windDegree;
    @JsonKey(name: "wind_dir")
    final String windDir;
    @JsonKey(name: "pressure_mb")
    final int pressureMb;
    @JsonKey(name: "pressure_in")
    final double pressureIn;
    @JsonKey(name: "precip_mm")
    final int precipMm;
    @JsonKey(name: "precip_in")
    final int precipIn;
    @JsonKey(name: "humidity")
    final int humidity;
    @JsonKey(name: "cloud")
    final int cloud;
    @JsonKey(name: "feelslike_c")
    final double feelslikeC;
    @JsonKey(name: "feelslike_f")
    final double feelslikeF;
    @JsonKey(name: "windchill_c")
    final double windchillC;
    @JsonKey(name: "windchill_f")
    final double windchillF;
    @JsonKey(name: "heatindex_c")
    final double heatindexC;
    @JsonKey(name: "heatindex_f")
    final double heatindexF;
    @JsonKey(name: "dewpoint_c")
    final double dewpointC;
    @JsonKey(name: "dewpoint_f")
    final double dewpointF;
    @JsonKey(name: "vis_km")
    final int visKm;
    @JsonKey(name: "vis_miles")
    final int visMiles;
    @JsonKey(name: "uv")
    final int uv;
    @JsonKey(name: "gust_mph")
    final double gustMph;
    @JsonKey(name: "gust_kph")
    final double gustKph;

    Current({
        required this.lastUpdatedEpoch,
        required this.lastUpdated,
        required this.tempC,
        required this.tempF,
        required this.isDay,
        required this.condition,
        required this.windMph,
        required this.windKph,
        required this.windDegree,
        required this.windDir,
        required this.pressureMb,
        required this.pressureIn,
        required this.precipMm,
        required this.precipIn,
        required this.humidity,
        required this.cloud,
        required this.feelslikeC,
        required this.feelslikeF,
        required this.windchillC,
        required this.windchillF,
        required this.heatindexC,
        required this.heatindexF,
        required this.dewpointC,
        required this.dewpointF,
        required this.visKm,
        required this.visMiles,
        required this.uv,
        required this.gustMph,
        required this.gustKph,
    });

    Current copyWith({
        int? lastUpdatedEpoch,
        String? lastUpdated,
        double? tempC,
        double? tempF,
        int? isDay,
        Condition? condition,
        double? windMph,
        double? windKph,
        int? windDegree,
        String? windDir,
        int? pressureMb,
        double? pressureIn,
        int? precipMm,
        int? precipIn,
        int? humidity,
        int? cloud,
        double? feelslikeC,
        double? feelslikeF,
        double? windchillC,
        double? windchillF,
        double? heatindexC,
        double? heatindexF,
        double? dewpointC,
        double? dewpointF,
        int? visKm,
        int? visMiles,
        int? uv,
        double? gustMph,
        double? gustKph,
    }) => 
        Current(
            lastUpdatedEpoch: lastUpdatedEpoch ?? this.lastUpdatedEpoch,
            lastUpdated: lastUpdated ?? this.lastUpdated,
            tempC: tempC ?? this.tempC,
            tempF: tempF ?? this.tempF,
            isDay: isDay ?? this.isDay,
            condition: condition ?? this.condition,
            windMph: windMph ?? this.windMph,
            windKph: windKph ?? this.windKph,
            windDegree: windDegree ?? this.windDegree,
            windDir: windDir ?? this.windDir,
            pressureMb: pressureMb ?? this.pressureMb,
            pressureIn: pressureIn ?? this.pressureIn,
            precipMm: precipMm ?? this.precipMm,
            precipIn: precipIn ?? this.precipIn,
            humidity: humidity ?? this.humidity,
            cloud: cloud ?? this.cloud,
            feelslikeC: feelslikeC ?? this.feelslikeC,
            feelslikeF: feelslikeF ?? this.feelslikeF,
            windchillC: windchillC ?? this.windchillC,
            windchillF: windchillF ?? this.windchillF,
            heatindexC: heatindexC ?? this.heatindexC,
            heatindexF: heatindexF ?? this.heatindexF,
            dewpointC: dewpointC ?? this.dewpointC,
            dewpointF: dewpointF ?? this.dewpointF,
            visKm: visKm ?? this.visKm,
            visMiles: visMiles ?? this.visMiles,
            uv: uv ?? this.uv,
            gustMph: gustMph ?? this.gustMph,
            gustKph: gustKph ?? this.gustKph,
        );

    factory Current.fromJson(Map<String, dynamic> json) => _$CurrentFromJson(json);

    Map<String, dynamic> toJson() => _$CurrentToJson(this);
}

@JsonSerializable()
class Condition {
    @JsonKey(name: "text")
    final String text;
    @JsonKey(name: "icon")
    final String icon;
    @JsonKey(name: "code")
    final int code;

    Condition({
        required this.text,
        required this.icon,
        required this.code,
    });

    Condition copyWith({
        String? text,
        String? icon,
        int? code,
    }) => 
        Condition(
            text: text ?? this.text,
            icon: icon ?? this.icon,
            code: code ?? this.code,
        );

    factory Condition.fromJson(Map<String, dynamic> json) => _$ConditionFromJson(json);

    Map<String, dynamic> toJson() => _$ConditionToJson(this);
}

@JsonSerializable()
class Forecast {
    @JsonKey(name: "forecastday")
    final List<Forecastday> forecastday;

    Forecast({
        required this.forecastday,
    });

    Forecast copyWith({
        List<Forecastday>? forecastday,
    }) => 
        Forecast(
            forecastday: forecastday ?? this.forecastday,
        );

    factory Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);

    Map<String, dynamic> toJson() => _$ForecastToJson(this);
}

@JsonSerializable()
class Forecastday {
    @JsonKey(name: "date")
    final DateTime date;
    @JsonKey(name: "date_epoch")
    final int dateEpoch;
    @JsonKey(name: "day")
    final Day day;
    @JsonKey(name: "astro")
    final Astro astro;
    @JsonKey(name: "hour")
    final List<Hour> hour;

    Forecastday({
        required this.date,
        required this.dateEpoch,
        required this.day,
        required this.astro,
        required this.hour,
    });

    Forecastday copyWith({
        DateTime? date,
        int? dateEpoch,
        Day? day,
        Astro? astro,
        List<Hour>? hour,
    }) => 
        Forecastday(
            date: date ?? this.date,
            dateEpoch: dateEpoch ?? this.dateEpoch,
            day: day ?? this.day,
            astro: astro ?? this.astro,
            hour: hour ?? this.hour,
        );

    factory Forecastday.fromJson(Map<String, dynamic> json) => _$ForecastdayFromJson(json);

    Map<String, dynamic> toJson() => _$ForecastdayToJson(this);
}

@JsonSerializable()
class Astro {
    @JsonKey(name: "sunrise")
    final String sunrise;
    @JsonKey(name: "sunset")
    final String sunset;
    @JsonKey(name: "moonrise")
    final String moonrise;
    @JsonKey(name: "moonset")
    final String moonset;
    @JsonKey(name: "moon_phase")
    final String moonPhase;
    @JsonKey(name: "moon_illumination")
    final int moonIllumination;
    @JsonKey(name: "is_moon_up")
    final int isMoonUp;
    @JsonKey(name: "is_sun_up")
    final int isSunUp;

    Astro({
        required this.sunrise,
        required this.sunset,
        required this.moonrise,
        required this.moonset,
        required this.moonPhase,
        required this.moonIllumination,
        required this.isMoonUp,
        required this.isSunUp,
    });

    Astro copyWith({
        String? sunrise,
        String? sunset,
        String? moonrise,
        String? moonset,
        String? moonPhase,
        int? moonIllumination,
        int? isMoonUp,
        int? isSunUp,
    }) => 
        Astro(
            sunrise: sunrise ?? this.sunrise,
            sunset: sunset ?? this.sunset,
            moonrise: moonrise ?? this.moonrise,
            moonset: moonset ?? this.moonset,
            moonPhase: moonPhase ?? this.moonPhase,
            moonIllumination: moonIllumination ?? this.moonIllumination,
            isMoonUp: isMoonUp ?? this.isMoonUp,
            isSunUp: isSunUp ?? this.isSunUp,
        );

    factory Astro.fromJson(Map<String, dynamic> json) => _$AstroFromJson(json);

    Map<String, dynamic> toJson() => _$AstroToJson(this);
}

@JsonSerializable()
class Day {
    @JsonKey(name: "maxtemp_c")
    final double maxtempC;
    @JsonKey(name: "maxtemp_f")
    final double maxtempF;
    @JsonKey(name: "mintemp_c")
    final double mintempC;
    @JsonKey(name: "mintemp_f")
    final double mintempF;
    @JsonKey(name: "avgtemp_c")
    final double avgtempC;
    @JsonKey(name: "avgtemp_f")
    final double avgtempF;
    @JsonKey(name: "maxwind_mph")
    final double maxwindMph;
    @JsonKey(name: "maxwind_kph")
    final double maxwindKph;
    @JsonKey(name: "totalprecip_mm")
    final double totalprecipMm;
    @JsonKey(name: "totalprecip_in")
    final double totalprecipIn;
    @JsonKey(name: "totalsnow_cm")
    final int totalsnowCm;
    @JsonKey(name: "avgvis_km")
    final double avgvisKm;
    @JsonKey(name: "avgvis_miles")
    final int avgvisMiles;
    @JsonKey(name: "avghumidity")
    final int avghumidity;
    @JsonKey(name: "daily_will_it_rain")
    final int dailyWillItRain;
    @JsonKey(name: "daily_chance_of_rain")
    final int dailyChanceOfRain;
    @JsonKey(name: "daily_will_it_snow")
    final int dailyWillItSnow;
    @JsonKey(name: "daily_chance_of_snow")
    final int dailyChanceOfSnow;
    @JsonKey(name: "condition")
    final Condition condition;
    @JsonKey(name: "uv")
    final int uv;

    Day({
        required this.maxtempC,
        required this.maxtempF,
        required this.mintempC,
        required this.mintempF,
        required this.avgtempC,
        required this.avgtempF,
        required this.maxwindMph,
        required this.maxwindKph,
        required this.totalprecipMm,
        required this.totalprecipIn,
        required this.totalsnowCm,
        required this.avgvisKm,
        required this.avgvisMiles,
        required this.avghumidity,
        required this.dailyWillItRain,
        required this.dailyChanceOfRain,
        required this.dailyWillItSnow,
        required this.dailyChanceOfSnow,
        required this.condition,
        required this.uv,
    });

    Day copyWith({
        double? maxtempC,
        double? maxtempF,
        double? mintempC,
        double? mintempF,
        double? avgtempC,
        double? avgtempF,
        double? maxwindMph,
        double? maxwindKph,
        double? totalprecipMm,
        double? totalprecipIn,
        int? totalsnowCm,
        double? avgvisKm,
        int? avgvisMiles,
        int? avghumidity,
        int? dailyWillItRain,
        int? dailyChanceOfRain,
        int? dailyWillItSnow,
        int? dailyChanceOfSnow,
        Condition? condition,
        int? uv,
    }) => 
        Day(
            maxtempC: maxtempC ?? this.maxtempC,
            maxtempF: maxtempF ?? this.maxtempF,
            mintempC: mintempC ?? this.mintempC,
            mintempF: mintempF ?? this.mintempF,
            avgtempC: avgtempC ?? this.avgtempC,
            avgtempF: avgtempF ?? this.avgtempF,
            maxwindMph: maxwindMph ?? this.maxwindMph,
            maxwindKph: maxwindKph ?? this.maxwindKph,
            totalprecipMm: totalprecipMm ?? this.totalprecipMm,
            totalprecipIn: totalprecipIn ?? this.totalprecipIn,
            totalsnowCm: totalsnowCm ?? this.totalsnowCm,
            avgvisKm: avgvisKm ?? this.avgvisKm,
            avgvisMiles: avgvisMiles ?? this.avgvisMiles,
            avghumidity: avghumidity ?? this.avghumidity,
            dailyWillItRain: dailyWillItRain ?? this.dailyWillItRain,
            dailyChanceOfRain: dailyChanceOfRain ?? this.dailyChanceOfRain,
            dailyWillItSnow: dailyWillItSnow ?? this.dailyWillItSnow,
            dailyChanceOfSnow: dailyChanceOfSnow ?? this.dailyChanceOfSnow,
            condition: condition ?? this.condition,
            uv: uv ?? this.uv,
        );

    factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

    Map<String, dynamic> toJson() => _$DayToJson(this);
}

@JsonSerializable()
class Hour {
    @JsonKey(name: "time_epoch")
    final int timeEpoch;
    @JsonKey(name: "time")
    final String time;
    @JsonKey(name: "temp_c")
    final double tempC;
    @JsonKey(name: "temp_f")
    final double tempF;
    @JsonKey(name: "is_day")
    final int isDay;
    @JsonKey(name: "condition")
    final Condition condition;
    @JsonKey(name: "wind_mph")
    final double windMph;
    @JsonKey(name: "wind_kph")
    final double windKph;
    @JsonKey(name: "wind_degree")
    final int windDegree;
    @JsonKey(name: "wind_dir")
    final String windDir;
    @JsonKey(name: "pressure_mb")
    final int pressureMb;
    @JsonKey(name: "pressure_in")
    final double pressureIn;
    @JsonKey(name: "precip_mm")
    final double precipMm;
    @JsonKey(name: "precip_in")
    final double precipIn;
    @JsonKey(name: "snow_cm")
    final int snowCm;
    @JsonKey(name: "humidity")
    final int humidity;
    @JsonKey(name: "cloud")
    final int cloud;
    @JsonKey(name: "feelslike_c")
    final double feelslikeC;
    @JsonKey(name: "feelslike_f")
    final double feelslikeF;
    @JsonKey(name: "windchill_c")
    final double windchillC;
    @JsonKey(name: "windchill_f")
    final double windchillF;
    @JsonKey(name: "heatindex_c")
    final double heatindexC;
    @JsonKey(name: "heatindex_f")
    final double heatindexF;
    @JsonKey(name: "dewpoint_c")
    final double dewpointC;
    @JsonKey(name: "dewpoint_f")
    final double dewpointF;
    @JsonKey(name: "will_it_rain")
    final int willItRain;
    @JsonKey(name: "chance_of_rain")
    final int chanceOfRain;
    @JsonKey(name: "will_it_snow")
    final int willItSnow;
    @JsonKey(name: "chance_of_snow")
    final int chanceOfSnow;
    @JsonKey(name: "vis_km")
    final int visKm;
    @JsonKey(name: "vis_miles")
    final int visMiles;
    @JsonKey(name: "gust_mph")
    final double gustMph;
    @JsonKey(name: "gust_kph")
    final double gustKph;
    @JsonKey(name: "uv")
    final int uv;

    Hour({
        required this.timeEpoch,
        required this.time,
        required this.tempC,
        required this.tempF,
        required this.isDay,
        required this.condition,
        required this.windMph,
        required this.windKph,
        required this.windDegree,
        required this.windDir,
        required this.pressureMb,
        required this.pressureIn,
        required this.precipMm,
        required this.precipIn,
        required this.snowCm,
        required this.humidity,
        required this.cloud,
        required this.feelslikeC,
        required this.feelslikeF,
        required this.windchillC,
        required this.windchillF,
        required this.heatindexC,
        required this.heatindexF,
        required this.dewpointC,
        required this.dewpointF,
        required this.willItRain,
        required this.chanceOfRain,
        required this.willItSnow,
        required this.chanceOfSnow,
        required this.visKm,
        required this.visMiles,
        required this.gustMph,
        required this.gustKph,
        required this.uv,
    });

    Hour copyWith({
        int? timeEpoch,
        String? time,
        double? tempC,
        double? tempF,
        int? isDay,
        Condition? condition,
        double? windMph,
        double? windKph,
        int? windDegree,
        String? windDir,
        int? pressureMb,
        double? pressureIn,
        double? precipMm,
        double? precipIn,
        int? snowCm,
        int? humidity,
        int? cloud,
        double? feelslikeC,
        double? feelslikeF,
        double? windchillC,
        double? windchillF,
        double? heatindexC,
        double? heatindexF,
        double? dewpointC,
        double? dewpointF,
        int? willItRain,
        int? chanceOfRain,
        int? willItSnow,
        int? chanceOfSnow,
        int? visKm,
        int? visMiles,
        double? gustMph,
        double? gustKph,
        int? uv,
    }) => 
        Hour(
            timeEpoch: timeEpoch ?? this.timeEpoch,
            time: time ?? this.time,
            tempC: tempC ?? this.tempC,
            tempF: tempF ?? this.tempF,
            isDay: isDay ?? this.isDay,
            condition: condition ?? this.condition,
            windMph: windMph ?? this.windMph,
            windKph: windKph ?? this.windKph,
            windDegree: windDegree ?? this.windDegree,
            windDir: windDir ?? this.windDir,
            pressureMb: pressureMb ?? this.pressureMb,
            pressureIn: pressureIn ?? this.pressureIn,
            precipMm: precipMm ?? this.precipMm,
            precipIn: precipIn ?? this.precipIn,
            snowCm: snowCm ?? this.snowCm,
            humidity: humidity ?? this.humidity,
            cloud: cloud ?? this.cloud,
            feelslikeC: feelslikeC ?? this.feelslikeC,
            feelslikeF: feelslikeF ?? this.feelslikeF,
            windchillC: windchillC ?? this.windchillC,
            windchillF: windchillF ?? this.windchillF,
            heatindexC: heatindexC ?? this.heatindexC,
            heatindexF: heatindexF ?? this.heatindexF,
            dewpointC: dewpointC ?? this.dewpointC,
            dewpointF: dewpointF ?? this.dewpointF,
            willItRain: willItRain ?? this.willItRain,
            chanceOfRain: chanceOfRain ?? this.chanceOfRain,
            willItSnow: willItSnow ?? this.willItSnow,
            chanceOfSnow: chanceOfSnow ?? this.chanceOfSnow,
            visKm: visKm ?? this.visKm,
            visMiles: visMiles ?? this.visMiles,
            gustMph: gustMph ?? this.gustMph,
            gustKph: gustKph ?? this.gustKph,
            uv: uv ?? this.uv,
        );

    factory Hour.fromJson(Map<String, dynamic> json) => _$HourFromJson(json);

    Map<String, dynamic> toJson() => _$HourToJson(this);
}

@JsonSerializable()
class Location {
    @JsonKey(name: "name")
    final String name;
    @JsonKey(name: "region")
    final String region;
    @JsonKey(name: "country")
    final String country;
    @JsonKey(name: "lat")
    final double lat;
    @JsonKey(name: "lon")
    final double lon;
    @JsonKey(name: "tz_id")
    final String tzId;
    @JsonKey(name: "localtime_epoch")
    final int localtimeEpoch;
    @JsonKey(name: "localtime")
    final String localtime;

    Location({
        required this.name,
        required this.region,
        required this.country,
        required this.lat,
        required this.lon,
        required this.tzId,
        required this.localtimeEpoch,
        required this.localtime,
    });

    Location copyWith({
        String? name,
        String? region,
        String? country,
        double? lat,
        double? lon,
        String? tzId,
        int? localtimeEpoch,
        String? localtime,
    }) => 
        Location(
            name: name ?? this.name,
            region: region ?? this.region,
            country: country ?? this.country,
            lat: lat ?? this.lat,
            lon: lon ?? this.lon,
            tzId: tzId ?? this.tzId,
            localtimeEpoch: localtimeEpoch ?? this.localtimeEpoch,
            localtime: localtime ?? this.localtime,
        );

    factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

    Map<String, dynamic> toJson() => _$LocationToJson(this);
}