================================================================
  FRUTTORTO - BUILD PACK
  Generato: 17 agosto 2026
================================================================

CONTENUTO DI QUESTO PACK:
─────────────────────────
1. pubspec.yaml (aggiornato con nuovi pacchetti)
2. Nuovi file da creare:
   - lib/theme/app_theme.dart
   - lib/views/main_shell.dart
   - lib/models/scheda_coltura.dart
   - lib/models/diario_entry.dart
   - lib/models/card_settimana.dart
   - lib/services/logica_agronomica.dart
   - lib/services/meteo_service.dart
   - lib/services/assistente_service.dart
   - lib/services/calendario_naturale_service.dart
   - lib/repositories/schede_colture_repository.dart
   - lib/repositories/diario_repository.dart
   - lib/providers/settings_provider.dart
   - lib/providers/meteo_provider.dart
   - lib/views/widgets/guest_banner.dart
   - lib/views/widgets/empty_state.dart
   - lib/views/widgets/section_card.dart
   - lib/views/home_dashboard_screen.dart
   - lib/views/pianifica_screen.dart
   - lib/views/diario_screen.dart
   - lib/views/assistente_screen.dart
   - lib/views/filosofia_screen.dart
   - lib/views/calendario_naturale_screen.dart
3. File da SOSTITUIRE:
   - lib/main.dart
   - lib/app_router.dart
   - lib/models/plant_model.dart
   - lib/views/orto_screen.dart
4. File da AGGIORNARE (vedi file _UPDATE_*.txt):
   - lib/models/appezzamento.dart (3 nuovi campi)
   - lib/repositories/appezzamento_repository.dart (1 metodo)
   - lib/repositories/plant_repository.dart (1 metodo)
   - lib/providers/garden_provider.dart (3 metodi)

ISTRUZIONI DI INSTALLAZIONE:
────────────────────────────
1. Apri il tuo progetto in Google IDX
2. Crea tutti i file NUOVI nella struttura di cartelle corretta
3. SOSTITUISCI i file da sostituire con il nuovo contenuto
4. AGGIORNA i file _UPDATE_* seguendo le istruzioni nei file .txt
5. Esegui "flutter pub get" per installare i nuovi pacchetti
6. Avvia l'app e verifica che compili

AGGIORNAMENTO PROJECT.MD:
──────────────────────────
Aggiungi alla sezione "✅ Fatto finora":

- (2026-08-17) Implementata nuova architettura di navigazione a 5 sezioni (Home/Pianifica/Orto/Diario/Assistente) con tema verde-crema
- (2026-08-17) Creato catalogo colture base e varietà (12 colture, 14 varietà) con dati agronomici di base
- (2026-08-17) Implementata logica agronomica con adattamento territoriale (fattore zona Nord/Centro/Sud)
- (2026-08-17) Creato servizio meteo Open-Meteo con dati suolo e consigli irrigazione automatici
- (2026-08-17) Implementato calendario naturale a card settimanali con testi 12 mesi da validare
- (2026-08-17) Creato diario di campo con note e foto, filtro anno/mese
- (2026-08-17) Implementato assistente conversazionale con fallback locale (pronto per Firebase AI Logic)
- (2026-08-17) Creato modulo Filosofia con tag filtrabili e modalità "Non Fare" opzionale
- (2026-08-17) Aggiunto tracking pacciamatura, città manuale, banner ospite e PWA

COMMIT GIT CONSIGLIATI:
────────────────────────
git add .
git commit -m "feat: nuova architettura a 5 sezioni, catalogo colture, calendario naturale, assistente IA-ready"
git push origin master

PROSSIMI PASSI:
───────────────
1. VALIDARE i testi agronomici (vedi TESTI_AGRONOMICI_12_MESI.md)
2. Abilitare Firebase AI Logic nella console
3. Configurare App Check
4. Abilitare flag "usaFirebaseAI" in assistente_service.dart
5. Aggiungere riconoscimento patologie da foto
6. Test completo su web e mobile
