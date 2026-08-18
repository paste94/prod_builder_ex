# Assunzioni fatte
In questo progetto sono state prese tre assunzioni dal testo: 
- il dipendente è un impiegato a tempo indeterminato
- il dipendente vive a Milano
- il dipendente non ha nessun tipo di agevolazione particolare

Oltre a queste, sono state aggiunte altre assunzioni per semplicità del contesto, di seguito elencate: 
- Per il calcolo della quota INPS si considera solo il 9.19% a carico del dipendente. Le quote a carico del datore di lavoro sono state omesse per semplicità. Viene considerata la possibilità di lavoro dipendente privato (9,19%), pubblico (8,80%) o ex istituti di previdenza (8,85%)
- Il massimale annuo INPS per il 2026 è stato fissato a 122295€, ignorando il caso dei dirigenti sanitari. (https://www.faroconsulenze.it/2026/01/19/guida-completa-ai-contributi-previdenziali-2026_-inps-cassa-forense-e-inarcassa/)

# Backend
Il backend ha il compito di calcolare il netto partendo da un reddito lordo. Il calcolo tiene conto di INPS e IRPEF e addizionali comunali e regionali.  Le aliquote utilizzate sono quelle previste per il 2026. La sua implementazione è stata realizzata utilizzando la libreria FastAPI e testata usando unittest di python su casi limite e casi tipo, come un reddito di 8k, 30k e 1M annui. 


# Run project
## backend
uvicorn app.main:app --reload --port 8000
## backend tests
pytest -v

# Semplificazioni
- Per una questione di semplicità, sono state inserite nel codice direttametne alcune informazioni che sarebbero dovute essere messe in un file di configurazione a parte (es aliquote, addizionali, ecc..) così come variabili di ambiente (url, porte ecc...). Si ritiene in ogni modo che per una demo la cosa non sia problematica, ma che sarebbe da correggere in un contesto produttivo.

