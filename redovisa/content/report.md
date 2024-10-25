<h2 id="kmom01">kmom01</h2>

Jag har jobbat i WSL Ubuntu under hela första läsåret, så det mesta i vlinux kmom01 vad gäller unix-kommandon är bekant sedan tidigare.

Jag gillar unix-kommandon. De känns kraftfulla och enkla, och ju mer jag lär mig om dem, desto mindre riskfyllda känns de.

Installationen av Docker flöt på fint.

Jag blev lite osäker på om jag behövde ändra något i imagen `ubuntu:22.04` för att rättaren ska kunna köra min `info.bash`, men jag tolkar det som att rättaren också kommer köra `unminimize`, `apt install cowsay` etc.

För me-sidan valde jag att göra en egen liten lösning med `Twig` och `Markdown`, som jag tycker är smidiga att använda. Med hjälp av funktionen `renderPage` i  `render_service.php` kan twig-templates och markdown-content parsas. Jag har även lagt på lite style.

Veckans TIL blir konceptet som Docker innebär, med möjligheten att definiera en komplett miljö som kan köras på vilket system som helst.


<h2 id="kmom02">kmom02</h2>

Under de tidigare kursernas gång har jag stött på några olika bash-script, och jag har även skrivit något enkelt eget skript för att automatisera kopiering av filer eller liknande.

Syntaxen i bash är ganska enkel och bekväm, och påminner bitvis om python i att det inte behövs så många specialtecken, och att radbrytingar fungerar som avskiljare många gånger.
Hanteringen av arrayer och strängar tog lite tid att greppa; särskilt konceptet *word splitting*, som jag inte känner igen från något annat språk. Den centrala datatypen verkar vara *string*, och andra typer som *integer* eller *array* verkar i princip vara strängar som hanteras på ett eget sätt. Antalet inbyggda funktioner verkar vara ganska begränsat.

Det känns som att bash-script-programmering kommer va ett bra verktyg för enklare uppgifter, som hantering av filer och automatisering av manuella kommandon. Utmaningen kanske ligger i att begränsa användingsområdet till vad det är bäst för. 

Uppgifterna flöt på bra, men jag ägnade extra tid för att få grepp om specifika saker, till exempel *word splitting*.

Jag gillar helt klart koncepten i GNU/Linux. Det känns kraftfullt och spännande.


<h2 id="kmom03">kmom03</h2>

Jag har inte skapat något som liknar *Apache name-based virtual hosts* på egen hand tidigare. Det var inte svårt, men det krävdes noggrannhet för att få allt på plats. Den här typen av kunskap är svårt att räkna ut på egen hand, men när man lärt sig är det ganska enkelt.

Det är kul med terminal-kommandon som `grep`, `cut`, `head` med flera, där man får jobba med logiskt tänkande för att lösa specifika uppgifter. Jag lade lite extra tid på att lära mig mer om *regular expressions*, vilket jag hade nytta av i labben.

Portar fungerar som virtuella dörrar hos en maskin. Förutom att genom en ip-adress nå rätt maskin, kan man även tala om vilket port som ska användas, för att information ska komma till rätt destination, där den behandlas av rätt mjukvara. Det finns drygt 65000 portar hos en maskin, och vissa av dem är reserverade för specifika ändamål. För utveckling kan exempelvis 8080 vara en lämplig port för inkommande trafik till servern, medan 80 (HTTP) eller 443 (HTTPS) är standard för produktion.

Jag känner att jag har fått grepp om hur volymer fungerar i Docker nu. Det är betydligt smidigare än att kopiera in filer manuellt, och det minskar risken för att förlora data.

Jag gillar *GNU/Linux*. Ju mer bekväm man blir i att hoppa runt i terminalen, desto mer får man nytta av alla kraftfulla funktioner.


<h2 id="kmom04">kmom04</h2>

Jag valde att lösa både express- och Flask-server. Express-imagen ligger som default i `dockerhub.bash`, och Flask-imagen kan köras med `dockerhub.bash --flask`.
Jag började med att göra en express-server, eftersom det låg närmast till hands för mig. Sen ville jag utmana mig med att skriva lite python-kod, vilket jag inte gjort på mer än ett år. Det gick snabbare att komma in i python-kodandet än jag trodde, vilket var skönt, och jag gillar hur avskalad syntaxen är.

Arbetet med Docker flyter på bra, och det känns bekvämt med de olika kommandona vi använder. När jag byggde min Flask-image fick jag lite trubbel med `FROM debian:stretch-slim` (verkar inte vara tillgänglig), men jag fick det att fungera med `FROM debian:bullseye-slim` istället.

Begreppen klient och server är inga konstigheter vid det här laget. En klient är en applikation som skickar en förfrågan (request) till en server. Servern är en applikation som lyssnar efter förfrågningar, behandlar dem, och skickar ett svar (response), som klienten tar emot och gör något med.

I `client.bash` lade jag in while-loopen i en main-funktion, men i övrigt behöll jag ungefär samma struktur.
Jag blev nöjd med save-funktionen, där jag kallar på scriptet rekursivt med resterande argument, och gör en redirect till fil.


<h2 id="kmom05">kmom05</h2>

Det var kul att jobba med mazerunner-scriptet, och det flöt på bra tycker jag. När jag började på uppgiften *parsade* jag csv-strängar med `grep` och `cut`, vilket var lite onödigt krångligt. Jag gick över till att *parsa* `json` med `jq` istället, vilket underlättade.

Det var intressant att kolla lite på källkoden för servern, för att lära sig något om hur man kan jobba med request och response manuellt i backend.
Det hade känts bäst att kunna använda serverns responses för att delge information, både vid lyckade och misslyckade requests, men svaren var inte tillräckligt bra, så jag gjorde kontroll för `maps` och `enter` på klient-sidan. Servern krachar till exempel om man gör `enter` före `select`, och ett otydligt svar ges när man försöker köra `select` två gånger.

Eftersom scriptet växte snabbt valde jag bryta ut koden i moduler. `mazerunner.bash` är en main-fil, med funktionen `main`, som hanterar options/commands/argument, och anropar lämplig funktion. `core.bash` innehåller de centrala funtionerna för respektive kommando. `utils.bash` innehåller hjälpfuntioner, som utför små avgränsade uppgifter, vilka återanvänds på många ställen i koden. `variables.bash` definierar ett antal globala variabler, några med värden, och några tomma som sätts senare i funktioner. `.game_config` skapas vid `init`, och håller `GAME_ID`, `MAPS_AVAIABLE`, `SELECTED_MAP`, och `ROOM_ID`. Samtliga moduler läses in (`source`) från `mazerunner.bash`.

Reguljära uttryck har dykt upp lite då och då under utbildningen, men det är inte förrän nu jag börjar på grepp om det. Det finns en hel del mer att lära, men jag känner att jag kommit över tröskeln för att det ska kännas kul och hyfsat bekvämt.


<h2 id="kmom06">kmom06</h2>

Jag tycker *docker compose* verkar vara ett väldigt smidigt sätt att hantera sina *nätverk* och *services* på. I några avseenden kanske man har mer kontroll över options och dylikt om man kör varje kommando manuellt, eller via ett bash script, men det mesta verkar gå att styra i config-filen, eller genom options i kommandot, på ett enkelt sätt. Jag kan se att stora projekt med många nätverk, services med mera drar ännu större fördelar av compose, där dokumentation blir tydligare, och hanteringen blir enkare.
Docker känns bekvämt tycker jag, och jag kommer säkert ha stor användning för det i framtiden. Till exakt vad vet jag inte ännu.

Jag tror jag har en hyfsat klar bild av begreppen klient och server. Klienten ställer frågor till servern, vilken lyssnar, processar och svarar...

För att kunna återanvända koden på ett bra sätt i spel-loopen i mazerunner, ändrade jag om i funktionerna för respektive spel-kommando, så att de sparar text i en global variabel, som i sin tur skrivs ut vid behov. Tidigare gjordes utskrifterna direkt i funktionerna. Jag fick även bryta ut några kontroll-funktioner, så att fel i user input och liknande inte automatiskt stänger programmet. Det var en nyttig uppgift att jobba med *refactoring* av sin egen kod, för att märka vikten av att dela upp koden i små flexibla delar.

Det har varit kul att lära sig jobba med `sed` och `awk`. `sed` känns ett steg mer kraftfullt än `grep`, med stöd för *substitution* och möjlighet att editera en fil direkt. `awk` känns i sin tur några steg mer avancerat än `sed`, med stöd för en mängd olika saker, som ett eget litet programmeringsspråk. Det känns skönt att lära sig olika verkyg som gör linux-miljön enklare.


<h2 id="kmom10">bthloggen (kmom10)</h2>

### krav 1

`log2json.bash` skapar mappen `./data` om den inte redan finns med `mkdir -p`, exekverar `2json.awk` med `access-50k.log` som *input-fil*, och `data/log.json` som *output-fil*, samt mäter tiden och skriver ut status.

I `2json.awk` skapas/ersätts *output-filen*, och varje rad i *input-filen* itereras. Varje rad matchas mot ett reguljärt uttryck, som kontrollerar och fångar upp ip, dag, månad, tid och url (*case-insensitive*). Månad och url konverteras till *lower case*, och sedan skrivs datan för varje rad i json-format till *output-filen*.

Tiden för exekvering brukar ligga mellan två och tre sekunder. Jag jobbade på att optimera skriptet genom att bygga upp en sträng för varje rad/json-objekt, och skriva till fil en gång per objekt istället för sju, men exekveringstiden påverkades inte märkbart.

### krav 2

Jag letade efter ett ramverk som skulle vara lämpligt för ett REST API, och där jag samtidgt kunde lära mig något nytt. Det landade i python och FastAPI, och det blev både en rolig och bra lösning. Docker-containern får utgå från `python:3.13-slim`, och sedan installera vad som behövs för ramverket. Kommandot `"--host", "0.0.0.0"` ser till att servern även kan ta emot requests via localhost.

Servern lyssnar efter requests på tre routes, vilka svarar med response med json-body. `/` ger en dokumentation över olika routes, `/filters` ger en lista med de olika filter som stöds, och `/data` ger hela eller matchande delar av log-filen.

Jag valde att bygga stöd för *query strings* hos `/data` routen, för att enkelt kunna stödja filtrering med valfritt antal filter. FastAPI hade en smidig lösning för att fånga upp parameterna och dess värden, genom att ange parameterna som argument till funktionen `get_data()`

Klassen `LogHandler` får ansvaret att läsa in log-filen, och filterar den med de filter som skickas med (i den ordning som filterna är angivna), och returnerar en lista med *dictionaries*. FastAPI hanterar datastrukturen, och levererar automatiskt ett json-response. Metoderna är asynkrona, vilket förbättrar prestandan vid flera parallella requests.

Koden för filtrering av log-filen är uppdelad i tre olika metoder, som gör exakt matching (dag, månad), sub-strängs-matchning (ip, url), och matchning av början av sträng (time). Ordningen för filterna styrs i `get_data()`, och jag valde ordningen ip, time, day, url, month baserat på hur den specifika log-filen ser ut, och hur jag tror en användare skulle nyttja filterna. Syftet var att tidigt få ner antalet matchningar, vilket tidsoptimerar filtreringen.


### krav 3

Den grundläggande strukturen för bash-scriptet är samma som i *mazerunner 1*, med en main-modul `bthloggen.bash` som hanterar inkommande argument, `.env` med globala variabler, och ett antal moduler `src/` med funktioner för request, felhantering, verifiering, parsning, samt huvudfunktioner `src/core.bash` som styr flödet för respektive option/kommando.

Med kommandot `use` sätts den globala variablen `CUSTOM_HOST` genom att `CUSTOM_HOST="<host-name>"` skrivs till filen `.host_name`, vilken läses in i `bthloggen.bash` om den finns.

`url` visar upp de publicerade adressera till både log-servern och webbklienten.

`view [<filter> <value> ...]` anropar `app_view` optionella filter som argument. Filterna verifieras mot log-serverns `/filters`, och en *query string* samt läsbar sträng byggs upp. Därefter skickas en förfrågan till logserverns `/data<query>`, responsen verifieras, och sparas till en temporär fil (`sed` för att skala bort header), som sedan parsas till csv med `jq`, och till tabellformat med `awk`. Innehållet i den temporära filen uppdatteras för varje steg. Till slut skrivs tabellen ut inramad och med rubrik. När programmet avslutas rensas den temporära filen bort med `trap 'rm -f "$RESPONSE_TEMP"' EXIT`.

`--count` kan användas som option till `view`, och då anropas istället `app_count_view`, där json-objekten räknas med `jq` och antalet matchande rader skrivs ut.

### krav 4

Jag utgick redan från början från att ta datum och tid, så det var inget jag lade på i efterhand. Om log-filen hade varit för ett helt år (med ca tre miljoner rader), hade månad och dag blivit mer relevanta i filtreringen...

Python-funktionen som styr time-filtret var först en lite längre funktion på 10 rader, som splittade upp tids-strängarna och jämförde timme, minut och sekund var för sig. Men när jag skulle skriva redovisningstexten, och förklara vad den gjorde insåg jag att jag kunde förenkla den till en rad som kollar om strängarna börjar lika.

En annan sak jag förbättrande var att göra om månad och url till *lower case* redan i `2json.awk`. Då behövde python inte göra det jobbet för varje entry, för att kunna göra en *case insensitive* jämförelse.


### krav 5

Jag valde att bygga webbklienten med Node.js och express. Jag skapade ett skelett med *express application generator*, och valde att testa `pug`, en template engine jag inte använt tidigare. Jag lade till `axios` för att hantera requests mot log-servern. Jag fick modifiera en rad i entrypoint-filen `server.listen(port, '0.0.0.0');` för att tillåta åtkomst via `localhost`.

`models/log_model.js` innehåller klassen `LogModel` som hanterar all kommunikation med log-servern. Filterna kontrolleras även här mot log-serverns `/filters`, men här rensas bara ogiltiga filter bort utan att generera ett fel, och sedan byggs en query-sträng av de giltiga filterna. `axios` parsar automatiskt json-responsen till en array, och det är bara att returnera `response.data`.

I *controllern* `index.js` skalas arrayen med entries ner till max 100 rader, och renderas sedan dynamiskt i en tabell med `pug`. Ett formulär med fem sökfält gör det enkelt att filtrera resultaten, och navigation i botten av sidan tillåter användaren att smidigt visa upp nästa, föregående, eller valfri sida.

Jag försökte få till en stilren och enkel design med god användarvänlighet för både desktop och mobil , och känner mig nöjd med resultatet.

Jag gillade att jobba med `pug`, syntaxen är enkel och lättläst. Style är gjord med ren css i moduler, men med facit i hand hade det varit smidigare att använda `sass`.


### projektet

Jag tycker projektet var kul lättarbetat, och jag tycker inte att jag fastnade vid något särskilt moment. Istället var det mer att jag gick tillbaka och jobbade med att optimera fungerande kod. Det var ett bra och rimligt projekt för kursen.

Jag känner att jag fått en bättre överblick av hur man kan sätta upp och anpassa sin utvecklingsmiljö, och hur det går att kombinera flera olika språk/ramverk på ett smidigt sätt. Dt blir ganska tydligt att bash inte är det bästa språket att bygga applikationer i - det var betydligt enklare att skriva koden till webbklienten än terminalklienten. Men det har ändå varit väldigt nyttigt att lära sig bash, awk, sed, grep med mera, och det kommer kännas bekvämt att använda dem som verktyg och till mindre program framöver. 


### kursen

Kursen har varit rolig, spännande och bra. Jag känner mig mycket mer hemma i linuxmiljön nu, och har fått många nya verktyg att använda framöver. Arbetet med Docker har också breddat förståelsen av vad ett operativsystem innebär, och vilka beroenden som kan behövas för en specifik applikation. Jag har också fått en djupare förståelse för relationen mellan klient och server, och hur man kan jobba med att bygga ett isolerat REST API, som kan nyttjas av olika applikationer samtidigt.

Jag är nöjd med undervisningen och kursmaterialet. Jag skulle rekommendera kursen, och ger den 9 av 10.
