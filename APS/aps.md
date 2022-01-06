# APS

## REKURZIJA
Zahteva vec rezije kot iteracija in je pomnilnisko bol zahtevna od iteracije(sklici se shranijo na stacku). Globina rekurzije = potrebna velikost sklada.
Rekurzivne probleme lahko resujemoo tudi z iteracijami:
- vsako repno rekurzijo lahko zamenjamo z iterativno zanko
- vsak rekurzivni program lahko spremenimo v iterativnega s skladom

### PRETVORBA REKURZIJE V ITERACIJO S SKLADOM
Definicija skladovnega elementa:
```java
class StackElementType {
  Argument type args; // vrednosti argumentov, bodisi za zacetek rekurzivnega klica, bodisi za povraztek iz rekurzivnega klica
  LocalVarsType locals; // vrednosti lokalnih spremenljivk za povratek iz rekurzivnega klica
  int address; // vrednosti med 0 in RECCALS (st. rekurzivnih klicev)
}
```
Pretvorba rekurzije v iteracijo
```java
public void iterative(ArgumentType args0) {
  LocalVarsType locals0;
  Stack st = new StackArray();
  StactElementType e;

  st.makenull();
  e.args = args0; // samo argumenti, lokalne spremenljivke se niso definirane
  e.address = 0;

  st.push(e); // dodaj v sklad prvi element

  do {
    e = st.top(); // poberi najvisji element iz sklada
    st.pop(); // pobrisi ga iz sklada
    args0 = e.args; // pripravi vrednosti..
    locals0 = e.locals // ..lokalnih spremenljivk

    switch(e.address) {
      // izvedi del algoritma za dani naslov
    }
  } while(!st.empty);

}
```
## ANALIZA CASOVNE KOMPLEKSNOSTI

#### Racunanje z O(n)
- eliminacija konstante:
`c > 0 --> O(c * f(n)) = O(f(n))`
- vsota:
`O(f(n)) + O(g(n)) = O(max(f(n), g(n))) // sepravi pri vsoti izberemo tisto, ki ima visjo casovno kompleksnost`
- prevladujoca funkcija:
`Ce je za vsak n: f(n) > g(n) --> O(f(n)) + O(g(n)) = O(f(n))`
- produkt:
`O(f(n)) * O(g(n)) = O(f(n) * g(n))`
- tranzitivnost:
`f(n) = O(g(n)), g(n) = O(h(n)) --> f(n) = O(h(n))`
- refleksivnost
`f(n) = O(f(n))`
#### Dolocitev parametrov kompleksnosti
- Osnovne operacije: O(1) // e.g. int a = 10;
- pri zaporedju ukazov **sestevamo** zahtevnosti
- pri pogojih stejemo kompleksnost **izracuna** pogoja in **max** vseh moznih izbir
- pri zankah sestejemo kompleksnost izracuna pofoja in enkratne izvedbe zanke ter pomnozimo s stevilom izvajanja zanke
- pri rekurziji pa zahtevnost izrazimo kot rekurencno enacbo
--> primer izracuna rekurencne Enacbe
```java
void p(int n, int m) {
  if(m > 0)
    for(int i = 1; i <= n; i++)
      p(n, m-1);
}
// najprej izracunamo robni pogoj
// T(n, 0) = O(1)
// pole pa se rekurencno enacbo
// T(n, m) = O(1 + n(1+1+1+T(n, m -1))) = O(n * T(n, m -1)) = O(n*n*T(n, m-2)) = O(n^m)
```
--> se en primer
```java
void hanoi(char A, char B, char C, int n) {
  if(n > 0) {
      hanoi(A,B,C, n-1);
      System.out.println("hh"); // 2 znaka sepravi O(2)
      hanoi(A,B,C, n-1);
  }
}
// T(0) = O(1)
// T(n) = 1 + T(n-1) + 2 + T(n-1) = 2T(n-1) = 2*2*T(n-2) = O(2^n)
// pazi, isto velja ce mas T(n-1)+T(n-2) = O(2^n)
// PAZI 2, vedno mors T(0) * T(n) = O(n) -- > ker lahko T(0) != O(1)
```
### OCENA DEJANSKEGA CASA IZVAJANJA
  `T(n) = a * O(g(n)) + c`

Postopek:
- najprej izracunas `a` in `c`, tako da izberes tisto matematicno funkcijo`g(n)`, katera se ti zdi najbolj primerna in v njo ustavis `n` pa enacis s casom izvajanja
- ko imas `a` in `c`, izracunas `T(n)` s pomocjo dobljenega `a`-ja in `c`-ja pa matematicne funkcije `g(n)`. Ce se cas ujema --> success :)

## ADT ENOSMERNI SEZNAM S KAZALCI

#### Implementacija
```java
class LinkedListNode {
  Object element;
  LinkedListNode next;
  ...
}
public class LinkedList{
  protected LinkedListNode first, last;
  ...
}
```
Polozaj kazalcev je v enosmernem seznamu zamaknjen
```
(first)[header| next] -> [a1|next] -> ... -> (last)[a_n-1| next] -> [a_n | next] -> null
```

#### Operacije in casovne zahtevnosti
- MAKENULL(L) ~ naredi prazen seznam `O(1)`
- FIRST(L) ~ vrne polozaj prvega elementa v seznamu `O(1)`
- LAST(L) ~ vrne polozaj zadnjega elementa v seznamu `O(1)`
- NEXT(p, L) ~ vrne naslednji polozaj polozaja p `O(1)`
- PREVIOUS(p, L) ~ vrne predhodni polozaj `O(n)`
- RETRIEVE(p, L) ~ vrne element a_p na polozaju p  `O(1)`
- INSERT(x, p, L) ~ vstavi element x na polozaj p `O(1)`
- INSERT(x, L) ~ vstavi element x na poljuben polozaj (konc al zacetk)  `O(1)`
- DELETE(p, L) ~ zbrise element a_p na polozaju p `O(1) - O(n)` -> ce brisemo zadnjega, moremo it skoz ceu seznam, da nastavimo pointer last, v nasprotnem je O(1), ker imampo pac zamaknjen polozaj elementov, in imamo ze takoj podan element `prev`
- EMPTY(L) ~ preveri ce je seznam prazen `O(1)`
- END(L) ~ vrne polozaj, ki sledi zadnjemu elementu seznama `O(1)`
- OVEREND(p, L) ~ preveri ce je p = END(L) `O(1)`
- LOCATE(x, L) ~ poisce polozaj elementa x v seznamu `O(n)`
- PRINTLIST(L) ~ po vrsti izpise vse elemente v seznamu `O(n)`


## ADT DVOSMERNI SEZNAM S KAZALCI
Glavni + dvosmernega seznama s kazalci je **ucinkovito** iskanje predhodnika v seznamu -> O(1). Polozaj kazalcev v dvosmernem seznamu ne potrebuje biti zamaknjen.
#### Implementacija
```java
class LinkedListNode {
  Object element;
  LinkedListNode next, prev;
  ...
}
public class LinkedList{
  protected LinkedListNode first, last;
  ...
}
```

#### Operacije in casovne zahtevnosti
- MAKENULL(L) ~ naredi prazen seznam `O(1)`
- FIRST(L) ~ vrne polozaj prvega elementa v seznamu `O(1)`
- LAST(L) ~ vrne polozaj zadnjega elementa v seznamu `O(1)`
- NEXT(p, L) ~ vrne naslednji polozaj polozaja p `O(1)`
- PREVIOUS(p, L) ~ vrne predhodni polozaj `O(1)` --> izboljsava proti ENOSMERNEMU
- RETRIEVE(p, L) ~ vrne element a_p na polozaju p  `O(1)`
- INSERT(x, p, L) ~ vstavi element x na polozaj p `O(1)`
- INSERT(x, L) ~ vstavi element x na poljuben polozaj (konc al zacetk)  `O(1)` --> izboljsava proti ENOSMERNEMU
- DELETE(p, L) ~ zbrise element a_p na polozaju p `O(1)`
- EMPTY(L) ~ preveri ce je seznam prazen `O(1)`
- END(L) ~ vrne polozaj, ki sledi zadnjemu elementu seznama `O(1)`
- OVEREND(p, L) ~ preveri ce je p = END(L) `O(1)`
- LOCATE(x, L) ~ poisce polozaj elementa x v seznamu `O(n)`
- PRINTLIST(L) ~ po vrsti izpise vse elemente v seznamu `O(n)`

## ADT SEZNAM S POLJEM
Polozaj elementa v seznamu je podan z indeksom polja. Potrebujemo se indeks zadnjega elementa v polju. Imamo omejeno dozlino seznama in ves cas zaseda **maximalno** kolicino pomnilnika.

#### Implementacija
```java
class ListArray {
  public Object elements[];
  private int lastElement;
  ...

  // inicializacija novega seznama s podanim stevilom elementov
  public ListArray(int noElem) {
    elements = new Object[noElem];
    ...
  }
  ...
  // pri brisanju in vstavljanju elementa v seznam moramo vse elemente po indexu
  // ustavljanja/brisanja tega elementa premakniti
}
```
#### Operacije in casovne zahtevnosti
- MAKENULL(L) ~ naredi prazen seznam `O(1)`
- FIRST(L) ~ vrne polozaj prvega elementa v seznamu `O(1)`
- LAST(L) ~ vrne polozaj zadnjega elementa v seznamu `O(1)`
- NEXT(p, L) ~ vrne naslednji polozaj polozaja p `O(1)`
- PREVIOUS(p, L) ~ vrne predhodni polozaj `O(1)` // itk je array tko da previous dobis z index - 1
- RETRIEVE(p, L) ~ vrne element a_p na polozaju p  `O(1)`
- INSERT(x, p, L) ~ vstavi element x na polozaj p `O(n)`
- INSERT(x, L) ~ vstavi element x na poljuben polozaj (konc) ` O(1)`  
- DELETE(p, L) ~ zbrise element a_p na polozaju p `O(n)`
- EMPTY(L) ~ preveri ce je seznam prazen `O(1)`
- END(L) ~ vrne polozaj, ki sledi zadnjemu elementu seznama `O(1)`
- OVEREND(p, L) ~ preveri ce je p = END(L) `O(1)`
- LOCATE(x, L) ~ poisce polozaj elementa x v seznamu `O(n)`
- PRINTLIST(L) ~ po vrsti izpise vse elemente v seznamu `O(n)`

## ADT SEZNAM Z INDEKSNIMI KAZALCI
Uporaba v jezikih, ki ne omogocajo dinamicnih podatkovnih struktur.
Vsaka celica polja je sestavljena iz elementa in indeksa naslednjega elementa.
Definicije operacij so podobne operacijam s kazalci, le da programer sam
skrbi za dodeljevanje in *ciscenje* pomnilnika. Polozaj je **zamaknjen**.
Potrebujemo dva seznama:
- prvi seznam vsebuje elemene dejanskega seznama
- drugi seznam povezuje vse prazne celive v polju

Inicalizacija, iskanje in vstavljanje so pocasne operacije `O(n)`. Za brisanje elementa,
pa velja enako kakor pri enosmernemu seznamu s kazalci. Vse elemente elemente, razen zadnjega brisemo s casovno kompleksnostjo `O(n)`.

### Implmementacija
```java
class ListCursorNode {
  Object element;
  int next;
  ...
}

public class ListCursor {
  private ListCursorNode cells;
  private int last;
  ...
}

```
#### Operacije in casovne zahtevnosti
- MAKENULL(L) ~ naredi prazen seznam `O(cells.length)`
- FIRST(L) ~ vrne polozaj prvega elementa v seznamu `O(1)`
- LAST(L) ~ vrne polozaj zadnjega elementa v seznamu `O(1)`
- NEXT(p, L) ~ vrne naslednji polozaj polozaja p `O(1)`
- PREVIOUS(p, L) ~ vrne predhodni polozaj `O(n)` 
- RETRIEVE(p, L) ~ vrne element a_p na polozaju p  `O(1)`
- INSERT(x, p, L) ~ vstavi element x na polozaj p `O(n)`
- INSERT(x, L) ~ vstavi element x na poljuben polozaj (konc) ` O(1)`  
- DELETE(p, L) ~ zbrise element a_p na polozaju p `O(1)...O(n)`
- EMPTY(L) ~ preveri ce je seznam prazen `O(1)`
- END(L) ~ vrne polozaj, ki sledi zadnjemu elementu seznama `O(1)`
- OVEREND(p, L) ~ preveri ce je p = END(L) `O(1)`
- LOCATE(x, L) ~ poisce polozaj elementa x v seznamu `O(n)`
- PRINTLIST(L) ~ po vrsti izpise vse elemente v seznamu `O(n)`

## ADT MNOZICA
// TODO

## ADT VRSTA Z ENOSMERNIM SEZNAMOM S KAZALCI
Vrsta je zbirka elementov, kjer vedno elemente:
- dodajamo na konec vrste
- brisemo na zacetku vrste
 
Vrsta sledi principu FIFO (first-in-first-out).
Implementiramo jo lahko ucinkovito, vse operacije so `O(1)`
Polozaj **ni** zamaknjen.

### Operacije in casovne zahtevnosti
- MAKENULL(Q) ~ naredi prazno vrsto `O(1)`
- EMPTY(Q) ~ ali je vrsta prazna? `O(1)`
- FRONT(Q) ~ vrne prvi element v vrsti `O(1)`
- ENQUEUE(x, Q) ~ vstavi element x na konec vrste `O(1)`
- DEQUEUE(Q) ~ zbrise prvi element iz vrste `O(1)`
  
## ADT VRSTA S KROZNIM POLJEM
Vrsta se krozno premika po polju, pomagamo si z operatorjem ostanka pri deljenju.
Velikost taksne vrste je navzgor omejena s predefinirano velikostjo arraya, tudi ves
cas zavzema maximalno prostorsko zahtevnost pomnilnika. Vse casovne zahtevnosti so ravno tako `O(1)`

```java
int front = (front + 1) % items.length;
int rear = (rear + 1) % items.length;
int rear = (front + count -1) % items.length;
```

## ADT SKLAD
Elemente vedno dodajanmo na vrh sklada, in jih tudi brisemo iz vrha sklada
Skladu pravimo tudi LIFO vrsta (last in first out). 
Slad lahko ucinkovit impementiramo z enosmernim seznamom s kazalci, kjer polozaj ravno
tako ni zamaknjen. Vrh je zacetek

```
(top) [a1| next] --> [a_n| next] --> null
 ```

#### Operacije v slkadu
- MAKENULL(S) ~ naredi prazen sklad `O(1)`
- EMPTY(S) ~ preveri ce je sklad prazen `O(1)`
- TOP(S) ~ vrne zadnji element iz sklada `O(1)`
- PUSH(x, S) ~ vstavi element x na vrh sklada `O(1)`
- POP(S) ~ zbrise vrhni element iz sklada `O(1)`

slklad lahko implementiramo tudi s **poljem**, komplesnost operacij ostane ista,
vendar pride do nekaj slabosti:
- velikost sklada je navzgor omejena (z velikostjo polja)
- ves cas zaseda maksimalno pomnilnika


## ADT PRESKOCNI SEZNAM
```
n1: []--------->[]--------->[]--------->[]--------->[]--------->[]
n0: []->[]->[]->[]->[]->[]->[]->[]->[]->[]->[]->[]->[]->[]->[]->[]
```
Imamo `n` elementov v seznamu `n0`. V preskocnem seznamu, pa se splaca
prilagotiti stevilo elementov na `0 < n1 <= n/2`, ce bi sli cez polovico,
ne bi pridobili prav nic, saj bi na nekaterih segmentih iskali linearno, enako
kot pri klasicnem seznamu.
Koliksen pa naj bo n1, da bomo imeli mininalno stevilo korakov?
- `n1 = n/n1 = sqrt(n)`

Lahko pa tudi povecamo stevilo nivojev, recemo jim ekspresni nivoji.

## ADT PRESLIKAVA (HASH MAP)

Preslikava vsakemu elementu `d` iz domene priredi ustrezn r iz zaloge vrednosti:
 - `M(d) = r`

### Operacije definirane za ADT MAPPING
- MAKENULL(M) ~ inicializira prazno preslikavo
- ASIGN(M, d, r) ~ definira, da je M(d) = r
- COMPUTE(M, d) ~ vrne vrednost M(d) ce je definirana, sicer `null`

Pri implementaciji preslikave lahko uporabimo:
- seznam parov(d, r) `O(n)` 
- iskalna drevesa `O(logn)`
- polje `O(1)`
  
### Implementacija preslikave s poljem
Indeksi polja predstavljajo elemente domene `d`, hitro dodajanje, iskanje, brisanje(`O(1)`). Na zalost pa zahteva veliko pomnilnika, zaradi tega je potrebno, da je domena dovolj majhna.

Ampak, v praksi je moc domene velika, ali celo neskonca, zato uporaimo **zgoscevalno** funkcijo,
ki preslika (zgosti) originalno domeni v manjso domeno.
- h: domaintype -> smalldomaintype

Zgoscevalna funkcija "razprsi" elemente po manjsi domeni. Podatkovni strukturi, ki uporablja zgoscevalno
funkcijo, pravimo zgoscevalna tabela (hash table). Zelimo funkcijo, ki cim bolj enakomerno razprsi
elemente po polju.

#### Zgoscevanje
Problemi:
- izbira velikosti polja:
  - dovolj veliko, da lahko vanj spravimo vse elemente
  -  ne preveliko, saj sicer zavzame prevec pomnilnika
- Izbira ustrezne zgoscevalne funkcije:
  - zelimo funkcijo, ki enakomerno razprsi elemente
  - najbolj preprosta: h(x) = x mod m
  - m ~ prastevilo, ki se razlikuje od potence 2^i // WDYM
  - idealno: injektivna --> `d_1 != d_2 => h(d_1) != h(d_2)`
- sovpadanje:
  - `d_1 != d_2 & h(d_1) = h(d_2)`

Do problemov pride, tudi ko se zgoscevalna tabela napolni, potrebno je izvesti ponovno zgoscevanje(rehashing).
To naredimo tako, da zgradimo vecjo tabelo, ter vse elemente iz manjse tabele uvrstimo v novo tabelo z novo
zgoscevalno funkcijo. Rehashing zahteva `O(n)` casa :((

V povprecju za `n` elementov najmanj `n`  vstavljanj:
n operacij O(1) in in 1 operacija O(n) -> v povprecju `2n/(n+1) = O(2) = O(1)`

#### ZAPRTA ZGOSCENA TABELA
Z zaprto zgosceno tabelo in z zaporednim naslavljanjem: uporabljamo zaporedje zgoscevalnih
funkcij - v primeru sovpadanja izracunane vrednosti uporabim drugo funkicjo za naslednji mozni polozaj elementa.
Najpreprostejse zaporedje: 
- `h_1(h) = (h(x) + i) mod m`
  
Sepravi poskusamo dokler ne najdemo prostega placa.

Better option : `h'_i(x) =((h_1(x) + i  * h_2(x)) mod m)` <br/>
`h_1(x) = (x mod m)` <br/>
`h_2(x) = (x mod m')` &emsp; &emsp; &emsp; `m' = m - 2` <br/>

Slabosti:
- Pri iskanju elementa je potrebno preiskovati do prvega praznega prostora
- Pri brisanju elementa je potrebno zapisati posebno vrednost, ki ne zakljuci iskanja
- Velikost tabele mora biti vecja od stevila elementov `m > n`
- Ce se `n` pribliza `m`, postanejo operacije nespremenljivo pocasne

#### ODPRTA ZGOSCENA TABELA
Tukaj pa elemente preslikamo z zgoscevalo funkcijo, in ce pride do sovpadanja,
dodamo element na konec povezanega seznama
```
[/]
[0] --> [element | next] -> [element | next] --> null
[/]
[1] --> [element | next] -> null
[/]
[2] --> [element | next] -> [element | next] --> null
[/]
...
```
Pricakovana zahtevnost iskanja elementa je `O(n/m)`, kjer je `n` stevilo vstavljenih elementov in `m` velikost zgoscene tabele.

Ce imamo dobro izbrano velikost tabele in zgoscevalno funkcijo, so vse operacije reda `O(1)`

Recap:
- zaprta zgoscena tabela zasede manj pomnilnika
- odprta zgoscena tabela je bol dinamicna  / flekisbilna
- vstavljanje v **odprto** zgosceno tabelo je vedno `O(1)`

### SLABOSTI ZGOSCENIH TABEL
Zaradi fiksne zgoscevalne funkcije, zgoscena tabela ne more biti dinamicna struktura
- vleikosti tabele moramo vnaprej definirati
- ce je tabela prevelika, zapravljamo pomnilnik
- ce je tabela premajhna, pride do prevelikega sovpadanja elemntov
- ponovno zgoscevanje uvede pocasno operacijo `O(n)`

Ne moremo ucinkovito impementirati operacij, ki temeljijo na urejenosti elementov po kljucih. Kot so iskanje najvecjega/najmanjsega elementa, iskanje naslednjega elementa po velikosti, izpis elementov v danem intervalu vrednosti kljuca...

Ce so slabosti nesprejemljive, uporabimo drevo.