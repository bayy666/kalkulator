// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'history.dart';
import 'profile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Web',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  int _selectedIndex = 0;
  String _input = '0';
  String _result = '';
  List<String> _history = [];
  int _totalCalculations = 0;
  
  final userProfile = UserProfile(
    name: 'Pengguna',
    email: 'pengguna@email.com',
    joinDate: '21 Feb 2025',
  );

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToInput(String value) {
    setState(() {
      if (_input == '0' && value != '.') {
        _input = value;
      } else {
        _input += value;
      }
    });
  }

  void _clear() {
    setState(() {
      _input = '0';
      _result = '';
    });
  }

  void _calculate() {
    try {
      String expression = _input.replaceAll('×', '*').replaceAll('÷', '/');
      dynamic result = eval(expression);
      setState(() {
        _result = result.toString();
        if (result != 'Error') {
          _history.add('$_input = $_result');
          _totalCalculations++;
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  dynamic eval(String expression) {
    try {
      if (expression.contains('+')) {
        List<String> parts = expression.split('+');
        return double.parse(parts[0]) + double.parse(parts[1]);
      } else if (expression.contains('-')) {
        List<String> parts = expression.split('-');
        return double.parse(parts[0]) - double.parse(parts[1]);
      } else if (expression.contains('*')) {
        List<String> parts = expression.split('*');
        return double.parse(parts[0]) * double.parse(parts[1]);
      } else if (expression.contains('/')) {
        List<String> parts = expression.split('/');
        if (double.parse(parts[1]) == 0) return 'Error';
        return double.parse(parts[0]) / double.parse(parts[1]);
      }
      return double.parse(expression);
    } catch (e) {
      return 'Error';
    }
  }

  Widget _buildCalculator() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            width: 360, // Fixed width for mobile-like appearance
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight - 56,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _input,
                        style: TextStyle(fontSize: 32),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _result,
                        style: TextStyle(fontSize: 24, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(child: _buildKeypadRow(['7', '8', '9', '÷'])),
                        Expanded(child: _buildKeypadRow(['4', '5', '6', '×'])),
                        Expanded(child: _buildKeypadRow(['1', '2', '3', '-'])),
                        Expanded(child: _buildKeypadRow(['0', '.', '=', '+'])),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _clear,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text('Clear'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeypadRow(List<String> buttons) {
    return Row(
      children: buttons.map((button) {
        Color buttonColor;
        if ('+-×÷'.contains(button)) {
          buttonColor = Colors.amber;
        } else if (button == '=') {
          buttonColor = Colors.green;
        } else {
          buttonColor = Colors.grey.shade800;
        }

        return Expanded(
          child: Padding(
            padding: EdgeInsets.all(4),
            child: ElevatedButton(
              onPressed: () {
                if (button == '=') {
                  _calculate();
                } else {
                  _addToInput(button);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                button,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      _buildCalculator(),
      HistoryPage(history: _history),
      ProfilePage(
        profile: userProfile,
        totalCalculations: _totalCalculations,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator Web'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 360),
            child: _pages[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Kalkulator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// profile.dart
class UserProfile {
  String name;
  String email;
  final String joinDate;

  UserProfile({
    required this.name,
    required this.email,
    required this.joinDate,
  });
}

class ProfilePage extends StatefulWidget {
  final UserProfile profile;
  final int totalCalculations;

  ProfilePage({
    required this.profile,
    required this.totalCalculations,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // Save changes
        widget.profile.name = _nameController.text;
        widget.profile.email = _emailController.text;
      }
      _isEditing = !_isEditing;
    });
  }

  Widget _buildProfileItem(IconData icon, String label, String value, {bool isEditable = false, TextEditingController? controller}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        subtitle: isEditable && _isEditing
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              )
            : Text(value),
      ),
    );
  }

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
            _buildProfileItem(
              Icons.person,
              'Nama',
              widget.profile.name,
              isEditable: true,
              controller: _nameController,
            ),
            _buildProfileItem(
              Icons.email,
              'Email',
              widget.profile.email,
              isEditable: true,
              controller: _emailController,
            ),
            _buildProfileItem(Icons.date_range, 'Tanggal Bergabung', widget.profile.joinDate),
            _buildProfileItem(Icons.calculate, 'Total Perhitungan', widget.totalCalculations.toString()),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _toggleEdit,
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              label: Text(_isEditing ? 'Simpan' : 'Edit Profil'),
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
}