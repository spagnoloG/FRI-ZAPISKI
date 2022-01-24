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
### Kaj so izjeme (prekinitve in pasti)?
### Kako se prožijo prekinitve?
### Kaj je prekinitvena tabela?
### Kako je organizirana prekinitvena tabela pri ARM Cortex M procesorjih?
### Kaj je prekinitveno servisni podprogram (interrupt handler)?
### Kako CPE pridobi naslov PSP?
### Kaj je prekinitveni krmilnik in zakaj ga potrebujemo?
### Opišite delovanje prekinitvenega krmilnika Intel 8259A.
### Kako bi s prekinitvenim krmilnikom 8259A servisirali več kot 8 prekinitvenih zahtev (kanalov)?
### Opišite kaskadno vezavo prekinitvenih krmilnikov 8259A.
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
