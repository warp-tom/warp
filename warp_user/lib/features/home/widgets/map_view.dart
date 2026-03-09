import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/trip_provider.dart';

class LiveMapView extends ConsumerStatefulWidget {
  const LiveMapView({super.key});

  @override
  ConsumerState<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends ConsumerState<LiveMapView> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = true;

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(14.5995, 120.9842), // Default to Manila
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isLoading = false;
        });

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15.0,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // Watch the active drivers stream
    final driversAsync = ref.watch(activeDriversProvider);
    
    // Convert to markers
    Set<Marker> markers = {};
    if (driversAsync.value != null) {
      for (var driver in driversAsync.value!) {
        markers.add(
          Marker(
            markerId: MarkerId(driver.driverId),
            position: LatLng(driver.latitude, driver.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          ),
        );
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GoogleMap(
        initialCameraPosition: _currentPosition != null
            ? CameraPosition(
                target: LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 15.0,
              )
            : _initialCameraPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        markers: markers,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}
