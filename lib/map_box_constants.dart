import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:latlong2/latlong.dart';

class AppConstants {
    final userViewModel = Provider.of<UserViewModel> ;

  static const String mapBoxAccessToken = 'pk.eyJ1IjoidXNlci0xMjM0NSIsImEiOiJjbHpjczhueGkwZGtuMmxyeTR4ODNxcm94In0.GdvM4h6x8qaUGETeUm0ZjQ';

  static const String mapBoxStyleId = 'mapbox://styles/user-12345/clzcsc8gk00aj01qt4bx349jh';

  static const myLocation = LatLng(36.74013, 10.30364);
}
