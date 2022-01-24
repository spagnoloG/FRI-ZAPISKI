# ORS

## Odgovori na commonly postavljena ustna vprasanja pri predmetu ORS
![Ram](./images/ram.jpg)

### Kaj je banka v DRAM pomnilnikih? 
### Kaj je polje DRAM? Kako je organizirano?
### Zakaj imamo v polju DRMA celic dolge vrstice?
### Koliko polj DRAM vsebuje ena banka?
### Do katerih DRAM celic v DRAM banki dostopamo istočasno?
### Kako osvežujemo vsebino vsrtice v DRAM banki?
DRAM polje je sestavljeno iz **DRAM celic**. Branje in pisanje v celico poteka preko bitne linije (BL). Stanje se za razliko od SRAM celic ohrani v kondenzatorju (realiziran je z uporabo MOS celic). To naredi DRAM celico zelo uporabno, saj je ravno zaradi kondenzatorja veliko manjsa kot SRAM celica. Ker je kondenzator _nestabilen_ - pocasi izpraznjuje svoj naboj na bitno linijo, ga je potrebno regularno osvezevati. Branje iz DRAM celice je **destruktivno**, tako da vsakemu branju sledi pisanje.
Zaradi fizicnih lastnosti, je bitna linija v bistvu tudi nek kondenzator. Zaradi te lastnosti, pa morajo biti bitne linije nujno **kratke**. Do wordline-a pa dostopa naslovni dekodirnik, kateri da signal, naj kondenzator spusti svoj naboj na bitno linijo. 

![dram-cell](./images/dram-cell.png)

DRAM polje, je v bistvu 2D array DRAM celic. Do naslova v DRAM polju dostopamo s parom indeksa vrstice in indeksa stolpca. Tipicna velikost DRAMA danes je 32k vrstic in 1024 stolpcev. Vsak DRAM cip ima lahko od 4-16 DRAM polj, do katerih lahk dostopa hkrati MCU. Mnozici teh polj, do katerih dostopamo recemo **banka**.

<img src="./images/dram-array.png " width="600" height="400"/>
### Zakaj v polju DRAM celic vrstice niso dolge toliko kot je dolga ena pomnilniška beseda?
### Zakaj potrebujemo signala CAS# in RAS# ? Zakaja preprosto ne izstavimo naslova pomnilniške besede?
### Opišite dostop (bralni ali pisalni) do DRAM banke (časovno zaporedje naslovnih in kontrolnih signalov, časi, ..)
### Kaj sdo časi tRAS, tRDC, tRP, tRCin tCL?
### Kako je definiran čas dosatopa do vrstice tRC?
### Kako izboljšamo odzivnost DRAM pomnilnikov? Kaj je Fast Page Mode DRAM? Kaj pa EDO DRAM?
### Kakšne izboljšave prinaša SDRAM?
### Kaj je CAS latenca pri SDRAM-ih? Kako je pri SDRAM-ih definirana (določena)? 
### Kakšne so tipične vrednosti časov tRCD, tCL (CAS latency), tRP pri modernih SDRAM-ih? Ali jih lahko tehnološko skrajšamo in kako?
### Kaj je DDR? Kaj je 2n-prefetch? 
### Kaj so ukazi pri SDRAM-ih?
### Opišite dostop (pisalni ali bralni) do banke v SDRAM pomnilniku? 
### Kaj je eksplozijski prenos?  
### Kakšna je razlika med eksplozijskim prenosom in 2n-prefetchom? Ali lahko uporabomo oboje?
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
Prekinitve so mehanizem s katerim zunanja naprava zahteva pozornost procesorja. Izvajanje trenutno izvajajočega programa se prekine in se prične izvajati prekinitveno servisni podprogram. Pasti so prekinitve ki jih aktivira sama CPE, pogosto kot rezultat ilegalne / napačne instrukcije, ali kdaj CPE poskusi izvesti ukaz ki ni mogoče pridobiti (*fetch-ati*).
### Kako se prožijo prekinitve?
Prekinitve se prožijo tako da naprava aktivira (nastavi napetost na vodilu na HIGH ali LOW odvisno od sistema) **IRQ** (*Interrupt Request*) vodilo, ter čaka na odgovor procesorja. Procesor preveri stanje IRQ pina/pinov vsakič preden se iz pomnilnika dobi novi ukaz, na katerega kaže programski števec. Če je IRQ vodilo aktivno, potem procesor začne z izvajanjem **Prekinitvenog servisnega podprograma** (*Interrupt Service Program*), ki se nahaja na nekem stalnem naslovu v pomnilniku. Procesor prvo izvede še vse ukaze v cevovodu, ki spreminjajo kontekst izvajajočega programa (registri, pomnilnik in zastavice), ter shrani na sklad vse pomembne registre (PC, SP, LR). CPE potem lahko sporoči potem **INTA** (*Interrupt acknowledge*) da je videl prekinitev in da naprava lahko umakne/deaktivira IRQ.
### Kaj je prekinitvena tabela?
Prekinitvnena (vektorska) tabela je seznam naslovov prekinitvenega servisnega programa za vsako od I/O naprav ki so povezane z CPE. Tabela je dolga toliko besed koliko je možno naprav povezati na CPE.
### Kako je organizirana prekinitvena tabela pri ARM Cortex M procesorjih?
ARM Cortex M / ARM9 procesorji uporabljajo vektorsko tabelo, pri kateri vsaki zapis je dolg 32 bita, kar ni dovolj da bi vsebovalo celotno kodo PSP-ja, vendar običajno vsebuje kazalec na pomnilniški naslov kjer je začetek PSP-a. Osnovna prekinitvena tabela vsebuje vektore *Reset, Undefined Instruction, Software Interrupt, Prefetch Abort, Data Abort, Interrupt Request* in *Fast Interrupt Request*. Tudi so shranjene prioritete posameznih prekinitvi, kje v osnovni tabeli *Reset* ima najvišjo prioriteto (1), ter *Undefined Instruction* in *Undefined Instruction* imata najnižjo (6).
### Kaj je prekinitveno servisni podprogram (interrupt handler)?
Prekinitveno servisni podprogram je program, ki CPE začne izvajati kot odgovor na prekinitveno zahtevo I/O naprave.
### Kako CPE pridobi naslov PSP?
Če imamo samo eno I/O napravo, je izbran en fiksen naslov za PSP, ter na temu mestu hranimo naslov začetka PSP-ja. Če imamo več naprav, uporabljamo prekinitveno tabelo. Pri ARM CPE, vsaka naprava ima svoj IRQ pin, ter v pomnilniku se napravi dodeli ena ena pomnilniška beseda na fiksnem naslovu, ki hrani naslov PSP-ja za napravo. Intel/x86 CPE pričakuje da mu naprava ki prekinja sporoči številko prekinitvenega vektorja `[0, 255]`, ki se uporablja kot indeks v tabeli prekinitvenih vektorjev. Indeksi `[0, 31]` so rezervirane za prekinitve in pasti iz CPE, ostale pa se dodeljujejo V/I napravam.
### Kaj je prekinitveni krmilnik in zakaj ga potrebujemo?
Prekinitveni krmilnik je naprava ki združi vse zunanje zahteve za prekinitve v eno CPE IRQ vodilo, ter jim določi prioriteto (v katerem vrstnem redu bo se CPE obravnaval z njimi), usmerja zahteve CPE-i, ter informira CPE o temu katera naprava zahteva prekinitev in prekinitveni vektor naprave, kako CPE ne rabi *poll*-ati I/O naprave.
### Opišite delovanje prekinitvenega krmilnika Intel 8259A.
Intel PIC8259A deluje tako da I/O naprava aktivira pripadajoči IR vhod na krmilniku. Če več naprav naenkrat zahtevajo prekinitev, PIC8259A izbere tisto zahtevo z najvišjo prioriteto (IR0 = največja, IR7 = najmanjša), ter aktivira IRQ na vodilu CPE. CPE ko vidi aktiven IRQ, dokonča z izvajanjem ukazov v cevovodu, ter shrani kontekst. PIC medtem iz **IRR** (*Internal Request Register*) prepiše najbolj desno enico v **ISR** (*In-Service Register*) in je hkrati pobriše iz IRR. 

CPE aktiviranjem INTA v trajanju 2 urini periodi sporoči PIC-u da je videla zahtevo. PIC interno pripravi številko prekinitvenega vektorja, ter po drugem INTA pulsu CPE-a, PIC na podatkovno vodilo postavi številko prekinitvenega vektorja: OFFSET (zgornjih 5b - če je samo en PIC uporabljamo offset `00100` <-> `32`) ter mesto enice v ISR (spodnjih 3b).
![PIC8259A](./images/pic8259a.png)
### Kako bi s prekinitvenim krmilnikom 8259A servisirali več kot 8 prekinitvenih zahtev (kanalov)?
S PIC8259A lahko servisiramo več kot 8 prekinitvenih zahtev z uporabo **kaskadne povezave PIC-ov**, kjer imamo en *master* PIC, ter do 8 *slave* PIC-ov. Ponavadi so računalniki uporabljali samo 2 PIC-a: en master in en slave.
![PIC8259A kaskada](./images/pic8259a-cascade.png)
### Opišite kaskadno vezavo prekinitvenih krmilnikov 8259A.
PIC8259A dopušča kaskadno povezovanje, ter se ponavadi uporabljalo 2 PIC-a: en master in en slave. Offseti posameznih PIC-ov so bili programibilni, ter so se upisovali pri init-u. Master PIC ima offset `00100`, ter je pokrival IRQ zahteve I/O naprav med indeksima `32` in `39`. Slave PIC ima pa offset `00101`, in pokriva naprave med `40` in `47`. IRQ/INT slave-a se ponavadi vezuje na IR2 master PIC-a. Takrat ko naprava na slave PIC-u aktivira IRQ, ter potem master PIC-a to posreduje CPE. INTA od CPE vidita tudi master in slave PIC, vendar master PIC to ignorira ker je naslovljeno na `00100010` - slave PIC. Slave PIC gre skozi vse faze navadnega PIC-a in po drugemu INTA od CPE na vodilo postavi številko prekinitvenega vektorja, z offsetom `00101`. 
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
