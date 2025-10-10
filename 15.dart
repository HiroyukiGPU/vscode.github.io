// Dart Example - 天気予報アプリ
import 'dart:math';

// 天気の列挙型
enum WeatherCondition { sunny, cloudy, rainy, snowy, stormy }

// 天気データクラス
class WeatherData {
  final DateTime date;
  final double temperature;
  final double humidity;
  final WeatherCondition condition;
  final double windSpeed;
  final String location;

  WeatherData({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.windSpeed,
    required this.location,
  });

  String get conditionEmoji {
    switch (condition) {
      case WeatherCondition.sunny:
        return '☀️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.snowy:
        return '❄️';
      case WeatherCondition.stormy:
        return '⛈️';
    }
  }

  String get conditionName {
    switch (condition) {
      case WeatherCondition.sunny:
        return '晴れ';
      case WeatherCondition.cloudy:
        return '曇り';
      case WeatherCondition.rainy:
        return '雨';
      case WeatherCondition.snowy:
        return '雪';
      case WeatherCondition.stormy:
        return '嵐';
    }
  }

  void display() {
    print('${conditionEmoji} ${_formatDate(date)}');
    print('  場所: $location');
    print('  天気: $conditionName');
    print('  気温: ${temperature.toStringAsFixed(1)}°C');
    print('  湿度: ${humidity.toStringAsFixed(0)}%');
    print('  風速: ${windSpeed.toStringAsFixed(1)} m/s');
    print('');
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
      'condition': condition.toString(),
      'windSpeed': windSpeed,
      'location': location,
    };
  }
}

// 天気予報サービス
class WeatherService {
  final Random _random = Random();
  final List<String> _locations = ['東京', '大阪', '名古屋', '福岡', '札幌'];

  WeatherData fetchCurrentWeather(String location) {
    return WeatherData(
      date: DateTime.now(),
      temperature: _random.nextDouble() * 35 + 5, // 5-40°C
      humidity: _random.nextDouble() * 60 + 40, // 40-100%
      condition: WeatherCondition.values[_random.nextInt(5)],
      windSpeed: _random.nextDouble() * 15, // 0-15 m/s
      location: location,
    );
  }

  List<WeatherData> fetchWeeklyForecast(String location) {
    final forecast = <WeatherData>[];
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      forecast.add(
        WeatherData(
          date: now.add(Duration(days: i)),
          temperature: _random.nextDouble() * 30 + 10,
          humidity: _random.nextDouble() * 60 + 40,
          condition: WeatherCondition.values[_random.nextInt(5)],
          windSpeed: _random.nextDouble() * 12,
          location: location,
        ),
      );
    }

    return forecast;
  }

  String getRandomLocation() {
    return _locations[_random.nextInt(_locations.length)];
  }
}

// 天気分析クラス
class WeatherAnalyzer {
  final List<WeatherData> weatherDataList;

  WeatherAnalyzer(this.weatherDataList);

  double getAverageTemperature() {
    if (weatherDataList.isEmpty) return 0.0;

    final sum = weatherDataList.fold<double>(
      0.0,
      (prev, weather) => prev + weather.temperature,
    );

    return sum / weatherDataList.length;
  }

  double getMaxTemperature() {
    if (weatherDataList.isEmpty) return 0.0;

    return weatherDataList
        .map((w) => w.temperature)
        .reduce((a, b) => a > b ? a : b);
  }

  double getMinTemperature() {
    if (weatherDataList.isEmpty) return 0.0;

    return weatherDataList
        .map((w) => w.temperature)
        .reduce((a, b) => a < b ? a : b);
  }

  int countByCondition(WeatherCondition condition) {
    return weatherDataList
        .where((weather) => weather.condition == condition)
        .length;
  }

  void displayStatistics() {
    print('\n=== 統計情報 ===');
    print('データ数: ${weatherDataList.length}件');
    print('平均気温: ${getAverageTemperature().toStringAsFixed(1)}°C');
    print('最高気温: ${getMaxTemperature().toStringAsFixed(1)}°C');
    print('最低気温: ${getMinTemperature().toStringAsFixed(1)}°C');

    print('\n天気の割合:');
    for (final condition in WeatherCondition.values) {
      final count = countByCondition(condition);
      final percentage = (count / weatherDataList.length * 100).toStringAsFixed(
        1,
      );
      print('  ${_getConditionName(condition)}: $count件 ($percentage%)');
    }
    print('================\n');
  }

  String _getConditionName(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return '晴れ';
      case WeatherCondition.cloudy:
        return '曇り';
      case WeatherCondition.rainy:
        return '雨';
      case WeatherCondition.snowy:
        return '雪';
      case WeatherCondition.stormy:
        return '嵐';
    }
  }
}

// メイン関数
void main() {
  print('=' * 50);
  print('  天気予報アプリ - Dart Edition');
  print('=' * 50);
  print('');

  final service = WeatherService();

  // 現在の天気を取得
  print('=== 現在の天気 ===\n');
  final locations = ['東京', '大阪', '福岡'];

  for (final location in locations) {
    final weather = service.fetchCurrentWeather(location);
    weather.display();
  }

  // 週間予報を取得
  print('\n=== 東京の週間天気予報 ===\n');
  final forecast = service.fetchWeeklyForecast('東京');

  for (final weather in forecast) {
    weather.display();
  }

  // 分析
  final analyzer = WeatherAnalyzer(forecast);
  analyzer.displayStatistics();

  // おすすめ情報
  print('=== おすすめ情報 ===');
  final avgTemp = analyzer.getAverageTemperature();

  if (avgTemp > 25) {
    print('🌡️ 暑い日が続きます。熱中症にご注意ください。');
  } else if (avgTemp < 10) {
    print('🧥 寒い日が続きます。暖かい服装でお出かけください。');
  } else {
    print('😊 過ごしやすい気温です。');
  }

  final rainyDays = analyzer.countByCondition(WeatherCondition.rainy);
  if (rainyDays > 3) {
    print('☂️ 雨の日が多いです。傘をお忘れなく！');
  }

  print('\n' + '=' * 50);
  print('✓ 天気情報の取得が完了しました');
  print('=' * 50);
}
