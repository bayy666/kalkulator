// history.dart
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> history;

  HistoryPage({required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Perhitungan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: history.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada riwayat perhitungan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      // Display history in reverse order (newest first)
                      final item = history[history.length - 1 - index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item),
                          trailing: Icon(Icons.calculate),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}