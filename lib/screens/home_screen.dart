import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'ar_screen.dart'; // Import the ARScreen file

class HomeScreen extends StatefulWidget {
  final User? user;
  final String? welcomeMessage;

  const HomeScreen({Key? key, required this.user, this.welcomeMessage}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MapController _mapController;
  LatLng _currentLocation = const LatLng(51.5, -0.09); // Default location
  bool _loading = true; // Loading state for initial position
  List<Marker> _markers = []; // List to hold markers
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();

    // Show welcome message if provided
    if (widget.welcomeMessage != null) {
      _showWelcomeSnackBar(widget.welcomeMessage!);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _loading = true;
    });

    try {
      // Request permission first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
        setState(() => _loading = false);
        return;
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _loading = false;
        _mapController.move(_currentLocation, 15.0);
        _markers = [
          Marker(
            width: 80.0,
            height: 80.0,
            point: _currentLocation,
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
        ];
      });
    } catch (e) {
      print("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting location: $e")),
      );
      setState(() => _loading = false);
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Permission Denied'),
          content: const Text('Please enable location permissions in settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _getCurrentLocation();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final latLng = LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _currentLocation = latLng;
          _mapController.move(_currentLocation, 15.0);
          _markers = [
            Marker(
              width: 80.0,
              height: 80.0,
              point: _currentLocation,
              child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
            ),
          ];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location not found: $location")),
        );
      }
    } catch (e) {
      print("Error searching location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error searching location: $e")),
      );
    }
  }

  void _showWelcomeSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onTap: (tapPosition, point) {
                print("Tapped at: $point");
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
          if (_loading) const Center(child: CircularProgressIndicator()),
          Positioned(
            top: 50.0,
            left: 10.0,
            right: 10.0,
            child: _buildSearchBar(context),
          ),
          // AR Button
          Positioned(
            bottom: 200.0, // Adjust the position to place it above the directions button
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'ar_button',
              child: const Icon(Icons.view_in_ar),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ARScreen()),
                );
              },
            ),
          ),
          Positioned(
            bottom: 140.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'directions_button',
              child: const Icon(Icons.directions),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Directions feature coming soon!")),
                );
              },
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'location_button',
              child: const Icon(Icons.my_location),
              onPressed: () => _getCurrentLocation(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(widget.user?.photoURL ?? 'https://via.placeholder.com/150'),
            ),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search location...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                _searchLocation(value);
                _searchController.clear();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                _searchLocation(_searchController.text);
                _searchController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
