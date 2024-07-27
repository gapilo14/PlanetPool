# PlanetPool
PlanetPool porta il gioco del biliardo al di fuori del pianeta terra. Con i suoi crescenti livelli, è possibile provare a giocare in condizioni di gravità diverse da quelle del Pianeta Terra. Grazie ai suoi 15 livelli, il gioco ha una durata complessiva di circa 1 ora. 

## Il progetto universitario
PlanetPool è il risultato di un progetto svolto assieme ad Andrea Raccanelli e Federico Viol per il [Laboratorio di Game Programming](https://www.dmif.uniud.it/triennale/stm/piano-di-studio/laboratorio-di-game-programming/) del corso di [Laurea in Scienze e Tecnologie Multimediali (STM)](https://www.uniud.it/it/didattica/corsi/area-scientifica/scienze-matematiche-informatiche-multimediali-fisiche/laurea/scienze-tecnologie-multimediali/corso/scienze-e-tecnologie-multimediali-interclasse-l20l31) dell'[Università degli Studi di Udine](https://www.uniud.it). L'obiettivo da raggiungere era costruire un videogioco inerente al mondo dello sport utilizzando [Solar2D](https://solar2d.com/) come motore di gioco e [Tiled](https://www.mapeditor.org/) come gestore dei livelli. 
La valutazione del progetto teneva in considerazione la giocabilità, l'originalità e la creatività del prodotto finale; il gioco presenta, pertanto, delle scelte progettuali non accurate inerenti alla scrittura e struttura del codice che, in caso di ulteriori sviluppi, richiedono una profonda rivisitazione e ottimizzazione.

## Sviluppo del gioco
PlanetPool si presenta come un videogioco incentrato sul biliardo con l'ambizione di simulare diverse condizioni gravitazionali (da qui il nome Planet). Per raggiungere tale obiettivo, è stato condotto uno studio sulla fisica del gioco del biliardo e su come la variabile "forza di gravità" può modificare il comportamento delle bilie.

### Le risorse
La maggior parte delle risorse del gioco sono originali e create da noi. I suoni, i tavoli di gioco, le stecche e molto altro sono state disegnate e realizzate da noi appositamente per PlanetPool. Fanno eccezione l'immagine di sfondo iniziale e la musica di background per i quali sono state utilizzate risorse disponibili pubblicamente sul web. 


### Possibili miglioramenti
Ogni livello può potenzialmente diventare un mini-gioco a se stante. Questo spiega le molteplici copie di risorse identiche all'interno delle singole cartelle del gioco. È possibile centralizzare le risorse del gioco in un'unica posizione così da ottimizzare il gioco (spece dal punto di vista dell'archiviazione), ma è una miglioria che non verrà implementata in futuro.


## Report (+ FAQ e tips)
In aggiunta al gioco, viene resa disponibile la relazione consegnata assieme al gioco dove è possibile trovare una spiegazione molto più dettagliata del codice sviluppato, delle scelte progettuali e del lavoro di squadra che ha reso possibile lo sviluppo del gioco. Il documento è disponibile su [Notion](https://appuntidigap.notion.site/Relazione-Planet-Pool-82c6abdb427e41688fc74fcf94e9ac5c).

## Come giocare
La presente repository contiene solo il codice sorgente del gioco: per eseguirlo è necessario aver installato il motore di gioco [Solar2D](https://solar2d.com/). È quindi sufficiente caricare all'interno del motore di gioco il file `main.lua` presente nella cartella del progetto e avviare il simulatore. 
Il gioco è progettato per schermi 1920x1080 pixels e raggiunge un framerate massimo di 60FPS. L'utilizzo con touchscreen non è stato testato ma dovrebbe essere nativamente supportato. 

Ci auguriamo che possa essere di vostro gradimento :)

Andrea, Federico e Gabriele



Sviluppato nell'inverno 2023
