import '../../services/my_globals.dart';

double calculateAspect() {
  var aspects = aspectRatio.split('/');
  return double.parse(aspects[0]) / double.parse(aspects[1]);
}

void changeChannel() {}
