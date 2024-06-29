import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/service_request.dart';
import '../providers/service_provider.dart';
import '../services/location_service.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceRequestScreenState createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final TextEditingController _assistanceTypeController = TextEditingController();
  String? _currentLocation;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    String location = await LocationService.getCurrentLocation();
    setState(() {
      _currentLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _assistanceTypeController,
              decoration: const InputDecoration(labelText: 'Type of Assistance'),
            ),
            const SizedBox(height: 20),
            _currentLocation == null
                ? const CircularProgressIndicator()
                : Text('Current Location: $_currentLocation'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_assistanceTypeController.text.isNotEmpty && _currentLocation != null) {
                  ServiceRequest request = ServiceRequest(
                    type: _assistanceTypeController.text,
                    location: _currentLocation!,
                  );
                  serviceProvider.createServiceRequest(request);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Service Request Created')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please complete all fields')),
                  );
                }
              },
              child: const Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
