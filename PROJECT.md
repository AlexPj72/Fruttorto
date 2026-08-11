# 🌱 Progetto: Gestione Orto & Frutteto (Italia)

## 1. Cos'è quest'app (visione in una frase)
App gratuita, geolocalizzata per tutta l'Italia, che aiuta a gestire orto e frutteto:
in base a DOVE ti trovi e all'esposizione, ti dice COME trattare ogni coltura,
QUANDO seminare/trapiantare/raccogliere, QUANTO innaffiare e come curare le patologie.

## 2. Obiettivi principali (funzioni)
- [ ] Geolocalizzazione per regione / provincia / comune (Italia)
- [ ] Lettura posizione GPS in tempo reale (reverse geocoding)
- [ ] Meteo del luogo (temperatura, pioggia, umidità, suolo)
- [ ] Schede coltura (ortaggi + alberi da frutto) con varietà
- [ ] Aggiunta colture a più appezzamenti (orto) e frutteti
- [ ] Tracciamento ciclo: semina → trapianto → cura → raccolta
- [ ] Suggerimenti irrigazione e trattamenti specifici
- [ ] Riconoscimento patologie da foto + cura consigliata
- [ ] Promemoria (innaffiare, trattare, raccogliere)
- [ ] (Futuro) Rilascio pubblico gratuito per tutta Italia

## 3. Concetto chiave: 3 strati dei dati coltura
La "biblioteca" delle colture ha 3 livelli (questo è il cuore dell'app):

1. **COLTURA BASE**  → es. Cipolla
   (ciclo generico, sensibilità freddo/caldo, terreno, esigenze idriche di base)
2. **VARIETÀ**        → es. Cipolla di Tropea
   (ciclo specifico ~120 gg, segnali di raccolta: "parte aerea seccata",
    attenzione: bulbo sullo stelo = sta andando in fiore)
3. **TERRITORIO**     → regole che modificano date in base a:
   coordinate, altitudine, esposizione (sole/penombra), clima del comune

## 4. Stack tecnologico (attuale e futuro)
- **Frontend/IDE**: Google IDX (React/Next.js)
- **Backend/Dati**: Firebase (auth, database, storage foto)
- **Gestione codice**: GitHub (repo: ___)
- **Hosting futuro**: da decidere (probabile cloud gratuito / Firebase / Aruba come riserva)

---

## 5. Schema della proposta di architettura

┌─────────────────────────────────────────────────────────────┐
│ FRONTEND (App in IDX) │
│ React / Next.js (compilato con GitHub) │
│ │
│ Pagina principale │ Aggiungi appezzamento │ ... │
│ (menù Regione→Provincia→Comune) │
│ (pulsante "Usa la mia posizione" - GPS) │
└───────────────┬─────────────────────────────┬───────────────┘
│ │
▼ ▼
┌──────────────────────┐ ┌──────────────────────────┐
│ FIREBASE │ │ RISORSE ESTERNE │
│ (il tuo "cervello" │ │ (TUTTE GRATUITE) │
│ che salva i dati) │ │ │
│ • Autenticazione │ │ • Open-Meteo → meteo │
│ • Database │ │ • GeoNames/ISTAT→ comuni│
│ • Storage foto │ │ • Nominatim → GPS │
└───────────┬──────────┘ └────────────┬─────────────┘
│ │
└──────────┬───────────────────┘
▼
┌─────────────────────────┐
│ LOGICA AGRONOMICA │
│ (il "cervello" che │
│ combina tutto) │
│ coltura + varietà + │
│ luogo + meteo + │
│ esposizione → │
│ DATE e CONSIGLI │
└─────────────────────────┘


**Come funziona il flusso (esempio pratico):**
1. L'utente crea un **appezzamento** e sceglie **Regione → Provincia → Comune**
   (OPPURE preme "Usa la mia posizione" e le coordinate compilano da sole)
2. L'app ricava le **coordinate** del comune (GeoNames/ISTAT o GPS)
3. Dalle coordinate ricava il **meteo** (Open-Meteo) e la **zona climatica**
4. L'utente sceglie una **coltura + varietà** dalla libreria
5. La **logica agronomica** combina tutto → date + consigli su misura

---

## 6. Risorse gratuite già esistenti (da sfruttare)

### 🌦️ Meteo
| Risorsa | Cosa dà | Limite gratis |
|---------|---------|---------------|
| **Open-Meteo** | Previsioni 16gg, storico, temperatura/pioggia/umidità **anche del suolo**, risoluzione ICON-2i (ItaliaMeteo ~2km) | **10.000 chiamate/giorno, senza API key** ⭐ |
| **MeteoHub** (Agenzia ItaliaMeteo) | Dato meteo ufficiale italiano | Accesso gratuito (con registrazione) |

### 📍 Dati territoriali (comuni/coordinate)
| Risorsa | Cosa dà | Licenza |
|---------|---------|---------|
| **GeoNames** | Coordinate (lat/lon) di ogni comune italiano | Gratuita |
| **ISTAT** | Confini comunali (confini.geojson), dati comunali, altimetria | Open data |
| **OpenStreetMap (Nominatim)** | Reverse geocoding: coordinate → indirizzo/comune | Gratis ma limitato |

### 🗺️ REVERSE GEOCODING (coordinate → Regione/Provincia/Comune)
**Strategia in 2 fasi:**
- **ORA (test):** **Nominatim** (OpenStreetMap) — gratis, max 1 richiesta/sec, richiede User-Agent + attribuzione OSM, obbligo di caching.
- **FUTURO (pubblico):** **match locale** sui confini ISTAT/GEOJSON già scaricati → zero limiti, zero costo, perfetto per un'app solo-Italia.

> 📌 Questa funzione fa 3 cose con UNA lettura GPS:
> 1. Compila Regione→Provincia→Comune automaticamente
> 2. Assegna NORD/CENTRO/SUD dalle coordinate
> 3. Fornisce le coordinate al meteo (Open-Meteo)

### 🌱 Fonti agronomiche (la "biblioteca colture")
| Risorsa | Cosa dà | Note |
|---------|---------|------|
| **Disciplinari di produzione integrata regionali** | Schede coltura complete: semina, sesti, irrigazione (litri/m²), concimazione | PDF ricchissimi (es. Emilia-Romagna) |
| **CREA** | Ricerca e banche dati agricole italiane | Istituzionale |
| **OrtoClima (ortoclima.com)** | Progetto open che collega comune→clima + criteri agronomici per coltura | Riferimento per metodo e struttura dati |

---

## 7. Stato di avanzamento (MEMORIA del progetto)
> ⚠️ AGGIORNA QUESTO FILE A OGNI SESSIONE. All'inizio di ogni sessione:
> dì all'AI: "Leggi PROJECT.md e riparti da dove eravamo."

### ✅ Fatto finora
- (2026-08-11) Pagina principale creata in IDX
- (2026-08-11) Funzione "Aggiungi nuovo appezzamento" funzionante
- (2026-08-11) Menù a tendina: Regione → Provincia → Comune
- (2026-08-11) Database geografico per i valori dei menù a tendina
- (2026-08-11) Collegamento IDX ↔ GitHub ↔ Firebase attivo

### 🔜 Da fare (prossimi passi in ordine)
1. [ ] **Assegnare Nord/Centro/Sud** in base al comune scelto (micro-task 1)
2. [ ] **Lettura GPS in tempo reale** nel box "nuovo appezzamento":
       - Pulsante "Usa la mia posizione"
       - Il sistema legge coordinate → compila Regione/Provincia/Comune
       - Reverse geocoding: test con Nominatim, poi match locale (ISTAT)
3. [ ] Usare le coordinate GPS anche per il meteo (Open-Meteo)
4. [ ] Creare prima scheda coltura (base + varietà)
5. [ ] Aggiungere colture agli appezzamenti
6. [ ] Tracciamento ciclo, promemoria, patologie da foto...

### 🐞 Bug noti / problemi incontrati
- (nessuno per ora)
- (es. XX/XX: errore su YY, risolto facendo ZZ)

### 🧠 Decisioni prese (e perché)
- Scelto **Open-Meteo** perché gratis e senza API key
- Struttura colture su **3 strati** (base → varietà → territorio)
- Posizione Nord/Centro/Sud assegnata AUTOMATICAMENTE dalla latitudine
- Reverse geocoding: Nominatim per test, match locale per rilascio pubblico
- Ideale app pubblica: cloud gratuito (Firebase/Google) — Aruba come riserva

## 8. Regole di lavoro (fondamentali per l'AI)
1. LAVORA A MICRO-PASSI: una piccola funzione alla volta, verificabile subito
2. COMMIT su GitHub dopo ogni micro-pezzo funzionante
3. DOPO ogni modifica: aggiorna la sezione 7 di questo file
4. Se non sai qualcosa, chiedi prima di scrivere codice
5. Testa nell'emulatore Firebase e nel browser IDX prima di dichiarare finito

## 9. Nota per me (il capoprogetto)
Ho chiaro COSA voglio (analisi). Non conosco la programmazione a fondo,
quindi l'AI scrive il codice, io controllo i risultati e decido.
La mia forza: comprendere l'agronomia e organizzare il lavoro.

---

## 💬 CONSIGLI DA AMICO (sezione non tecnica — ti spiega le scelte)

### Perché Nord/Centro/Sud dalla latitudine (e non "a sentimento")
Il clima in Italia non segue i confini amministrativi: non è vero che "tutta la
Toscana è Centro". Usando la **latitudine** (coordinata) la suddivisione è precisa
anche ai bordi delle zone. Dire all'AI: "usa la latitudine del comune per decidere
Nord/Centro/Sud" la rende corretta e automatica.

### Perché prima Nominatim e poi ISTAT (il reverse geocoding)
- **Ora** (test): Nominatim è il più veloce da implementare. Le limitazioni
  (1 richiesta/sec, attribuzione) non contano quando lo usi solo tu.
- **In futuro** (app pubblica): le limitazioni di Nominatim diventerebbero un
  problema. Per questo il match sui dati ISTAT scaricati in locale è la soluzione
  "che non si rompe mai" e resta gratis anche con tanti utenti.
- **Consiglio:** fai implementare entrambi con la stessa interfaccia, così il
  passaggio futuro sarà un semplice cambio interno, senza riscrivere la logica.

### Perché il meteo e la posizione usano la stessa coordinata
Le coordinate che leggi dal GPS (o che ricavi dal comune) servono a TUTTO:
compilare i menù, assegnare la zona climatica E scaricare il meteo da Open-Meteo.
Una sola lettura → tante funzioni. Attenzione solo al permesso di posizione
sul telefono (è normale, è GDPR), e ricorda che il GPS ha un piccolo margine
di errore (qualche metro) che non incide sul tuo scopo.

### Piccolo consiglio di metodo quotidiano
Alla fine di OGNI sessione di lavoro chiedi all'AI di aggiornare la sezione 7 di
questo file. Così, quando riaprirai IDX anche dopo una settimana, leggerai
"PROJECT.md" per primo e ripartirai da dove eri rimasto, senza dover ricordare
nulla a memoria.