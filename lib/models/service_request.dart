import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequest {
  final String id;
  final String status;

  ServiceRequest({required this.id, required this.status});

  factory ServiceRequest.fromDocument(DocumentSnapshot doc) {
    return ServiceRequest(
      id: doc['id'],
      status: doc['status'],
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ServiceRequest>> _getServiceRequests() {
    return _firestore.collection('service_requests').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ServiceRequest.fromDocument(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Requests Dashboard'),
      ),
      body: StreamBuilder<List<ServiceRequest>>(
        stream: _getServiceRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No service requests found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              ServiceRequest request = snapshot.data![index];
              return ListTile(
                title: Text('Request ID: ${request.id}'),
                subtitle: Text('Status: ${request.status}'),
              );
            },
          );
        },
      ),
    );
  }
}
