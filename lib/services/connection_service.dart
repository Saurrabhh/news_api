import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService{

  final Connectivity _connection = Connectivity();

  isConnectedToInternet() async {
    final connectivityResult = await _connection.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.ethernet;
  }
}