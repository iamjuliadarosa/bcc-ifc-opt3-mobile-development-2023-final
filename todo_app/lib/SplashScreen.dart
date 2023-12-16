import 'package:flutter/material.dart';
import 'WeatherService.dart';
import 'package:todo_app/TodoList.dart';
import 'package:todo_app/DatabaseHelper.dart';

class SplashScreen extends StatefulWidget {
  final DatabaseHelper dbHelper;
  SplashScreen({required this.dbHelper});
  @override
  _SplashScreenState createState() => _SplashScreenState(dbHelper: dbHelper);
}

class _SplashScreenState extends State<SplashScreen> {
  final DatabaseHelper dbHelper;
  _SplashScreenState({required this.dbHelper});
  final WeatherService weatherService =
      WeatherService('b6122c8a3cda2be34a3181460eaff790');
  late Future<bool> _loading;
  late WeatherData weatherData;
  @override
  void initState() {
    super.initState();
    _loading = loadData();
  }

  Future<bool> loadData() async {
    try {
      weatherData = await weatherService.getWeather();
      return true;
    } catch (e) {
      print('Erro ao capturar os dados climáticos: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
          future: _loading,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Temperatura é de ' + weatherData.temperature + " C°."),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navegar para a próxima tela
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoList(dbHelper: dbHelper),
                        ),
                      );
                    },
                    child: Text('Prosseguir'),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
