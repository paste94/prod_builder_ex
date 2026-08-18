# Jet HR Net Salary Calculator

Prototipo di calcolatore dello stipendio netto per un dipendente standard in Italia (Milano, anno fiscale 2026). Il progetto è stato sviluppato come parte di un task tecnico per Jet HR.

## Live Demo

- **Frontend:** https://jet-hr-frontend.web.app
- **Backend API:** https://prodbuilderex-production.up.railway.app

## Assunzioni del prototipo

Il calcolatore stima il netto per un caso standard semplificato:

- **Contratto:** dipendente privato a tempo indeterminato.
- **Residenza fiscale:** Milano, Lombardia.
- **Anno fiscale:** 2026.
- **Nessun familiare a carico**, nessun bonus, agevolazione o regime speciale.
- **Nessun welfare, premio, straordinario, fringe benefit, TFR, trattenute sindacali, cessione del quinto** o altre voci variabili.
- **Contributi INPS a carico del datore di lavoro non inclusi** nel calcolo del netto (non sono trattenute dal lordo del dipendente).

## Architettura generale

Il sistema è composto da due servizi separati:

- **Backend (FastAPI):** espone un'API REST che riceve la RAL e altre informazioni, applica le regole fiscali e restituisce una breakdown dettagliata del calcolo.
- **Frontend (Flutter Web):** interfaccia utente che raccoglie l'input, chiama l'API e visualizza i risultati in modo chiaro.

### Backend

- **Linguaggio:** Python
- **Framework:** FastAPI
- **Struttura:**
  - `app/main.py`: definizione dell'app, middleware CORS, endpoint.
  - `app/calculator.py`: motore di calcolo (funzioni pure).
  - `app/tax_rules_2026.py`: parametri fiscali 2026 (aliquote, scaglioni, addizionali).
  - `app/schemas.py`: modelli Pydantic per request/response.
- **Logica principale:**
  1. Calcolo contributi INPS dipendente, a secondo che sia un dipendente pubblico, privato o ex istituti di previdenza.
  2. Calcolo imponibile fiscale.
  3. IRPEF progressiva per scaglioni.
  4. Detrazione da lavoro dipendente.
  5. Addizionale regionale Lombardia.
  6. Addizionale comunale Milano.

### Frontend

- **Framework:** Flutter Web
- **Struttura:**
  - `lib/main.dart`: UI principale (form, risultati, assunzioni).
  - `lib/models.dart`: modelli `SalaryRequest`, `SalaryResponse`, `ContractType`.
  - `lib/api.dart`: servizio HTTP per chiamare il backend.
- **Funzionalitàºº:**
  - Input RAL con validazione.
  - Selezione del tipo di contratto (PRIVATE, PUBLIC, SPECIAL).
  - Breakdown dettagliata delle trattenute.
  
## Deploy

### Backend (Railway)

Il backend è deployato su Railway usando Docker.

- **Repo:** https://github.com/paste94/prod_builder_ex
- **Root Directory:** `backend`
- **Build:** Dockerfile
- **Start Command:** `uvicorn app.main:app --host 0.0.0.0 --port 8000`
- **URL:** https://prodbuilderex-production.up.railway.app

**CORS:** il middleware è configurato per accettare richieste dal frontend deployato su Firebase Hosting.

### Frontend (Firebase Hosting)

Il frontend è buildato localmente e deployato su Firebase Hosting.

```bash
cd frontend

# Build di produzione
./build.sh

# Deploy
./deploy.sh
```

- **URL:** https://jet-hr-frontend.web.app

## API

### POST /api/v1/net-salary-estimates

**Request:**

```json
{
  "gross_annual_salary": "35000",
  "salary_payments": 13,
  "contract_type": "PRIVATE"
}
```

**Response:**

```json
{
    "inps": "2757.00", 
    "taxable_income": "27243.00", 
    "irpef": "6265.89", 
    "deduction": "2979.29", 
    "ded_irpef": "3286.60", 
    "regional_addition": "430.44", 
    "city_addition": "217.94", 
    "net_salary": "23308.02",
    "monthly_salary": "1942.34"
}
```

## Test

### Backend

```bash
cd backend
source .venv/bin/activate
python -m pytest -v
```

I test coprono:

- Health endpoint.
- Calcolo netto per contratto standard.
- Validazione input (RAL negativa, contract_type non valido).

## Fonti e riferimenti

- Info generali sulle regole di calcolo 2026 (https://www.money.it/stipendio-netto-da-lordo-calcolo-nuova-formula)
- Info calcoli INPS (https://www.welpy.it/pensioni-cpdel-cps-cpi-e-cpug-chiarimenti-inps-sulle-quote-retributive/)
- Calcolatore per confronto risultati (https://calcolostipendionettoda.it/)
- Addizionale IRPEF Milano (https://www.comune.milano.it/argomenti/tributi/addizionale-comunale-irpef)
- Addizionale IRPEF Lombardia 2026 (https://www.businessonline.it/news/addizionale-irpef-lombardia-2026-quando-si-paga-percentuali-aggiornate-tassazione-dipendenti-e-pensionati-calcoli-ed-esempi_n82272.html)

## Limiti e possibili evoluzioni

- Gestione di altre tipologie contrattuali (apprendistato, part-time, ecc.).
- Supporto per altre regioni e comuni.
- Detrazioni per familiari a carico.
- Calcolo mensile con tempistiche di ritenuta e conguaglio.
- Integrazione con fonti normative ufficiali per aggiornamento automatico delle aliquote.

## Autore

Riccardo Pasteris  
Email: riccardopasteris@gmail.com  
GitHub: https://github.com/paste94
