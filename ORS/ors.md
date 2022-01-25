# ORS

## Odgovori na commonly postavljena ustna vprasanja pri predmetu ORS

## DRAM
### Kaj je banka v DRAM pomnilnikih? 
### Kaj je polje DRAM? Kako je organizirano?
### Zakaj imamo v polju DRMA celic dolge vrstice?
### Koliko polj DRAM vsebuje ena banka?
### Do katerih DRAM celic v DRAM banki dostopamo istočasno?
### Zakaj v polju DRAM celic vrstice niso dolge toliko kot je dolga ena pomnilniška beseda?
### Zakaj potrebujemo signala CAS# in RAS# ? Zakaja preprosto ne izstavimo naslova pomnilniške besede?
### Kaj sdo časi tRAS, tRDC, tRP, tRCin tCL?
### Kako je definiran čas dosatopa do vrstice tRC?
Vsi tej odgovori so odgovorjeni v tem spisku spodaj

DRAM polje je sestavljeno iz **DRAM celic**. Branje in pisanje v celico poteka preko bitne linije (BL). Stanje se za razliko od SRAM celic ohrani v kondenzatorju (realiziran je z uporabo MOS celic). To naredi DRAM celico zelo uporabno, saj je ravno zaradi kondenzatorja veliko manjsa kot SRAM celica. Ker je kondenzator _nestabilen_ - pocasi izpraznjuje svoj naboj na bitno linijo, ga je potrebno regularno osvezevati. Branje iz DRAM celice je **destruktivno**, tako da vsakemu branju sledi pisanje.
Zaradi fizicnih lastnosti, je bitna linija v bistvu tudi nek kondenzator. Zaradi te lastnosti, pa morajo biti bitne linije nujno **kratke**. Do wordline-a pa dostopa naslovni dekodirnik, kateri da signal, naj kondenzator spusti svoj naboj na bitno linijo.

![dram-cell](./images/dram-cell.png)

DRAM polje, je v bistvu 2D array DRAM celic. Do naslova v DRAM polju dostopamo s parom indeksa vrstice in indeksa stolpca. Tipicna velikost DRAMA danes je 32k vrstic in 1024 stolpcev. Vsak DRAM cip ima lahko od 4-16 DRAM polj, do katerih lahk dostopa hkrati MCU. Mnozici teh polj, do katerih dostopamo recemo **banka**.


<img src="./images/dram-array.png " width="600" height="400"/>

Ker je naslovni prostor vrstic in stolpcev precej velik (32k vrstic), so naslovne linije multiplexirane. Zato za izbiro stolpca in vrstice uvedemo dva nova signala -> CAS(*Column access strobe*) in RAS(*Row access strobe*). Ter uvedemo tudi WE(*write enable*) signal, s katerim izberemo ali bomo pisali al brali. Med branjem nam pride prav tudi OE(*Output enable signal*), s katerim omejimo pretok podatka na bitno linijo, dokler nismo pripravljeni na sprejem podatka. Vsej tej signali so *active low* kar pomeni, da so aktivni, ko je na njih logicna nicla.

<img src="./images/dram-addressing.png " width="600" height="400"/>


### Opišite dostop (bralni ali pisalni) do DRAM banke (časovno zaporedje naslovnih in kontrolnih signalov, časi, ..)
### Branje
Za branje potrebujemo najprej izbrati celico, katero bomo brali z dvema signaloma RAS in CAS. Nato pa ta signal zazna tipalni ojacevalnik in poslje podatke na izhodne pine. Postopek branja:
- Najprej naslovimo vrstico na naslovnih pinih
- Nato se sprozi RAS signal (*active low*), traja z vnaprej dolocenim casom **tRAS**. Ko je aktiven RAS signal, vse celice v vrstici zacnejo spuscati bite na bitno linijo.
- Nato naslovimo se stolpce
- Pred aktivacijo CAS signala je potrebno aktivirati se WE signal (*postavimo ga na visoko*)
- Po predpisanem casu **tRCD** aktiviramo se CAS signal (*active low*), kateri ostane aktiviran **tCAS** casa. *RAS-to-CAS* zakasnitev nam zagoravlja, da se bo podatek pravilno zaznal na tipalnih ojacevalnikih.
- Podatki se pojavijo na izhodnih pinih pomnilniske naprave. Podatki se pojavijo na izhodnih pinih po **tCL** casu.
- Preden lahko recemo da smo uspesno prebrali podatke, moramo se zagotoviti da se deaktivirata RAS in CAS signala. Sele nato se lahko izvede novo branje, po **tRP** (*row precharge*) casu.

En cikel branja traja: **tRC = tRAS + tRP**.

### Pisanje
Za pisanje potrebujemo najprej izbrati celico, katero bomo brali z dvema signaloma RAS in CAS, ter na vhodne pine napisati podatke, katere zelimo pisati. Nato tipalni ojacevalnik napolni oz. izprazne kondenzatorje v izbranih celicah (*odvisno od vhoda, logicna 0 ali 1*)Postopek pisanja:
- Najprej naslovimo vrstico na naslovnih pinih
- Nato se sprozi RAS signal (*active low*), traja z vnaprej dolocenim casom **tRAS**. Ko je aktiven RAS signal, se vrstice odprejo.
- Zdaj se morajo pojaviti podatki na vhodnih pinih.
- Po podatkih moramo se nasloviti stolpce.
- Nato se postavi **WE** na **active low**.
- Po predpisanem casu **tRCD** se vkljuci CAS signal(*active low*) in ostane odprt **tCAS** casa.
- [nism 100%] tle tipalni ojacevalniki zapisejo podatke.
- Preden lahko recemo da smo uspesno prebrali zapisali, moramo se zagotoviti da se deaktivirata RAS in CAS signala. Sele nato se lahko izvede novo branje, po tRP (row precharge) casu.

Cikel pisanja traja ravno toliko casa kakor cikel branja.


### Kako osvežujemo vsebino vsrtice v DRAM banki?
Ker so celice zgrajene iz kondenzatorjev, kateri *leakajo*, jih je potrebno intervalno osvezevati vrstico po vrstico. To se na modernih ram sistemih dogaja na priblizno 64ms. Frekvenca osvezevanja na DRAM modulih je dolocena s pomocjo internega oscilatorja in stevca, kateri indicira katero vrstico je potrebno osveziti.
Za osvezevanje je uporabljena metoda *CAS-before-RAS refresh*. Koraki:
- CAS signal postavimo na nizki signal, WE signal pa ostane v visokem stanju(ekvivalentno branju)
- Po dolocenem delay-u, RAS preklopimo na nizek signal.
- Interni stevec doloci katero vrstico je potrebno osveziti in naslovi dolocene stolpce.
- Po dolocenem delay-u, CAS vrnemo na visok signal.
- Po dolocenem delay-u, RAS vrnemo na visok signal.

### Summary: Importatnt timings in DRAMs
| Name                                | Symbol | Description                                                                                                                                                                   |
|-------------------------------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Row Active Time                     | tRAS   | The minimum amount of time RAS is required to be active (low) to read or write to a memory location.                                                                          |
| CAS latency                         | tCL    | This is the time interval it takes to read the first bit of memory from a DRAM with the correct row already open.                                                             |
| Row Address to Column Address Delay | tRCD   | The minimum time required between activating RAS and activating CAS . It is the time interval between row access and data ready at sense amplifiers.                          |
| Random Access Time                  | tRAC   | This is the time required to read any random memory cell. It is the time to read the first bit of memory from an DRAM without an active row. tRAC = tRCD + tCL.               |
| Row Precharge Time                  | tRP    | After a successful data retrieval from the memory, the row that was used to access the data needs to be closed. This is the minimum amount of time that RAS must be inactive. |
| Row Cycle Time                      | tRC    | This is the time associated with single rad or write cycle. tRC = tRAS + tRP                                                                                                  |

This table is taken from ors book.
### Kako izboljšamo odzivnost DRAM pomnilnikov? Kaj je Fast Page Mode DRAM? Kaj pa EDO DRAM?
Fast page mode DRAM - eliminira potrebo po ponovnem naslavljanju vrstice, ce je ze bila odprta v predhodnjem branju, tako potrebujemo nasloviti samo dolocene stolpce --> eliminiramo RAS signal in lahko na hitro preberemo se ostale sosednje stolpce. Vrstico osvezimo, sele ko zelimo brati neke podatke, ki niso v isti vrstici(do tedaj so vrednosti shranjene v SRAM celicah na koncu tipalnih ojacevalnikov).

EDO RAM - Dovoljuje, da podatki ostanejo na izhodnih pinih, brez cakanja, da se tej podatki najprej preberejo, tako se lahko prej izvede naslednji cikel.

### Opišite dostop (pisalni ali bralni) do banke v SDRAM pomnilniku? 
### Kakšne izboljšave prinaša SDRAM?
Vse operacije (odpiranje vrstice, naslavljanje stolpca, zapiranje vrstice) so sinhronizirane z interno uro. Basically en koncni avtomat, ki prozi te signale na dolocene urine fronte. Bank je pri SDRAMIh vec (2-16), kar nam omogoca prepletanje bank, npr. med tem ko iz ene banke beremo, lahko zraven eno drugo banko osvezujemo. Ali pa ko dostopamo v eni banki do vrstice `i` in do stolpca `j` lahko v drugi banki ta cas odprem vstico `i` in stolpec `j+1`.
Dodana sta tudi dva nova registra, data input register in data output register, v katerih lahko zacasno shranimo prebrane oz. tiste bite, ki jih zelimo zapisati v SDRAM.
Cevovodenje READ/WRITE/PRECHARGE ukazov.

### Kaj so ukazi pri SDRAM-ih?
Potek izvajanja ukazov v SDRAM:
- ACTIVE + naslov vrstice na A vodilo + naslov banke (odpiranje vrstice) </br>
  CS-0,
  WE-1,
  CAS-1,
  RAS-0
- READ + naslov stolpca + naslov banke (beri  stolpec)</br>
  CS-0,
  WE-1,
  CAS-0,
  RAS-1
- PRECHARGE + naslov vrstice + naslov banke (osvezi vrstico)
- WRITE (pisi stolpec)

#### Summary: Importatn timings in SDRAMs
| Name                                | Symbol | Description                                                                                                                                                                                                                                                                                                                                      |
|-------------------------------------|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| CAS latency                         | CL     | The number of cycles between sending a column address to the memory and the beginning of the data in response to a READ command. This is the number of cycles it takes to read the first bit of memory from a DRAM with the correct row already open. CL is an exact number that must be agreed on between the memory controller and the memory. |
| Row Address to Column Address Delay | tRCD   | The minimum number of clock cycles required between opening a row and issuing a READ/WRITE command. The time to read the first bit of memory from an SDRAM without an active row is tRCD+ CL.                                                                                                                                                    |
| Row Precharge Time                  | tRP    | precharge command and opening the next row. The time to read the first bit of memory from an SDRAM with the wrong row open is tRP+ tRCD + CL.                                                                                                                                                                                                    |
| Row Active Time                     | tRAS   | The minimum number of clock cycles required between a row active command and issuing the precharge command. This is the time needed to internally refresh the row, and overlaps with tRCD . In SDRAM modules, it is usually tRCD+ CL.                                                                                                            |

This table is taken from ors book.

### Kaj je eksplozijski prenos?  
Velika novost v SDRAM-ih je tudi **BURST** ali **eksplozijski** prenos. - Z enim samim READ ukazom in enim samim naslovom stolpca, nam SDRAM vrne 2-8 stolpcev, tako da v vsaki urini periodi zapise enega v izhodni register.

Ker so vse interne operacije po novem reazlizirane s pomocjo koncnega avtomata, signali RAS, CAS, WE, CS niso direktno povezani na interno logiko DRAMA (zdaj so tam kot ukazno vodilo za koncni avtomat) - izgubili so pomeni, katerega so imeli pri DRAM-ih.


<img src="./images/sdram-commands.png " width="800" height="350"/>


### Kaj je CAS latenca pri SDRAM-ih? Kako je pri SDRAM-ih definirana (določena)? 
### Kakšne so tipične vrednosti časov tRCD, tCL (CAS latency), tRP pri modernih SDRAM-ih? Ali jih lahko tehnološko skrajšamo in kako?
med 13,5ns in 18ns, ne moremo jih tehnolosko skrajsati, saj bi tako potrebovali dodatno zmanjšati celice, kar fizično ni možno.
### Kaj je DDR? Kaj je 2n-prefetch? 
SDRAM-e lahko še dodatno pohitrimo tako, da bi z enim READ/WRITE ukazom namesto ene
pomnilniške besede prenesli dve zaporedni.
### Kakšna je razlika med eksplozijskim prenosom in 2n-prefetchom? Ali lahko uporabomo oboje?
The downside of the 2N-prefetch architecture means that short column bursts are
no longer possible. In DDR SDRAM devices, a minimum burst length of 2 columns
of data is accessed per column read command.
### Ali pri DDR(2,3,4) lahko opravimo eksplozijski dostop dolžine 1? 
### Opišite kako pohitrimo dostope pri DDR(2,3,4) v primerjavi s SDRAM-i?
### Kako se pri SDRAM-ih mapirajo naslovi iz CPE v naslove vrstice, stolpca, banke?
### Kaj je DIMM modul?
### Kaj je rank?
### Do koliko podatkov naenkrat dostopamo pri DDR(2,3,4) DIMM modulu?
### Kajh pomeniji čai podani kot npr. 9-9-9 pri DIMM modulih?
### Kaj pomeni PC4-19200 pri DDR4 DIMM modulih? 
### Kako je določena frkevnca ure na vodilu za DDR(2,3,4)?
### Kaj so kanali? Koliko kanalov podpirajo sodobni procesorji in njihovi pomnilniški krmilniki?
### Kako so kanali označeni na matičnih ploščah? 
### Predpostavite, da imate dva enaka DIMM modula? Kako jih boste vstavili v sockete na matični plošči? Zakaj?

## PREKINITVE

### Kaj so izjeme (prekinitve in pasti)?
Prekinitve so mehanizem s katerim zunanja naprava zahteva pozornost procesorja. Izvajanje trenutno izvajajočega programa se prekine in se prične izvajati prekinitveno servisni podprogram. Pasti so prekinitve ki jih aktivira sama CPE, pogosto kot rezultat ilegalne / napačne instrukcije, ali ko CPE poskusi izvesti ukaz katerega ni mogoče pridobiti (*fetch-ati*).
### Kako se prožijo prekinitve?
Prekinitve se prožijo tako da naprava aktivira (nastavi napetost na vodilu na HIGH ali LOW odvisno od sistema) **IRQ** (*Interrupt Request*) vodilo, ter čaka na odgovor procesorja. Procesor preveri stanje IRQ pina/pinov vsakič preden se iz pomnilnika dobi novi ukaz, na katerega kaže programski števec. Če je IRQ vodilo aktivno, potem procesor začne z izvajanjem **Prekinitvenega servisnega podprograma** (*Interrupt Service Program*), ki se nahaja na nekem stalnem naslovu v pomnilniku. Procesor prvo izvede še vse ukaze v cevovodu, ki spreminjajo kontekst izvajajočega programa (registri, pomnilnik in zastavice), ter shrani na sklad vse pomembne registre (PC, SP, LR). CPE potem lahko sporoči potem **INTA** (*Interrupt acknowledge*) da je videl prekinitev in da naprava lahko umakne/deaktivira IRQ.
### Kaj je prekinitvena tabela?
Prekinitvnena (vektorska) tabela je seznam naslovov prekinitvenega servisnega programa za vsako od I/O naprav ki so povezane z CPE. Tabela je dolga toliko besed koliko je možno naprav povezati na CPE.
### Kako je organizirana prekinitvena tabela pri ARM Cortex M procesorjih?
ARM Cortex M / ARM9 procesorji uporabljajo vektorsko tabelo, pri kateri vsaki zapis je dolg 32 bitov, kar ni dovolj da bi vsebovalo celotno kodo PSP-ja, vendar običajno vsebuje kazalec na pomnilniški naslov kjer je začetek PSP-a. Osnovna prekinitvena tabela vsebuje vektore *Reset, Undefined Instruction, Software Interrupt, Prefetch Abort, Data Abort, Interrupt Request* in *Fast Interrupt Request*. Tam so tudi shranjene prioritete posameznih prekinitev, v osnovni tabeli ima *Reset* najvišjo prioriteto (1),  *Undefined Instruction* in *Undefined Instruction* pa imata najnižjo (6).
### Kaj je prekinitveno servisni podprogram (interrupt handler)?
Prekinitveno servisni podprogram je program, ki CPE začne izvajati kot odgovor na prekinitveno zahtevo I/O naprave.
### Kako CPE pridobi naslov PSP?
Če imamo samo eno I/O napravo, je izbran en fiksen naslov za PSP, ter na temu mestu hranimo naslov začetka PSP-ja. Če imamo več naprav, uporabljamo prekinitveno tabelo. Pri ARM CPE, vsaka naprava ima svoj IRQ pin, ter v pomnilniku se napravi dodeli ena ena pomnilniška beseda na fiksnem naslovu, ki hrani naslov PSP-ja za napravo. Intel/x86 CPE pričakuje da mu naprava ki prekinja sporoči številko prekinitvenega vektorja `[0, 255]`, ki se uporablja kot indeks v tabeli prekinitvenih vektorjev. Indeksi `[0, 31]` so rezervirane za prekinitve in pasti iz CPE, ostale pa se dodeljujejo V/I napravam.
### Kaj je prekinitveni krmilnik in zakaj ga potrebujemo?
Prekinitveni krmilnik je naprava ki združi vse zunanje zahteve za prekinitve v eno CPE IRQ vodilo, ter jim določi prioriteto (v katerem vrstnem redu jih bo CPE obravnaval), usmerja zahteve CPE-i, ter informira CPE o temu katera naprava zahteva prekinitev in prekinitveni vektor naprave, na taksen nacin CPE ne potrebuje *poll*-ati I/O naprave.
### Opišite delovanje prekinitvenega krmilnika Intel 8259A.
Intel PIC8259A deluje tako da I/O naprava aktivira pripadajoči IR vhod na krmilniku. Če več naprav naenkrat zahtevajo prekinitev, PIC8259A izbere tisto zahtevo z najvišjo prioriteto (IR0 = največja, IR7 = najmanjša), ter aktivira IRQ na vodilu CPE. Ko CPE zazna aktiven IRQ, dokonča z izvajanjem ukazov v cevovodu, ter shrani kontekst. PIC medtem iz **IRR** (*Internal Request Register*) prepiše najbolj desno enico v **ISR** (*In-Service Register*) in je hkrati pobriše iz IRR. 

CPE z aktiviranjem INTA signala v trajanju 2 urinih period sporoči PIC-u da je videla zahtevo. PIC interno pripravi številko prekinitvenega vektorja, ter po drugem INTA pulsu CPE-a, PIC na podatkovno vodilo postavi številko prekinitvenega vektorja: OFFSET (zgornjih 5b - če je samo en PIC uporabljamo offset `00100` <-> `32`) ter mesto enice v ISR (spodnjih 3b).
![PIC8259A](./images/pic8259a.png)
### Kako bi s prekinitvenim krmilnikom 8259A servisirali več kot 8 prekinitvenih zahtev (kanalov)?
S PIC8259A lahko servisiramo več kot 8 prekinitvenih zahtev z uporabo **kaskadne povezave PIC-ov**, kjer imamo en *master* PIC, ter do 8 *slave* PIC-ov. Ponavadi so računalniki uporabljali samo 2 PIC-a: en master in en slave.
![PIC8259A kaskada](./images/pic8259a-cascade.png)
### Opišite kaskadno vezavo prekinitvenih krmilnikov 8259A.
PIC8259A dopušča kaskadno povezovanje, ter se ponavadi uporabljalo 2 PIC-a: en master in en slave. Offseti posameznih PIC-ov so bili programibilni in so se vpisovali ob init-u. Master PIC ima offset `00100`, in pokriva IRQ zahteve I/O naprav med indeksi `32` in `39`. Slave PIC ima pa offset `00101`, in pokriva naprave med `40` in `47`. IRQ/INT slave-a se ponavadi vezuje na IR2 master PIC-a. Takrat ko naprava na slave PIC-u aktivira IRQ, preko master PIC-a to potem posreduje CPE. INTA od CPE vidita tudi master in slave PIC, vendar master PIC to ignorira ker je naslovljeno na `00100010` - slave PIC. Slave PIC gre skozi vse faze navadnega PIC-a in po drugemu INTA od CPE na vodilo postavi številko prekinitvenega vektorja, z offsetom `00101`. 
### Kaj je osnova ideja pri APIC? 

### Opišite vlogo LAPIC in IO APIC?
### Kaj je APIC vodilo? Čemu je namenjeno?
### Opišite delovanje IO APIC krmilnika.
### Kaj ej to preusmeritvena tabela v IO APIC (redirection table)? 
### Kaj so to PCI prekinitve? Kako si PCI naprave delijo prekinitvene signale?
### Kam se vežejo PCI prekinitveni signali PIRQA - PIRQD na IO APIC?
### Kako je pametno povezati INTA-INTD signale med posameznimi PCI napravami? 
### Predpostavite, da v sistem želite vstaviti neko PCI kaertico. Kako boste izbrali na katerem vhodu (PIRQA-PIRQD) bo prožila prekinitve?
### Kaj so to MSI prekinitve?
### Zakaj potrebujemo DMA krmilnike? Kako bi bilo brez njih?
### Kakšna je razlika med fly-by in fly through DMA krmilnik? Navedite dva realna primera.
### Opišite delovanje 8237A DMA krmilnika.
### Opišite delovanje DMA krmilnika v sistemih STM32F4.
### Kaj je DMA kanal?
### Na koga se nanaša naslov, ki ga izstavi fly-by DMA krmilnik?
### Predpostavite, da želite iz V/I naprave prenašati v pomnilnik. Opištite DMA prenos ter vse sodelujoče signale za 8237A.
### Kakšna razlika je med tokom (stream) in kanalom pri DMA krmilniku v STM32F'.
### Opišite inicializacijo DMA krmilnika. Kaj je vse treba nastaviti pred začetkom prenosa?
### Kako DMA krmilnik obvesti CPE, da je prenos zaključen?
### Kaj je to bus mastering?
### Kaj je to navidezni pomnilnik? Zakaj ga imamo?
### Kaj je stran in kaj je okvir?
### Kako velika naj bo stran?
### Kaj je napaka strani?
### Kaj je deskriptor strani?
### Kaj vsebuje tabela strani?
### Opišite večnivojsko ostranjevanje?
### Najmanj koliko tabel strani moramo hraniti v pomnilniku pri 2(3,4, ..)-nivojskem ostranjevanju?
### Kako pohitrimo preslikovanje navideznih naslovov?
### Kaj je TLB? Kako je organiziran? Kako je velik?
### Zakaj zadošča tako mali TLB? Na kaj se zanašamo?
### Kako preslikujemo naslove v prisotnosti predpomnilnika?
### Zakaj ni dobro, da v predpomnilnik gremo z navideznim naslovom? Zakaj pa bi bilo to dobro?
### Kako sme biti velika stran ob prisotnosti predpomnilnika? Zakaj?

## Summaries taken from ors book


>A SRAM cell uses a bistable element to store one bit of information. It is
made up of a bistable and two access nMOS transistors that serve as a switch
used to control the state of the bistable element during the read and write
operations.
Due to the ability to store the information indefinitely and the high speed of
SRAM cells, they are used to implement caches and registers in micropro
cessors. 

>Dynamic Random Access Memory (DRAM) is the main memory used for
all computers. DRAMs store their contents as a charge on a capacitor. A
DRAM cell consists only of a storage capacitor and a single nMOS transis
tor that acts as a switch between the storage capacitor and the bit line.
Reading from a DRAM cell is a destructive operation. Besides, the charge
on the capacitor leaks away through switched off transistor in tens to hun
dreds of milliseconds. Thus DRAMs should be regularly refreshed.
A sense amplifier is a special circuit used to detect the tiny voltage swing on
the bit line and read the data. The sense amplifier is also used to write back
the bit value to the storage cell. This operation is referred to as precharge. 

>DRAM is arranged in a rectangular memory array of storage cells organized
into rows and columns.
The cells of a DRAM are accessed by a row address and a column address.
A bank is a set of N memory arrays accessed simultaneously, forming an
N-bit width column. Usually, there are 4, 8, or 16 DRAM arrays in a bank.


>DRAM chips contain at least one memory bank. The row address decoder
is used to activate the appropriate word line from the given row address. The
column selector is used to select the proper column from the given column
address.
As the number of address bits required to select rows and columns can be
quite large, the address lines are multiplexed. To indicate which of two ad-
dresses is currently on the bus, we need two additional control signals: the
row access strobe (RAS) and the column access strobe (CAS).
The write enable (WE) signal is used to choose a read or a write operation.
During a read operation, the output enable (OE) signal is used to prevent
data from appearing at the output until needed.

>DRAMs are asynchronous systems, responding to input signals whenever
they occur. The DRAM will work properly, as long as the input signals are
applied in the proper sequence, with signal durations and delays between
signals that meet the specified limits.
Typical operations in DRAMs are: read, write, and refresh. All these operations are initiated and controlled by the prescribed sequence of input signals.
The read and write accesses last for a row cycle time (tRC ):
tRC = tRAS + tRP .
DRAMs must be refreshed in order to prevent the loss of data. DRAMs are
refreshed one row at a time. DRAMs use an internal oscillator to determine
the refresh frequency and initiate a refresh and a counter to keep track of row
to be refreshed. Such an auto-initiated refresh is referred to as self refresh.
Self-refresh uses the so-called CAS-before-RAS sequence.

> Due to temporal and spatial locality, we often access two or more consecu-
tive columns from the same row.
All methods used to improve the performance of a DRAM chip and to de-
crease the access time rely on the ability to access all of the data stored in a
row without having to initiate a completely new memory cycle.
Fast Page Mode DRAM eliminates the need for a row address if data is
located in the row previously accessed.
In EDO DRAMs, data is still present on the output pins, while CAS is chang-
ing, and a new column address is latched. This allows a certain amount of
overlap in operation (pipelining), resulting in faster access time.

> SDRAM devices have a synchronous device interface, where commands,
instead of signals, are used to control internal latches.
In SDRAM devices, signals CAS, RAS, WE and CS form a command bus
used to transmit commands to the internal state machine.
SDRAM devices contain multiple independent banks.
SDRAMs can transfer many columns over several cycles per request without
sending any new addresses. This type of transfer is referred to as burst mode.
