import 'package:geolocator/geolocator.dart';

/// Eccezione applicativa per errori di localizzazione, con un messaggio
/// già pronto da mostrare all'utente.
class LocalizzazioneException implements Exception {
  final String messaggio;
  LocalizzazioneException(this.messaggio);
  @override
  String toString() => messaggio;
}

class LocationService {
  /// Chiede il permesso (se necessario) e restituisce la posizione GPS
  /// corrente del dispositivo. Lancia [LocalizzazioneException] con un
  /// messaggio leggibile se qualcosa va storto.
  static Future<Position> posizioneCorrente() async {
    final servizioAttivo = await Geolocator.isLocationServiceEnabled();
    if (!servizioAttivo) {
      throw LocalizzazioneException(
        'Il GPS/localizzazione è disattivato sul dispositivo. Attivalo e riprova.',
      );
    }

    LocationPermission permesso = await Geolocator.checkPermission();
    if (permesso == LocationPermission.denied) {
      permesso = await Geolocator.requestPermission();
      if (permesso == LocationPermission.denied) {
        throw LocalizzazioneException(
          'Permesso di localizzazione negato. Concedilo per usare questa funzione.',
        );
      }
    }

    if (permesso == LocationPermission.deniedForever) {
      throw LocalizzazioneException(
        'Il permesso di localizzazione è bloccato. Abilitalo dalle impostazioni del dispositivo.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
