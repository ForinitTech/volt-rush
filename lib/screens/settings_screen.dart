import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volt_rush/providers/game_provider.dart';

/// Settings screen for managing game preferences and score data.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _hapticsEnabled = prefs.getBool('hapticsEnabled') ?? true;
    });
  }

  Future<void> _updateSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', value);
    setState(() {
      _soundEnabled = value;
    });
  }

  Future<void> _updateHaptics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hapticsEnabled', value);
    setState(() {
      _hapticsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.oswald(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile(
              title: Text('Sound Effects', style: GoogleFonts.oswald(fontSize: 20)),
              value: _soundEnabled,
              onChanged: _updateSound,
            ),
            SwitchListTile(
              title: Text('Haptic Feedback', style: GoogleFonts.oswald(fontSize: 20)),
              value: _hapticsEnabled,
              onChanged: _updateHaptics,
            ),
            const SizedBox(height: 30),
            Text(
              'Reset High Score',
              style: GoogleFonts.oswald(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                game.resetHighScore();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('High score reset!'),
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
