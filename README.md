# Analisi dei clienti di una banca

## Descrizione del Progetto

Il progetto descrive le fasi di realizzazione di una tabella denormalizzata contenente i dati anonimizzati dei clienti di una banca a partire dal database della stessa. Per la realizzazione del progetto è stato utilizzato il linguaggio SQL, con particolare riferimento a MySQL.

## Il Dataset

Il dataset fornito consiste in un file SQL contenente il database bancario, a sua volta composto dalle seguenti tabelle:

*  La tabella *cliente* contenente i dati sulla clientela.
*  La tabella *conto* con i dati sui conti posseduti dai clienti.
*  La tabella *tipo_conto* con le tipologie di conti disponibili.
*  La tabella *tipo_transazione* con le tipologie di transazione ammissibili dalla banca.
*  La tabella *transazioni* con le transazioni effettuate dai clienti.

## Struttura del Repository

Il progetto è organizzato come segue:

*  `notebooks/`: Il file SQL in cui sono descritte le fasi del progetto.
*  `data/`: Il file SQL con i dati per il progetto.
*  `README.md`: Questa guida descrittiva.

## Metodologia e Fasi del Lavoro

Una volta eseguito il file SQL contenente il dataset, ho esplotato il database e le tabelle in esso contenute per poi effettuare delle query intermedie per calcolare i campi richiesti per il progetto. La tabella finale è stata ottenuta estraendo i dati dalle subquery e importandole in una tabella creata ad hoc.

##Tecnologie e Librerie Utilizzate
*  **Linguaggio principale:** SQL

---
*Progetto realizzato da **[Beatrice Taffetani](https://github.com/BTaffetani/beatrice-taffetani/blob/main/README.md)***
