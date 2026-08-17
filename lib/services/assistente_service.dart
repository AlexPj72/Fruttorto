import 'package:firebase_ai/firebase_ai.dart';

class AssistenteService {
  static const bool usaFirebaseAI = false;

  static Future<String> rispondi({required String domanda,
      required Map<String, String?> contesto}) async {
    if (usaFirebaseAI) {
      final model = FirebaseAI.googleAI()
          .generativeModel(model: 'gemini-2.5-flash');
      final prompt = 'Sei l\'assistente agronomico di Fruttorto (Italia).\n'
          'Contesto utente: ${contesto.toString()}\n'
          'Rispondi breve, pratico, calato sul suo territorio.\nDomanda: $domanda';
      final res = await model.generateContent([Content.text(prompt)]);
      return res.text ?? 'Non ho capito, riprova.';
    }
    return _locale(domanda, contesto);
  }

  static String _locale(String d, Map<String, String?> c) {
    final q = d.toLowerCase();
    final zona = c['zona'];
    if (q.contains('innaffi') || q.contains('acqua')) {
      return c['consiglioIrrigazione'] ?? 'Imposta un appezzamento con coordinate per avere consigli d\'acqua sul meteo reale.';
    }
    if (q.contains('semin') || q.contains('trapiant')) {
      return 'In zona ${zona ?? "—"} il calendario di pianificazione ti mostra i mesi adatti coltura per coltura.';
    }
    if (q.contains('malatt') || q.contains('patolog') || q.contains('foto')) {
      return 'Il riconoscimento patologie da foto arriverà con Firebase AI Logic: per ora descrivi i sintomi e consulta i disciplinari regionali.';
    }
    return 'Sono l\'assistente di Fruttorto. Posso aiutarti su irrigazione, semine e patologie nel tuo comune.';
  }
}
