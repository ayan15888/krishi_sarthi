import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).updateWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => weatherProvider.updateWeather(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildWeatherCard(context, weatherProvider, l10n),
            const SizedBox(height: 20),
            _buildCropRecommendationCard(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(
      BuildContext context, WeatherProvider provider, AppLocalizations l10n) {
    if (provider.isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (provider.error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(l10n.allowLocation),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => provider.updateWeather(),
                child: Text(l10n.grantPermission),
              ),
            ],
          ),
        ),
      );
    }

    final data = provider.weatherData;
    if (data == null) return const SizedBox();

    final temp = (data['main']['temp'] - 273.15).toStringAsFixed(1);
    final humidity = data['main']['humidity'];
    final description = data['weather'][0]['description'];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.green.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.weather,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.wb_sunny, color: Colors.amber, size: 40),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '$temp°C',
                  style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description.toUpperCase(),
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      '${l10n.humidity}: $humidity%',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              data['name'],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropRecommendationCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.recommendedCrops,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildCropItem(Icons.grass, 'Rice (ধান)', 'High Yield'),
            _buildCropItem(Icons.eco, 'Jute (মৰাপাত)', 'Export Quality'),
            _buildCropItem(Icons.local_florist, 'Tea (চাহ)', 'Best for Soil'),
          ],
        ),
      ),
    );
  }

  Widget _buildCropItem(IconData icon, String name, String tag) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withAlpha(26),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(tag),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
