import 'package:flutter/material.dart';
import '../models/service_request.dart';

class ServiceProvider with ChangeNotifier {
  final List<ServiceRequest> _requests = [];

  List<ServiceRequest> get requests => _requests;

  void createServiceRequest(ServiceRequest request) {
    _requests.add(request);
    notifyListeners();
  }
}
