import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class DirectionScreen extends StatefulWidget {
  final User? user;

  const DirectionScreen({Key? key, required this.user}) : super(key: key);

  @override
  _DirectionScreenState createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  late MapController _mapController;
  LatLng _currentLocation = const LatLng(51.5, -0.09); // Default location
  LatLng? _destination; // Destination for directions
  bool _loading = true; // Loading state for initial position
  TextEditingController _searchController = TextEditingController(); // Search controller

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _loading = true; // Set loading true before fetching
    });

    try {
      // Request permission first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog(); // Show permission denied dialog
        setState(() {
          _loading = false; // Stop loading if permission is denied
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _loading = false; // Stop loading when position is acquired
        _mapController.move(_currentLocation, 15.0); // Move map to current location
      });
    } catch (e) {
      print("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting location: $e")),
      );
      setState(() {
        _loading = false; // Stop loading in case of error
      });
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
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _getCurrentLocation(); // Retry fetching location
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
        _destination = LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _mapController.move(_destination!, 15.0); // Move map to destination
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen OSM map
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
            ],
          ),
          // Loading indicator
          if (_loading)
            const Center(child: CircularProgressIndicator()),
          // Custom search bar
          Positioned(
            top: 50.0,
            left: 10.0,
            right: 10.0,
            child: _buildSearchBar(context),
          ),
          // Current location button at bottom right
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton(
              child: const Icon(Icons.my_location),
              onPressed: () {
                _getCurrentLocation(); // Refresh current location on button press
              },
            ),
          ),
          // Directions button
          Positioned(
            bottom: 140.0,
            right: 10.0,
            child: FloatingActionButton(
              child: const Icon(Icons.directions),
              onPressed: () {
                // Handle direction action here
                // You can integrate your direction functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Directions feature coming soon!")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Custom search bar with profile button
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
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search location...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                _searchLocation(value); // Call search function
                _searchController.clear(); // Clear input after searching
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                _searchLocation(_searchController.text); // Call search function
                _searchController.clear(); // Clear input after searching
              }
            },
          ),
        ],
      ),
    );
  }
}
