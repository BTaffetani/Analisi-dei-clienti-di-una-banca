-- ANALISI DATABASE BANCARIO
-- Su richiesta dell'azienda Banking Intelligence, il progetto riporta la costruzione di una tabella denormalizzata con i dati della clientela della banca a partire dal database fornito dall'azienda stessa. Il progetto illustrerà le fasi che sono occorse per la costruzione della tabella, dall'esplorazione del database fino ai risultati finali.

-- Esplorazione contenuto database
-- Prima di procedere con il progetto, abbiamo esplorato il database fornito dall'azienda tramite il file db_bancario.sql.
-- Una volta eseguito lo script, abbiamo diviso il contenuto del database in due categorie.

-- Tabelle sulla clientela
-- Queste tabelle riportano i dati dei clienti della banca e sono le tabelle 'cliente', 'conto' e 'transazioni'. Le query che seguono mostrano il contenuto delle tabelle appena nominate.

SELECT * FROM banca.cliente;

SELECT * FROM banca.conto;

SELECT * FROM banca.transazioni;

-- Tabelle informative
-- Le tabelle informative della banca sono 'tipo_conto' e 'tipo_transazione' e illustrano, rispettivamente, i tipi di conto attivabili e i tipi di transazione in entrata e in uscita che sono permessi dalla banca. Il contenuto di entrambe le tabelle è esplorabile nelle seguenti query.

SELECT * FROM banca.tipo_conto;

SELECT * FROM banca.tipo_transazione;

-- Query utili per il progetto
-- Abbiamo iniziato il progetto interrogando il database in modo da estrarre gli indicatori richiesti dall'azienda.

-- Indicatori di base
-- In questa prima query abbiamo ottenuto l'età per ogni cliente. L'età è stata ottenuta dividendo il numero di giorni dalla data di nascita per 365.25 (in modo da considerare gli anni bisestili) e arrotondando per difetto il risultato.

SELECT id_cliente,
floor(datediff(current_date(), data_nascita)/365.25) AS eta
FROM banca.cliente
ORDER BY 1;

-- Indicatori sulle transazioni
-- Nella seconda query di seguito riportata abbiamo conteggiato per ogni cliente il numero di transazioni in entrata e in uscita e abbiamo sommato i rispettivi importi. Per leggibilità, gli importi sono stati arrotondati alla seconda cifra decimale e privati del segno.

SELECT conto.id_cliente,
SUM(
	CASE WHEN tipo_transazione.segno='-' THEN 1 ELSE 0 END
) AS n_uscite,
SUM(
	CASE WHEN tipo_transazione.segno='+' THEN 1 ELSE 0 END
) AS n_entrate,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate
FROM banca.conto conto
LEFT JOIN banca.transazioni transazioni
ON conto.id_conto = transazioni.id_conto
LEFT JOIN banca.tipo_transazione tipo_transazione
ON transazioni.id_tipo_trans = tipo_transazione.id_tipo_transazione
GROUP BY 1
ORDER BY 1;

-- Indicatori sui conti
-- Nella terza query abbiamo conteggiato il numero totale di conti per ogni cliente e abbiamo contato il numero di conti per ciascuna tipologia.

SELECT id_cliente,
COUNT(id_conto) AS n_conti,
SUM(CASE WHEN tipo_conto.desc_tipo_conto='Conto Base' THEN 1 ELSE 0 END) AS n_base,
SUM(CASE WHEN tipo_conto.desc_tipo_conto='Conto Business' THEN 1 ELSE 0 END) AS n_business,
SUM(CASE WHEN tipo_conto.desc_tipo_conto='Conto Privati' THEN 1 ELSE 0 END) AS n_privati,
SUM(CASE WHEN tipo_conto.desc_tipo_conto='Conto Famiglie' THEN 1 ELSE 0 END) AS n_famiglie
FROM banca.conto conto
LEFT JOIN banca.tipo_conto tipo_conto
ON conto.id_tipo_conto = tipo_conto.id_tipo_conto
GROUP BY 1
ORDER BY 1;

-- Indicatori sulle transazioni per tipologia di conto
-- Nella quarta e ultima query, abbiamo eseguito le stesse operazioni della seconda query (conteggio delle transazioni e somma degli importi) ma dividendole per tipologia di conto. Anche in questo caso, gli importi sono stati arrotondati alla seconda cifra decimale per leggibilità.

SELECT conto.id_cliente,
SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Base' THEN 1 ELSE 0 END
) AS n_uscite_base,
SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Base' THEN 1 ELSE 0 END
) AS n_entrate_base,
SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Business' THEN 1 ELSE 0 END
) AS n_uscite_business,
SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Business' THEN 1 ELSE 0 END
) AS n_entrate_business,
SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Privati' THEN 1 ELSE 0 END
) AS n_uscite_privati,
SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Privati' THEN 1 ELSE 0 END
) AS n_entrate_privati,
SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Famiglie' THEN 1 ELSE 0 END
) AS n_uscite_famiglie,
SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Famiglie' THEN 1 ELSE 0 END
) AS n_entrate_famiglie,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Base' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite_base,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Base' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate_base,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Business' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite_business,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Business' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate_business,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Privati' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite_privati,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Privati' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate_privati,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Famiglie' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite_famiglie,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Famiglie' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate_famiglie
FROM banca.conto conto
LEFT JOIN banca.transazioni transazioni
ON conto.id_conto = transazioni.id_conto
LEFT JOIN banca.tipo_transazione tipo_transazione
ON transazioni.id_tipo_trans = tipo_transazione.id_tipo_transazione
LEFT JOIN banca.tipo_conto tipo_conto
ON conto.id_tipo_conto = tipo_conto.id_tipo_conto
GROUP BY 1
ORDER BY 1;

-- Creazione tabella degli indicatori
-- Una volta create le query, abbiamo creato la tabella obiettivo del progetto. Per una questione di pulizia del database, eventuali duplicati della tabella saranno eliminati.
DROP TABLE IF EXISTS banca.indicatori_clienti;

CREATE TABLE banca.indicatori_clienti(
	id_cliente INTEGER,
    eta INTEGER,
    n_uscite INTEGER,
    n_entrate INTEGER,
    tot_importo_uscite FLOAT,
    tot_importo_entrate FLOAT,
    n_conti INTEGER,
    n_base INTEGER,
    n_business INTEGER,
    n_privati INTEGER,
    n_famiglie INTEGER,
    n_uscite_base INTEGER,
    n_entrate_base INTEGER,
    n_uscite_business INTEGER,
    n_entrate_business INTEGER,
    n_uscite_privati INTEGER,
    n_entrate_privati INTEGER,
    n_uscite_famiglie INTEGER,
    n_entrate_famiglie INTEGER,
    tot_importo_uscite_base FLOAT,
    tot_importo_entrate_base FLOAT,
    tot_importo_uscite_business FLOAT,
    tot_importo_entrate_business FLOAT,
    tot_importo_uscite_privati FLOAT,
    tot_importo_entrate_privati FLOAT,
    tot_importo_uscite_famiglie FLOAT,
    tot_importo_entrate_famiglie FLOAT
);

-- Popoliamo la tabella utilizzando le query precedenti come subquery in modo da non occupare spazio nel database. La funzione COALESCE assicura l'imputazione dell'assenza di valori nelle colonne diverse da id_cliente.
INSERT INTO banca.indicatori_clienti
SELECT base.id_cliente AS id_cliente,
COALESCE(base.eta,0) AS eta,
COALESCE(trans.n_uscite,0) AS n_uscite,
COALESCE(trans.n_entrate,0) AS n_entrate,
COALESCE(trans.tot_importo_uscite,0.00) AS tot_importo_uscite,
COALESCE(trans.tot_importo_entrate,0.00) AS tot_importo_entrate,
COALESCE(conti.n_conti,0) AS n_conti,
COALESCE(conti.n_base,0) AS n_base,
COALESCE(conti.n_business,0) AS n_business,
COALESCE(conti.n_privati,0) AS n_privati,
COALESCE(conti.n_famiglie,0) AS n_famiglie,
COALESCE(trans_conto.n_uscite_base,0) AS n_uscite_base,
COALESCE(trans_conto.n_entrate_base,0) AS n_entrate_base,
COALESCE(trans_conto.n_uscite_business,0) AS n_uscite_business,
COALESCE(trans_conto.n_entrate_business,0) AS n_entrate_business,
COALESCE(trans_conto.n_uscite_privati,0) AS n_uscite_privati,
COALESCE(trans_conto.n_entrate_privati,0) AS n_entrate_privati,
COALESCE(trans_conto.n_uscite_famiglie,0) AS n_uscite_famiglie,
COALESCE(trans_conto.n_entrate_famiglie,0) AS n_entrate_famiglie,
COALESCE(trans_conto.tot_importo_uscite_base,0.00) AS tot_importo_uscite_base,
COALESCE(trans_conto.tot_importo_entrate_base,0.00) AS tot_importo_entrate_base,
COALESCE(trans_conto.tot_importo_uscite_business,0.00) AS tot_importo_uscite_business,
COALESCE(trans_conto.tot_importo_entrate_business,0.00) AS tot_importo_entrate_business,
COALESCE(trans_conto.tot_importo_uscite_privati,0.00) AS tot_importo_uscite_privati,
COALESCE(trans_conto.tot_importo_entrate_privati,0.00) AS tot_importo_entrate_privati,
COALESCE(trans_conto.tot_importo_uscite_famiglie,0.00) AS tot_importo_uscite_famiglie,
COALESCE(trans_conto.tot_importo_entrate_famiglie,0.00) AS tot_importo_entrate_famiglie
FROM
(SELECT id_cliente,
floor(datediff(current_date(), data_nascita)/365.25) AS eta
FROM banca.cliente) base
LEFT JOIN (SELECT conto.id_cliente,
SUM(
	CASE WHEN tipo_transazione.segno='-' THEN 1 ELSE 0 END
) AS n_uscite,
SUM(
	CASE WHEN tipo_transazione.segno='+' THEN 1 ELSE 0 END
) AS n_entrate,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate
FROM banca.conto conto
LEFT JOIN banca.transazioni transazioni
ON conto.id_conto = transazioni.id_conto
LEFT JOIN banca.tipo_transazione tipo_transazione
ON transazioni.id_tipo_trans = tipo_transazione.id_tipo_transazione
GROUP BY 1) trans
ON base.id_cliente = trans.id_cliente
LEFT JOIN (SELECT id_cliente,
COUNT(id_conto) AS n_conti,
SUM(CASE WHEN tipo_conto.desc_tipo_conto='Conto Base' THEN 1 ELSE 0 END) AS n_base,
SUM(CASE WHEN tipo_conto.desc_tipo_conto='Conto Business' THEN 1 ELSE 0 END) AS n_business,
SUM(CASE WHEN tipo_conto.desc_tipo_conto='Conto Privati' THEN 1 ELSE 0 END) AS n_privati,
SUM(CASE WHEN tipo_conto.desc_tipo_conto='Conto Famiglie' THEN 1 ELSE 0 END) AS n_famiglie
FROM banca.conto conto
LEFT JOIN banca.tipo_conto tipo_conto
ON conto.id_tipo_conto = tipo_conto.id_tipo_conto
GROUP BY 1) conti
ON base.id_cliente = conti.id_cliente
LEFT JOIN (SELECT conto.id_cliente,
SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Base' THEN 1 ELSE 0 END
) AS n_uscite_base,
SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Base' THEN 1 ELSE 0 END
) AS n_entrate_base,
SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Business' THEN 1 ELSE 0 END
) AS n_uscite_business,
SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Business' THEN 1 ELSE 0 END
) AS n_entrate_business,
SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Privati' THEN 1 ELSE 0 END
) AS n_uscite_privati,
SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Privati' THEN 1 ELSE 0 END
) AS n_entrate_privati,
SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Famiglie' THEN 1 ELSE 0 END
) AS n_uscite_famiglie,
SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Famiglie' THEN 1 ELSE 0 END
) AS n_entrate_famiglie,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Base' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite_base,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Base' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate_base,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Business' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite_business,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Business' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate_business,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Privati' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite_privati,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Privati' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate_privati,
round(SUM(
	CASE WHEN tipo_transazione.segno='-' AND tipo_conto.desc_tipo_conto='Conto Famiglie' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_uscite_famiglie,
round(SUM(
	CASE WHEN tipo_transazione.segno='+' AND tipo_conto.desc_tipo_conto='Conto Famiglie' THEN abs(transazioni.importo) ELSE 0 END
),2) AS tot_importo_entrate_famiglie
FROM banca.conto conto
LEFT JOIN banca.transazioni transazioni
ON conto.id_conto = transazioni.id_conto
LEFT JOIN banca.tipo_transazione tipo_transazione
ON transazioni.id_tipo_trans = tipo_transazione.id_tipo_transazione
LEFT JOIN banca.tipo_conto tipo_conto
ON conto.id_tipo_conto = tipo_conto.id_tipo_conto
GROUP BY 1) trans_conto
ON base.id_cliente = trans_conto.id_cliente
ORDER BY 1;

-- La query che segue verifica che il popolamento della tabella sia andato a buon fine.
SELECT * FROM banca.indicatori_clienti;

-- Conclusioni
-- Il progetto appena presentato è stato richiesto dall'azienda Banking Intelligence allo scopo di realizzare una tabella denormalizzata per l'addestramento di modelli di Machine Learning.
-- Dopo una prima esplorazione del database, abbiamo realizzato query intermedie propedeutiche per il calcolo degli indicatori richiesti dalle specifiche fornite dall'azienda committente. Infine, nella sezione finale, abbiamo creato la tabella richiesta popolandola tramite una join di subquery delle tabelle viste in precedenza, verificando tramite la query finale che le operazioni fossero andate a buon fine.
-- La tabella richiesta è stata elaborata direttamente in memoria senza la creazione di strutture di appoggio che altrimenti avrebbero occupato spazio nel database del cliente.
-- L'utilizzo di LEFT JOIN e la gestione dei valori nulli tramite COALESCE garantiscono l'integrità del dato, rendendo il dataset pronto per le elaborazioni future.