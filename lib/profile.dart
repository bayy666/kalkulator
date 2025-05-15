// profile.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Profil Pengguna',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            _buildProfileItem(Icons.person, 'Nama', 'Pengguna'),
            _buildProfileItem(Icons.email, 'Email', 'pengguna@email.com'),
            _buildProfileItem(Icons.date_range, 'Tanggal Bergabung', '21 Feb 2025'),
            _buildProfileItem(Icons.calculate, 'Total Perhitungan', '0'),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Edit profile functionality would go here
              },
              icon: Icon(Icons.edit),
              label: Text('Edit Profil'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}