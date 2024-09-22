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

<h2 id="kmom06">kmom06</h2>

<h2 id="kmom10">kmom10</h2>