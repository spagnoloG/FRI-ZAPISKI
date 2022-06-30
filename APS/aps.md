# APS
(to je nastalo zto k mi ni biu usec font na slajdih, like are we in the 90's bro?)

-> vizualizacije raznih implementacij algoritmov in podatkovnih struktur
https://www.cs.usfca.edu/~galles/visualization/Algorithms.html

## REKURZIJA
Zahteva vec rezije kot iteracija in je pomnilnisko bol zahtevna od iteracije(sklici se shranijo na stacku). Globina rekurzije = potrebna velikost sklada.
Rekurzivne probleme lahko resujemoo tudi z iteracijami:
- vsako repno rekurzijo lahko zamenjamo z iterativno zanko
- vsak rekurzivni program lahko spremenimo v iterativnega s skladom

### PRETVORBA REKURZIJE V ITERACIJO S SKLADOM

very good article: https://www.cs.odu.edu/~zeil/cs361/latest/Public/recursionConversion/index.html

alpa pitonka: https://www.youtube.com/watch?v=Z35sLFyLBek&t=301s

Na sklad shranimo:
- argumente
- lokalne spremenljivke
- naslov (adreso) za nadaljevanje

Primer rekurzivne funckije:
```java
public void recursive(ArgumentType args0) {
  LocalVarsType
  if(robniPogoj())
    sSrobni;
  else {
    s0; // stavki
    recursive(args1);
    s1;
    recursive(args2);
    ...
    recursive(argsRECCALLS);
    sRECCALLS;
  }
}
```


Definicija skladovnega elementa:
```java
class StackElementType {
  Argument type args; // vrednosti argumentov, bodisi za zacetek rekurzivnega klica, bodisi za povraztek iz rekurzivnega klica
  LocalVarsType locals; // vrednosti lokalnih spremenljivk za povratek iz rekurzivnega klica
  int address; // vrednosti med 0 in RECCALS (st. rekurzivnih klicev, ne globina!)
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

    // izvedi del algoritma za dani naslov
    switch(e.address) {

      case 0: // izvajamo od zacetka
            if(robniPogoj()) sRobni;
            else {
              s0; // izvedemo stavke
              // priprava za povratek
              e.address = 1; // postavimo naslov na 0 + 1
              e.args = args0; // dodamo trenutno izracunane argumente
              e.locals = locals0; // dodamo trenunto spremenjene lokalne spremenljivke
              st.push(e); /// dodamo element na sklad
              // priprava za zacetek rek. klica
              e.address = 0; 
              e.args = args1;
              st.push(e);
            }
            break;
      case i: // 0 < i < RECCALLS
            si;
            // priprava za povratek
            e.address = i + 1;
            e.args = args0;
            e.locals = locals0;
            st.push(e);
            // priprava za zacetek rek. klica
            e.address = 0;
            e.args = args_(i+1); // ustrezno za klic
            st.push(e);
            break;
      case RECCALS:
            sRECCALLS;
            break;
    }

  } while(!st.empty);

}
```
Primer iz linkanega clanka
```cs
template <class T> 
void quickSort(T[] v, unsigned int numberOfElements)
{
  if (numberOfElements > 1) 
    { // quickSort(v, 0, numberOfElements - 1);
     stack<pair<unsigned int, unsigned int>, list<pair<unsigned int, unsigned int> > > stk; 
     stk.push (make_pair(0, numberOfElements - 1)); // initialize the stack

     while (!stk.empty())
      {
       // simulated recursive call - remove parameters from stack
       low = stk.top().first;
       high = stk.top().second;
       stk.pop();

       // no need to sort a vector of zero or one elements
       if (low < high)
         {
          // select the pivot value
          unsigned int pivotIndex = (low + high) / 2;

          // partition the vector
          pivotIndex = pivot (v, low, high, pivotIndex);

          // sort the two sub vectors
          if (low < pivotIndex)
            stk.push (make_pair(low, pivotIndex));
          if (pivotIndex < high)
            stk.push (make_pair(pivotIndex+1, high));
         }
      }
   }
}

```

### PRIMER REPNE REKURZIJE
Ali je ta rekurzija repna?
```java
int fakulteta(int n) {
  if(n == 0)
    return 1;
  else
    return n * fakulteta(n - 1);
}
```
Odgovor je **ne**, saj tukaj se pomnozimo rezultat klica funkcije s spremenljivko `n`. O Repni rekurziji lahko govorimo le v primeru, ko imamo v zadnji vrstici funkcije en sam `return function_call(params);` rekurzivni klic, enako velja za sestevanje z `n` in sestevanjem rekurzivnih klicov. V repni rekurziji je klic **eden**.
No pa pretvorimo tale primer v **pravilno** repno rekurzijo:
```java
int fakulteta(int n, int acc) {
  if(n == 0)
    return 1;
  else
    return fakulteta(n - 1, n * acc);
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

### POGOSTE KOMPLEKSNOSTI
- `log(n)` ~ zelo pocasi raste
- `n` ~ linearno narascanje
- `n * log(n)` ~ blizu linearnega narascanja (rahlo vec)
- `n^2, n^3, ...` ~ polinomsko (sprejemljivo)
- `2^n` ~ nesprejemljivo
- `n!` ~ nesprejemljivo
- `n^n` ~ nesprejemljivo

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
> Mnozica (angl. set) - zbirka elementov, kjer vrstni red ni pomembern in elementi se ne ponavljajo

### Operacije
- MAKENULL(S) ~ naredi prazno mnozico S `O(1)`
- FIRST(S) ~ vrne polozaj prvega elementa v mnozici S `O(1)`
- NEXT(p, S) ~ vrne naslednji polozaj polozaja p `O(1)`
- RETRIEVE(p, S) ~ vrne element a_p na polozaju p `O(1)`
- INSERT(x, S) ~ vstavi element `x` v mnozico S brez podvajanja `odvisno od implementacije`
- DELETE(p, S) ~ zbrise element a_p na polozaju p `odvisno od implementacije`
- EMPTY(S) ~ preveri ali je mnozica prazna `O(1)`
- OVEREND(p, S) ~ preveri, ce je p polozaj, ki sledi zadnjemu `O(1)`
- LOCATE(xm S) ~ poisce polozaj elementa `x` v mnozici S `O(n)`
- PRINTSET(S) ~ po vrsti izpise vse elemente v mnozici S `O(n)`
- UNION(S1, S) ~ v mnozico S doda (brez podvajanja) vse elemente iz mnozice S1 `O(mn)`
- INTERSECTION(S1, S) ~ iz mnozice S zbrise vse elemente, ki se ne nahajajo tudi v S1 `odvisno od implementacije`

### Mnozico lahko implementiramo:
- S povezanim seznamom:
    - INSERT(x, S) `O(n)`
    - LOCATE(x, S) `O(n)`
    - UNION:
      - enosmerni seznam `O(m*n)` (gremo skozi obe mnozici)
      - urejeni seznam `O(m + n)`
    - INTERSECTION:
      - enosmerni seznam `O((m+n)*n)` (element poiscemo, plus brisemo)
      - urejeni seznam `O(m + n)`
- Z zgosceno tabelo:
  - ucinkoviti operaciji INSERT(x, S) in LOCATE(x, S) `O(1)` (btw pod pogoji, da hash funkcija dela tko ku je trea)
  - UNION(S1, S) `O(m)`
  - INTERSECTION(S1, S) `O(n)`
  - Neucinkovite, ki so vezane na urejenost elementov
- Z drevesom:
  - ucinkoviti operaciji INSERT(x, S) in LOCATE(x, S) `O(logn)`
  - UNION(S1, S) `O(m log n)`
  - INTERSECTION(S1, S) `O(m log n)`
  - Hitre operacije, ki so vezane na urejenost elementov


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

Better option : `h'_i(x) =((h_1(x) + i  * h_2(x)) mod m)` // zaradi mnozenja se elementi bolj razprsijo <br/>
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

## ADT DREVO

```
          A
        / | \ 
       B  C  D
      /     /  \ 
     E     H    J  
    / \
   F   G
```


Terminologija:
 - **stopnja** (degree) **vozlisca** ~ stevilo sinov vozlisca (stopnja vozlisca E = 2)
 - **stopnja drevesa** ~ najvecje stevilo sinov od korena drevesa (v tem primeru 3)
 - **pot** (path) ~ zaporedje root vozlisc vozlisc (npr A -> B -> E -> G)
 - **nivo vozlisca** (level) ~ dolzina  poti od korena do vozlisca(nivo vozlisca E = 3)
 - **visina drevesa** (height) ~ dolzina najdaljse poti od korena do list(za zgornje drevo je 4)

Primer izracuna visine drevesa
```java
public int height(TreeNode n) {
  if(n == null)
    return 0;
  else
    return Math.max(height(leftomostChild(n)) + 1, height(rightSibling(n)); // pri levemu prisetejemo se oceta
}
```
### OBHOD DREVESA (TRAVERSAL)
```
          A
        /   \ 
       B     C
      / \   /  \ 
     D   E F    G
```
**Premi (preorder)** ~ izpisemo oznako korena pred oznakami poddreves. (`A, B, D, E, C, F, G`)
```java
public void preorder(Tree r) {
  if(r != null) {
    r.writeLabel(); Stystem.out.print(", ");
    Tree n = leftmostChild(r);
    while(n != null) {
      preorder(n);
      n = rightSibling(n);
    }
  }
}
```
**obratni (postorder)** ~ izpisemo najprej oznake vozlisc vseh poddreves in zatem oznako korena(`D, E, B, F, G, C, A`)

```java
public void postorder(Tree r) {
  if(r != null) {
    Tree n = leftmostChild(r);
    while(n != null) {
      postorder(n);
      n = rightSibling(n);
    }
    // nazadnje izpisemo oznako korena
    r.writeLabel(); System.out.println(", ");
  }
}

```
**vmesni (inorder)** ~ izpisemo najprej oznake vozlisc najbolj levega drevesa, nato oznako korena in zatem oznake vozlisc vseh ostalih poddreves korena. (`D, B, E, A, F, C, G`). Je najbolj zanimiv za binarna iskalna drevesa, saj tako lahko izpisemo elemente po narascujocem vrstnem redu, ker so v levem poddrevesu elementi vedno manjsi od korena, v desnem pa vecji.

```java
public void inorder(Tree r) {
  if(r != null) {
    Tree n = leftmostChild(r);
    inorder(n);
    // za levim  poddrevesom izpisemo oznako korena
    r.writeLabel(); System.out.print(", ");
    n = rightSibling(n);
    while(n != null) {
      inorder(n);
      n = rightSibling(n);
    }
  }
}
```
**nivojski** ~ izpisemo najprej vsa vozlisca na 1. nivoju, zatem na 2. nivoju itn. (`A, B, C, D, E, F, G`).
```java
pubic void printByLevel() {
  int l = 1;
  while(printLevel(l, root())) {
    l++;
    System.out.println();
  }
}

private booolean printLevel(int l, Tree r) {
  if(r == null)
    return false;
  else if (l == 1) {
    r.writeLabel(); System.out.print(", ");
    return true;
  }
  else {
    Tree n = leftmostChild(r);
    boolean existsLevel = false;
    while(n != null) {
      // izpis nivoja je mozen v vsaj enem poddrevesu
      existsLevel = existisLevel || printLevel(l-1, n);
      n = rightSibling(n);
    }
    return existsLevel;
  }
}
```
### Formule za drevesa (min in max št. elementov) 
```
BST
- min: izrojeno drevo => seznam => n = h
- max: 2^h - 1

RB-TREE
- min: 2^floor((h+1)/2) + 2^floor(h/2) - 2
- max: 2^h - 1

AVL-TREE
- min: st(0) = 0, st(1)= 1, st(h) = st(h - 1) + st(h - 2) + 1
- max: 2^h - 1

B-TREE
- min: 2*ceil(m/2)^(h-1) - 1
- max: m^h - 1
```


### Implementacija drevesa s poljem
- vsako vozlisce hrani **stevilo sinov**, celo drevo pa stevilo vozlisc `n`
- koren drevesa je **prvi** element polja
- sledijo vsa vozlisca prvega najbolj levega pddrevesa, nato vsa vozlisca drugega poddrevesa in tako naprej
- vsako poddrevo je shranjeno po istem pravilu

```
          A
        / | \ 
       B  C  D
      /     /  \ 
     E     H    J  
    / \
   F   G

   [A][3] -- root
   [B][1] \
   [E][2]  | 
   [F][0]  | -- prvo poddrevo 
   [G][0] /
   [C][0] -- drugo poddrevo
   [D][2] \
   [H][0]  | - tretje poddrevo
   [J][0] /
```
### Operacije in casovne zahtevnosti
- PARENT(n, T) ~ vrne oceta vozlisca `n` v drevesu T `O(1)`
- LEFTOMOST_CHILD(n, T) ~ vrne najbollj levega sina vozlisca `n` `O(1)`
- RIGHT_SIBLING(n, T) ~ vrne desnega brata vozlisca `n` `O(k)`, `k` je setevilo 
- LABEL(n, T) ~ vrne oznako vozlisca `n`
- ROOT(T) ~ vrne koren drevesa, ce eksplicitno shranjen `O(1)`
- MAKENULL(T) ~ naredi prazno drevo `O(1)`
- CREATE(r, v, T1, ... , Ti) ~ generira drevo s korenom `r` z oznako v, ter s stopnjo `i` s poddrevesi `T1, ..., Ti` `O(n)`

Ker polje ni dinamicna struktura, vstavljanje pomeni premikanje vseh elementov v tabeli, se redko uporablja za implementacijo dreves. Ce se ze uporabi se uporabi za storage.


### Implementacija drevesa s kazalci
Poznamo dve obliki implementacije dreves:
- vsako vozlisce vsebuje kazalca na **levega otroka** in **desnega brata** 
  ```java
  public class Tree {
    public Node parent, leftSon, rightSibling;
  }
  ```
  ```
        A -> n
      /       \ 
     B   ->    C -> n
   /   \       /  \
  D ->  E->n  F -> G -> n
  ```
- vsako vozlice vsebuje kazalce na vse otroke (obicajno drevesa z navzgor omejeno stopnjo, npr. binarna drevesa)
  ```java
  public class Tree {
    public Node parent, leftSon, rightSon; // primer implementacije binarnega drevesa
  }
  ```
  ```
          A
        /   \ 
       B     C
      / \   /  \ 
     D   E F    G
  ```

Ponavadi dodamo tem implementacijam se kazalec na oceta.

### Operacije in casovne zahtevnosti
- PARENT(n, T) ~ vrne oceta vozlisca `n` v drevesu T `O(1)`
- LEFTOMOST_CHILD(n, T) ~ vrne najbollj levega sina vozlisca `n` `O(1)`
- RIGHT_SIBLING(n, T) ~ vrne desnega brata vozlisca `n` `O(1)`
- LABEL(n, T) ~ vrne oznako vozlisca `n` `O(1)`
- ROOT(T) ~ vrne koren drevesa, ce eksplicitno shranjen `O(1)`
- MAKENULL(T) ~ naredi prazno drevo `O(1)`
- CREATE(r, v, T1, ... , Ti) ~ generira drevo s korenom `r` z oznako v, ter s stopnjo `i` s poddrevesi `T1, ..., Ti` `O(1)` Za razliko od implementacije s poljem, je tukaj CREATE operacija zelo hitrejsa, saj je potrebno samo prevezati pointerje in ne dodajati novih elementov tabelo (`i` je tudi navzgor omejen, zato ga tretiramo kot konstantno operacijo)

### Binarna drevesa
vsa vozlisca s stopnjo manjso ali enako 2
vozlisce ima lahko tudi samo desnega sina

Lastnosti binarnih dreves:
- binarno drevo visine `v` ima najvec `2^n - 1` vozlisc
- visina binarnega drevesa z `n` vozlisci `n >= v >= [log_2(n+1)]`
- v binarnem drevesu z `n` vozlisci je `n + 1` praznih poddreves

Binarno drevo lahko izrodimo(degenerate) na `2^(n-1)` nacinov.
```
   A   1 
 /   \  *
null  B  2
    /   \  *
  null   C  2
       /   \  *
     null   D  2
          /   \ *
        null   E 2
               ... (n - 1)
```
## KONTEKSTNO NEODVISNE GRAMATIKE
*this year skipped* 

## ADT SLOVAR
Je poseben primer ADT mnozice, ki omogoca samo vstavljanje, brisanje in iskanje elementa.
Za ucinkovito iskanje elementov, potrebujemo relacijo **urejenosti** med elementi.
Urejenost je definirana bodisi na elementih samih bodisi na delih elementov - kljucih (keys).

Vsaka podatkovna baza je pravzaprav slovar:
- elementi so urejeni po kljucih, zaradi hitrega iskanja
- ker so baze shranjene na (relativno) pocasnem disku, je potrebno izbrati podatkovno strukturo, ki minimizira stevilo dostopov do diska

### Osnovne operacije
- MAKENULL(D) ~ naredi prazen slovar D `O(1)`
- MEMBER(x, D) ~ preveri ce je element `x` v slovarju `D`
- INSERT(x, D) ~ vstavi element `x` v slovar `D`
- DELETE(x, D) ~ zbrise element `x` iz slovarja `D`

Zaradi urejenosti elementov v slovarju je mozno ucinkovito implementirati tudi operacije:
- iskanje minimalnega elementa
- iskanje maksimalnega elementa
- iskanje predhodnika(predecessor)
- iskanje naslednika(successor)
- izpis elementov na danem intervalu

### Implementacija slovarja z zgosceno tabelo
Se ne uporablja, uporablja se implementacija z drevesom.
Ampak in special cases zna prit prav, saj so osnovne operacije `O(1)` (pod dolocenimi pogoji, cene pa niti ne vec tolko kjut (rehashing ipd.)

Slabosti:
- fiksna podatkovna struktura
- fiksna zgoscevalna funkcija (zaradi sovpadanja se lahko izrodi v seznam)
- neucinkovite operacije, ki temeljijo na urejenosti po kljucih

### Implementacija slovarja z drevesom
Casovna kompleksnost osnovnih operacij je reda `O(log n)`. Ravno isto velja
za operacije na podlagi urejenosti elementov. (`n` je stevilo elementov slovarja)

## BINARNO ISKALNO DREVO
:tipspepe: https://www.youtube.com/watch?v=cySVml6e_Fc (samo pazi k prns je retardirana implementacija,tko da tisti element, ki ga ustavis, pole samo se traversas do roota)

Binarno iskalno drevo je najbolj preprosta drevesna implementacija slovarja.
```java
public class BSTree implements Dictionary {
  Node rootNode;
}

public class Node {
  Comparable key;
  Node left, right;
}
```
#### Iskanje elementa v BST
```java
private Node member(Comparable x, Node node) {
  if(node == null)
    return null;
  else if(x.compareTo(node.key) == 0)
    return node;
  else if(x.compareTo(node.key) < 0) 
    return member(x, noder.left);
  else
    return member(x, node.right);
}
```
#### Dodajanje elementa v list
```java
private Node insertLeaf(Comparable x, Node node) {
  if(node == null) 
    node = new Node(x);
  else if(x.compareTo(x.node.left) < 0)
    node.left = insertLef(x.node.left);
  else if(x.compareTo(x.node.left) > 0)
    node.right = insertLeaf(x.node.right);
  else // v tem primeru ne naredi nc, saj je isti element ze v drevesu
    retrun null
  return node;
}
```
#### Desna rotacija

```
Dodamo nov element X < A

   A       -->   A    -->      X 
 /   \         /   \         /   \
L     R       X     R       L1    A
            /   \               /   \
           L1   L2             L2    R
```

```java
private Node rightRotation(Node node) {
  Node temp = node;
  node = node.left;
  temp.left = node.right;
  node.right = temp;
  return node;
}
```
#### Leva rotacija

```
Dodamo nov element X > A

   A       -->   A    -->        X 
 /   \         /   \           /   \
L     R       L     X         A    R2
                  /   \     /   \
                 R1   R2   L    R1
```       

```java
private Node leftRotation(Node node) {
  Node temp = node;
  node = node.right;
  temp.left = node.left;
  node.left = temp;
  return node;
}
```
#### Dodajanje elementa v koren
Rekurzija gre najprej v globino, in element se doda kot list. Pri vracanju iz rekurzije se izvaja zaporedje
rotacij, ki dvigne element v koren. Casovna zahtevnost je sorazmerna visini drevesa.
```java
private Node insertRoot(Comparable x, Node node) {
  if(node == null)
    node = new Node(x);
  else if(x.compareTo(node.key) < 0) {
    node.left = insertRoot(x, node.left);
    node = rightRotation(node);
  }
  else if(x.compareTo(node.key) > 0) {
    node.right = insertRoot(x, node.right);
    node = leftRotation(node);
  }else
    ; // je ze not
  return node;
}
```

#### Brisanje elementa
```java
// za prenos minimalnega kljuca iz poddrevesa
private Comparable minNodeKey;

public Node delete(Comparable x, Node node) {
  if(node != null) {
    if(x.compareTo(node.key) == 0) { // najdli smo tega k je trea zbrisat
      if(node.left == null)
        node = node.right;
      else if(node.right == null)
        node = node.left;
      else {
        node.right = deleteMin(node.right);
        node.key = minNodeKey;
      }
    }
  } 
  else if(x.compareTo(node.key) < 0)
    node.left = delete(x, node.left);
  else
    node.right = delete(x, node.right);
  retrun node; 
}


private Node deleteMin(Node node) {
  if(node.left != null) {
    node.left = deleteMin(node.left); // ohranjamo strukturo
    return node;
  }
  else {
    minNodeKey = node.key; // prenos kljuca
    return node.right; // ohrani desno poddrevo
  }
}
```
## AVL DREVO
Bols ku se piflat teorijo, poglej si raje ta prakticn video, razlaga je top :)
- https://www.youtube.com/watch?v=jDM6_TnYIqE

Je delno poravnano binarno iskalno drevo. Za vsako vozlisce velja, da se visini obeh poddreves razlikujeta za najvec 1. Visina maximalno izrojenega AVL dervesa z `n` elementi je: `h = 1.44log_2(n+1)`. Zahtevnost osnovnih operacij je reda O(logn).

Primer AVL - node-a
```java
public class Node {
  Comparable key;
  Node left, righ;
  int balance; // ravnotezni faktor
}
```
#### Dodajanje elementa v AVL drevo
- Element dodamo v list drevesa kot pri navadnem BST
- Preverimo ravnotezni faktor vseh vozlisc na poti navzgor od vstavljenega lista do korena drevesa.
    - ce je absolutna vrednost ravnoteznega faktorja vecja kot 1, je potrebno drevo popravljati
    - v najslabsem primeru je potrebno popravljati ravnotezni faktor vse do korena - ko pride do rotacije(enojne ali dvojne), je postopek zakljucen
- popravljanje -> moozna sta 2 primera:
  - koren ima absolutno vrednost ravnoteznega faktorja 2, sin pa 2 in oba faktorja **isti** predznak (izvedemo enojno rotacijo)
  - koren ima absolutno vrednost ravnoteznega faktorja 2, sin pa 1 in oba faktorja imata **razlicna** predznaka (izvedemo dvojno rotacijo)


#### Implementacija AVL drevesa

```java
class Avl {

    public static void main(String [] args) {
      Node root = new Node(10);
      AVLTree tree = new AVLTree(root);
    
      for(int i = 2; i < 99999999; i++) {
          if(i!=10)
            tree.insert(root, i);
      }
    }
}


class Node {
    int key;
    int height;
    Node left, right;

    public Node(int key) {
        this.key = key;
    }
}

class AVLTree {
    private Node root;
    
    public AVLTree (Node root) {
        this.root = root;
    }

    void updateHeight(Node n) {
        n.height = 1 + Math.max(height(n.left), height(n.right));
    }

    int height(Node n) {
        return n == null ? -1 : n.height;
    }

    int getBalance(Node n) {
        return (n == null) ? 0 : height(n.right) - height(n.left);
    }
    
    Node mostLeftChild(Node n) {
        while(n.left != null)
            n = n.left;
        return n;
    }

    //           Y                   X
    //        /     \              /   \
    //       X       R            L     Y
    //     /   \                      /   \
    //    L     Z                    Z     R
    Node rotateRight(Node y) {
        Node x = y.left;
        Node z = x.right;
        x.right = y;
        y.left = z;
        updateHeight(y);
        updateHeight(x);
        return x;
    }

    //        Y                     X
    //      /   \                 /   \
    //     L     X               Y     R
    //         /   \           /   \
    //        Z     R         L     Z
    Node rotateLeft(Node y) {
        Node x = y.right;
        Node z = x.left;
        x.left = y;
        y.right = z;
        updateHeight(y);
        updateHeight(x);
        return x;
    }

    Node rebalance(Node z) {
        updateHeight(z);
        int balance = getBalance(z);
        if(balance > 1) {
            if(height(z.right.right) > height(z.right.left)) {
                z = rotateLeft(z);
            } else {
                z.right = rotateRight(z.right);
                z = rotateLeft(z);
            }
            
        } else if (balance <  -1) {
            if(height(z.left.left) > height(z.left.right)) {
                z = rotateRight(z);
            } else {
                z.left = rotateLeft(z.left);
                z = rotateRight(z);
            }
        }
        return z;
    }

    Node insert(Node node, int key) {
        if(node == null) {
            return new Node(key);
        } else if(node.key > key) {
            node.left = insert(node.left, key);
        } else if(node.key < key) {
            node.right = insert(node.right, key);
        } else {
            throw new RuntimeException("Already in tree");
        }
        // rebalance tree from inserted node to root
        return rebalance(node);
    }



    Node delete(Node node, int key) {
        if(node == null) return node;
        else if(node.key > key) {
            node.left = delete(node.left, key);
        } else if(node.key < key) {
            node.right = delete(node.right, key);
        } else {
            if(node.left == null || node.right == null) {
                node = (node.left == null) ? node.right : node.left;
            } else {
                Node mostLeftChild = mostLeftChild(node.right);
                node.key = mostLeftChild.key;
                node.right = delete(node.right, node.key);
            }
        }
        if(node != null) {
            node = rebalance(node);
        }
        return node;
    }
}


```

#### Brisanje elementa iz AVL drevesa
- Element brisemo kot pri navadnem BST:
  - ce je element list drevesa, ga enostavno izbrisemo
  - ce ima element samo enega sina, ga izbrisemo ter na njegovo mesto postavimo njegovega sina
  - ce ima element dva sina, izbrisemo najvecji element iz levega poddrevesa ali najmanjsi element iz desnega poddrevesa, ki nadomesti dejansko izbrisano vozlisce
- Preverimo ravnotezni faktor vseh vozlisc na poti navzgor od oceta dejansko izbrisanega vozlisca do korena drevesa
  - ce je absolutna vrednost ravnoteznega faktorja vecja kot 1, je potrebno drevo popravljati
  - v najslabsem primeru je potrebno popravljati ravnotezni faktor vse do korena poravnati drevo
- popravljanje -> mozna sta 2 primera:
    - Ob brisanju elementa je mozen primer, da ima sin ravnotezni faktor enak 0 (enojna rotacija)
    - koren ima absolutno vrednost ravnoteznega faktorja 2, sin pa 1 in imata oba faktorja **isti** predznak (enojna rotacija)
    - koren ima absolutno vrednost ravnoteznega faktorja 2, sin pa 1 in faktorja imata **razlicna*2

#### LL ROTACIJA (enojna)

```
Initially     Insert 10   after rotation

  30 [1]      30 [2]         20 [0]
  /           /             /  \
 20 [0]      20 [1]    [0] 10   30 [0]
            /
          10 [0]

Primer na vecjem drevesu

            A                   B
          /   \             /       \
         B     Ar          C         A
       /   \             /   \     /   \
      C     Br          Cl   Cr   Br   Ar 
    /   \
  Cl     Cr 

Tle mamo LL inbalance. Sepravi smo insertali Left left od roota.
```
#### LR ROTACIJA (dvojna)
```
Initially     Insert 20      first rotation   second rotation

  30 [1]      30 [2]              30 [2]         20 [0]
  /           /                  /              /  \
 10 [0]      10 [-1]            20 [1]     [0] 10   30 [0]
               \               /
                20 [0]       10 [0]

Primer na vecjem drevesu

            A                       C
          /   \                   /   \
         B     Ar                B     A
       /   \                   /  \     \  
      Bl     C                Bl  Cl     Ar
           /   \
          Cl    Cr

Tle mamo LR inbalance. Sepravi smo insertali Left right od roota.
```
#### RR ROTACIJA (enojna)
```
Initially     Insert 30             after rotation

  10 [-1]        10 [-2]                  20 [0]
    \              \                     /  \
     20 [0]         20 [-1]         [0] 10   30 [0] 
                      \
                       30 [0]

Tle mamo RR inbalance. Sepravi smo insertali right right od roota.
```
#### RL ROTACIJA (dvojna)
```
Initially     Insert 30        first rotation           second rotation

  10 [-1]        10 [-2]            10 [-2]                  20 [0]
    \              \                  \                     /  \
     30 [0]         30 [1]             20 [-1]        [0] 10    30 [0]
                   /                     \
              [0] 20                      30 [0]

Tle mamo RL inbalance. Sepravi smo insertali right left od roota.
```

### RDECE-CRNO DREVO
Bols ku se piflat teorijo, poglej si raje te prakticne videe, razlaga je top :)
- https://www.youtube.com/watch?v=3RQtq7PDHog
- https://www.youtube.com/watch?v=qA02XWRTBdw
- https://www.youtube.com/watch?v=w5cvkTXY0vQ

Vsako vozlisce je bodisi rdece, bodisi crne barve.
Rdece vozlisce ima lahko samo crna sinova. Za vsako vozlisce velja, da vsaka
pot od vozlisca do praznega poddrevesa (null) vsebuje enako stevilo crnih vozlisc (crna
visina je konstanta). Visina rdece-crnega drevesa z `n` vozlisci je najvec `2log_2(n + 1)`.

Rdece-crno drevo je **vedno** delno poravnano. Visina drevesa je najvec dvakrat vecja od poravnanega dreves z istim stevilom vozlisc. Najdaljsa pot od korena do listov je kvecjemu dvakrat daljsa od najkrajes poti od korena do listov.

```
Bol ku tko se ne more izrodit
    A
  /   \
 B     C
     /   \
    D     E
           \
            F
```
Primer RB - node-a
```java
public class Node {
  Comparable key;
  Node left, right, parent;
  int color;
}
```
#### Osnovne operacije so hitre `O(logn)`
- iskanje ~ enako kot pri obicajnem BST `O(logn)`
- dodajanje ~ dodamo **rdeci** list, vendar je ob dodajanju potrebno popraviti strukturo drevesa, od spodaj navzgor (v najslabsem primeru od najnizjega lista do korena -> `O(logn)`)
- brisanje ~ nadomestimo element z minimalnim iz desnega poddrevesa(ali z maksimalnim iz legega poddrevesa), ce je minimalni (izbrisani) **crn**, potem je potrebno ravno tako popravljanje strukture drevesa, ki se nadaljuje do korena (`O(logn)`).

Honestly se res splaca pogledat videe za te operacije..

#### Dodajanje elementa v rdece-crno drevo
- Element dodamo v list drevesa kot pri navadnem BST
- Dodano vozlisce (list) pobarvamo **rdece**
- Ce je oce dodanega lista **rdec**, je potrebno drevo popraviti(rekurizvna definicja):
  - oce je koren drevesa -> postopek se zakljuci
  - stric je **rdec** --> stari oce postane **rdec** --> **ponovi** 3. pri starem ocetu
  - stric ni **rdec** -> postopek se zakluci
  
#### Brisanje elementa iz rdece-crnega drevesa
- Element izbrisemo iz drevesa kot pri navadnem BST:
    - ce je element list drevesa, ga enostavno izbirsemo
    - ce ima element samo enega sina, ga izbrisemo, ter na njegovo mesto postavimo njegovega sina
    - ce ima element dva sina, zbrisemo najvecji element iz desnega poddrevesa, ki nadomesti dejansko izbrisano vozlisce

- Barvanje:
  - Ce je izbrisano **rdece** vozlisce, koncamo
  - Ce je izbrisano **crno** vozlisce, je potrebno drevo popraviti (crna visina danega poddrevesa je je znizala za ena)
  
- Brsianje crnega vozlisca:
  -  ce je koren problematicnega poddrevesa **rdec** -> zakljuci
  -  ce je izbrisan koren drevesa -> zakljuci
  - v nasprotnem primeru:
    - 1. brat je **rdec** -> **crn** brat -> skoci v 2.
    - 2. **crn** brat in ni **rdecega** necaka -> ponovi cel postopek pri ocetu
    - 3. **crn** brat in **crn** zunanji necak -> **rdec** zunanji necak -> skoci v 4.
    - 4. **crn** brat in **rdec** zunanji necak -> postopek se zakljuci
  


## ADT PRIORITETNA VRSTA
V prioritetni ali prednostni vrsti ima vsak element oznako prioritete, ki doloca vrstni red brisanja elementov iz vrste.
Ne velja FIFO! 
Sledi dogovoru:  nizja je prioriteta, prej bo element prisel iz vrste.

### Operacije in casovne zahtevnosti
- MAKENULL(Q) ~ napravi prazno prioritetno vsto Q  `O(1)`
- INSERT(x, Q) ~ vstavi element x v prioritetno vrsto Q `<= O(logn)`
- DELETEMIN(Q) ~ vrne element z najmanjso prioriteto iz prioritetne vrste Q in ga izbrise iz Q `<= O(logn)`
- EMPTY(Q) ~ ali je prioritetna vrsta Q prazna? `<= O(logn)`

### Heap implementacija
- je levo poravnano, na najglobljem nivoju drevesa eventuelno manjkajo elementi samo iz desne strani
- je delno urejeno, za vsako poddravo velja, da je v korenu najmanjsi element tega poddrevesa
- **vozlisca hranimo po vrsti po nivojih**
- hranimo se stevilo elementov `n`

V vozliscih ne potrebujemo dodatnih indeksov, saj jih lahko sproti izracunamo:
- ce z `i`(`i` gre od **1** naprej) oznaciom indeks vozlisca, potem velja:
    - `2*i` je indeks levega sina
    - `2*i + 1` je indeks desnega sina
    - `i/2` je indeks oceta
  
```java
public class Heap {
  static final int DEFAULT_SIZE = 100;
  static final int DEGREE = 2;
  Comparable nodes[];
  int noNodes, size;
}
```
#### Insert procedure:
- element `x` najprej dodamo na prvo prazno mesto z leve na zadnjem nivoju drevesa
  - ce je zadnji nivo zapolnjen, ga dodamo kot prvega z leve na naslednjem nivoju
- zamenjamo `x` z ocetom, dokler ni:
  - oce manjsi od `x` ali
  - `x` v korenu drevesa
Casovna zahtevnos je reda `O(logn)`

### Deletemin procedure:
- Najmanjsi element se nahaja v korenu
- Nadomestimo ga z najbolj desnim elementom `x` na zadnjem nivoju kopice
- zaporedno zamenjujemo `x` z najmanjsim od obeh sinov, dokler ni:
  - `x` manjsi od obeh sinov
  - `x` list drevesa
  
Casovna zahtevnost reda `O(logn)`

### Izgradnja kopice
Kopico z `n` elementi zgradimo v casu reda
- O(nlogn), ce `n` krat uporabimo `INSERT`
- O(n), ce so vsi elementi podani na zacetku
    - elemente najprej kar v poljubnem vrstnem redu postavimo v kopico, ki je tako levo poravnana
    - kopico urejamo po nivojih od spodaj navzgor

**Heapsort** -> najprej zgradimo kopico, nato pa se po vrsti jemlji od najmanjsega do najvecjega `O(nlogn)`.

Za algoritme na grafih, je potrebna se operacija `DECREASEKEY(x, k, Q)`, ki elementu v kopici zmanjsa kljuc na `k` :
  - najprej posicemo element `x` `O(logn)` in mu priredimo vrednost `k`
  - zamenjamo `x` z ocetom, dokler ni:
    - oce manjsi od `x` ali
    - `x` v korenu drevesa

### Implementacija prioritetne vrste s pomocjo razlicnih podatkovnih struktur

|                  | Insert    | Deletemin | decrease_priority |
|------------------|-----------|-----------|-------------------|
| neurejeni seznam | O(1)      | O(n)      | O(1)              |
| urejeni seznam   | <=O(n)    | (1)       | O(n)              |
| BST              | <=O(n)    | <=O(logn) | O(n)              |
| AVL, RB-tree     | =O(logn)  | =O(logn)  | O(logn)           |
| heap             | <=O(logn) | <=O(logn) | O(logn)           |
| hash table       | O(1)      | O(n)      | O(1)              |

## ADT BDREVO
B drevo je popolnoma poravnano isaklno drevo, vsi listi so na istem nivoju. Vsako notranje vozlisce B-drevesa reda `m` ima lahko
od `m/2` do `m`.

Visina: `h <= log_[m/2](n+1/2) + 1`

Properties:
  - vsako vozlisce ima max `m` otrok
  - minimum otrok:
    - koren: `2` (ce mamo seveda sploh enough elementov)
    - list: `0`
    - notranja vozlisca `floor(m/2)`
  - vsako vozlisce ima `max(m-1)` kljucev
  - vsako vozlisca ima min kljucev:
    - koren `1`
    - vsa ostala vozlisca  `floor(m/2) - 1`



Zelo so upoorabna za velike podatkovne baze, saj s pomocjo bdreves zminimiziramo stevilo dostopov do diska.

V praksi se uprablja `m=512, 1024,.. ++`, tako da prva dva ali celo tri nivjoe drevesa hranimo v GP --> kar pomeni da potrebujemo za dostop do enega izmed 100T podatkov, samo 2 ali 3 branja iz diska.

#### Implementacija
```java
public class BtreeNode {
  int count; // st kljucev v vozliscu
  Comparable keys[]; // [0,m -1]
  BtreeNode children[]; // [0, m]
}
```
### Operacije

- **Iskanje** je posplošitev iskanja v BST: v vozlišču bodisi
najdemo element ali pa ustrezno poddrevo. Postopek:
  - Iskanje zacnemo v vozliscu, ki je koren drevesa
  - Iskani element **zaporedno** preverjamo z elementi v vozliscu, dokler:
    - ne naletimo na iskani element
    - ne naletimo na vecji element in se iskanje rekurzivno nadaljuje v poddrevesu z istim indeksom
    - ne peregledamo zadnjega elementa in se iskanje rekurzivno nadaljuje v zadnjem poddrevesu
  - Casovna zahtevnost : `O(mlogn)` (Ce uporabimo bisekcijo, za iskanje po kljucih --> `O(logm * logn))`


- **Dodajanje**: element dodamo v list; če ni dovolj prostora,
se list razbije na dva lista z ustreznim ključem, ki ga
rekurzivno dodamo očetu. Postopek:
  - ce opazovano vozlisce vsebuje manj kot `m-1` elementov, dodamo element na ustrezno mesto in koncamo
  - ce v opazovanem vozliscu ni prostora(ima ze m-1 elementov in z dodajanjem imamo `m` elementov), ga razbijemo na dve vozlisci:
    - dolocimo sredinski `floor(m/2)` - ti elementi med `m` elementi 
    - `floor(m/2)-1` elementov, ki so manjsi od sredinskega elementa, damo v novo levo vozlisce.
    - `m - floor(m/2)` elementov, ki so vecji od sredinskega elementa, damo v novo desno vozlisce.
    - sredinski element dodamo one level up, in ce pridemo do konfliktov, ponovimo vse postopke :)))).
  - Casovna zahtevnost : `O(logn)`


- **Brisanje**: Element brisemo iz vozlisca na zadnjem nivoju. Pri brisanju elementa, ki **ni** na zadnjem nivoju, ga nadomestimo s **predhodnikom** (z najvecjim elementom ustreznega levega poddrevesa), ki da dejansko zbrisemo. Postopek:
  - Če vozlišče, kjer smo element zbrisali, vsebuje dovoljeno število elementov (vsaj  `floor(m/2) - 1` za koren zadošča 1), je postopek končan.
  - Če vozlišče sedaj vsebuje premalo (`floor(m/2) - 2`) elementov, potem:
    - Eden izmed sosednih bratov (levi ali desni) vsebuje dovolj elementov, da
  si jih razdelita med seboj – v tem primeru se od brata vzame enega ali
  več elementov skupaj z ustreznimi poddrevesi in z zamenjavo
  ustreznega elementa pri očetu. Sepravi ce uzamemo od levega brata, damo max element gor k ocetu, tistega, ki pa je bil do zdaj v root nodeu, premaknemo v tisti node, kjer smo element brisali.
    - Če **nobeden** od bratov nima dovolj velikega števila elementov, imamo
  dva brata (en `floor(m/2)` -1 in drugi `floor(m/2)`-2 elementov), ki ju skupaj z
  ustreznim elementom v očetu lahko združimo v eno vozlišče, ki ima `<= m - 1`
  elementov.
  Postopek brisanja zatem rekurzivno ponovimo pri očetu.
- Povperecna casovbn zahtevnost `O(logn)`
  ```
  Primercek deletanja(delet 16)
                                  [12 | ]
                                  /   |
                  ---------------     |
                /                     \
            [3 | 9]                 [18 | ]
           /   |    \               /   |
       [2 | ] [8 | ] [10 | ]     [16| ] [19| ]

                                    [12 | ]
                                  /   |
                  ---------------     |
                /                     \
            [3 | 9]                 [18 | ] (prazno vozlisce zdruzimo skupaj z desnim bratom, skupaj z ustreznim elementom od oceta)
           /   |    \               /   |
       [2 | ] [8 | ] [10 | ]     [ | ] [19| ]

                                  [12 | ]
                                  /   |
                  ---------------     |
                /                     |
            [3 | 9]                 [ | ]
           /   |    \                 |
       [2 | ] [8 | ] [10 | ]       [18|19]

                                  [9 | ]
                                  /   |
                  ---------------     |
                /                     |
            [3 |  ]               [12 | ]
           /   |                /      \
       [2 | ] [8 | ]        [10| ]    [18|19]

  ```
- ce ti ni jasno: https://www.youtube.com/watch?v=GKa_t7fF8o0


## ADT DIGRAPH
Usmerjeni graf je podan z mnozico vozlisc `V` in mnozico povezav `E` `G=<V, E>`

Povezava je **urejen** par vozlisc:
  - prvemu vozliscu pravimo **zacetek** povezave, drugemu pa konec povezave.
  - Zacetek in konec povezave je lahko isto vozlisce

**Izstopna stopnja**(outdegree) vozlisca `v` je stevilo povezav, ki imajo to vozlisce kot svoj zacetek.

**Vstopna stopnja** (indegree) vozlisca `v` je stevilo povezav, ki imajo to vozlisce kot svoj konec.

Graf je **poln** (fully connected), ce je vsako vozlisce povezano z vsakim dugim vozliscem(vkljucno s samim seboj) `n*2` povezav.

**Pot** (path) v grafu (`G=<V,E>`) je zaporedje vozlisc `v_1, ... v_k`, tako da velja:
  - `v_i` je vsebovan v `V`
  - `<v_i, v_i+1>` je vsebovan v `E`

Pot je **enostavna** ce se vsako vozlisce na poti ponovi samo enkrat - sicer imamo cikel.

**aciklicen graf** --> graf brez ciklov

Vozlisce `v_k` je  **dosegljivo** iz v_1, ce v grafu obstaja pot `v_1, ... v_k`.

**drevo** je usmerjeni aciklicni graf, kjer je vsako vozlisce dosegljivo iz korena po natanko eni poti

**podgraf** danega grafe `G=<V,E>` je graf `G'=<v',E'>`, tako da je `v'` podmnozica `V` in `E'` podmnozica `E`.

Za ocenjevanje casovne zahtevnosti algoritmov na fraf

### Operacije nad usmerjeni grafi
- MAKENULL(G) ~ naredi prazen usmerjen graf `G` `O(1)`
- INSERT_VERTEX(v, G) ~ doda vozlisce v graf `G` `O(1)`
- INSERT_EDGE(v1, v2, G) ~ doda povezavo `<v1, v2>` v graf `G` `O(1)`
- FIRST_VERTEX(G) ~ vrne prvo vozlisce v grafu `G` `O(1)`
- NEXT_VERTEX(v, G) ~ vrne naslednje vozlisce v  grafu `G` `O(1)`
- FIRST_EDGE(v, G) ~ vrne prvo povezavo v grafu `G` z zacetkom `v` `O(1)`
- NEXT_EDGE(e,v,G) ~ vrne naslednjo povezavo dane povezave `e` z  zacetkom `v` po nekem vrstnem redu `O(1)`
- END_POINT(e, G) ~ vrne konec povezave `e` v grafu `G` `O(1)`

Usmerjeni graf ucinkovito implemenitramo s **seznamom sosednosti** (adjanceny list)
- vozlisca hranimo v seznamu
- vsako vozlisce ima seznam povezav, ki vodijo iz vozlisca
- vsaka povezava hrani se kazalec na konec povezave

### Neusmerjeni graf
Podoben kot digraf, z nekaj izmemami

Povezava je **neurejen** par vozlisc:
  - vozlisci sta dva **konca** povezave
  - povezani vozlisci sta **sosedni** (adjacent)
  - dva konca povezave sta **razlicni** vozlisci
  

**stopnja vozlisca** `v` je stevilo povezav, katerim je to vozlisce eden od koncev (stevilo sosedov

graf je **poln** (fully connected), ce je vsako vozlisce povezano z vsakim drugim vozliscem (**sam s seboj ne more biti**)

### Operacije nad neusmerjenimi grafi
- MAKENULL(G) ~ naredi prazen usmerjen graf `G` `O(1)`
- INSERT_VERTEX(v, G) ~ doda vozlisce v graf `G` `O(1)`
- INSERT_EDGE(v1, v2, G) ~ doda povezavo `<v1, v2>` v graf `G` `O(1)`
- FIRST_VERTEX(G) ~ vrne prvo vozlisce v grafu `G` `O(1)`
- NEXT_VERTEX(v, G) ~ vrne naslednje vozlisce v  grafu `G` `O(1)`
- FIRST_EDGE(v, G) ~ vrne prvo povezavo v grafu `G` z zacetkom `v` `O(1)`
- NEXT_EDGE(e,v,G) ~ vrne naslednjo povezavo dane povezave `e` z  zacetkom `v` po nekem vrstnem redu `O(1)`
- ADJECENT_POINT(e, v, G) ~ vrne drugi konec povezave e v grafu `G` z enim koncem v `v` `O(1)`

Implementiramo ga kot usmerjeni graf, kjer je vsaka povezava podvojena (dvosmerna):
```
        /  /              /  /
     /        /        /        /
    /          /------/          /
    /          /      /          /
     /        /        /        /   
        /  /              /  /

        /  /              /  /
     /        /        /        /
    /          /----->/          /
    /          /<-----/          /
     /        /        /        /
        /  /              /  /
```

## Disjunktne mnzoice
Mnozico elementov zelimo razbiti na disjunktne podmnozice glede na neko relacijo med elementi.

Gradimo mnozice od spodaj navzgor
- Vsak element je ena podmnozica
- Manjse podmnozice zdruzujemo v vecje podmnozice, ce so elementi iz ene in druge podmnozice v dani relaciji

Za vsak element mormo vedeti kateri podmnozici pripada.

### Operacije:
- MAKENULL(S) ~ generira prazno mnozico mnozic S `O(1)`
- MAKESET(x, S) ~ tvori novo mnzoico `{x}` in jo doda v S `O(1)`
- UNION(A1, A2, S) ~ zdruzi dve disjunktni podmnozici A1 in A2 v novo podmnozico. `O(1)`
- FIND(x, S) ~ vrne podmnozico, katere element je `x` 

Find operacija ima zabavno casovno kompleksnost --> na dolgi rok, m operacij v povprecju `(m \alpha (m,n) \aprrox O(m)) ` Sledi ackermanovi funkciji ~ `O(m)`.
Sepravi ker je rekurzivnih klicov `m` in je `m <<< n`. `m` tretiramo kot konstantno in lahko predpostavimo, da ima operacija FIND `O(1)` casovno zahtevnost.

#### Implementacija z gozdom
- vsaka mnozica je drevo
- vsak element kaze na oceta v drevesu
- koren kaze sam nase
- mnozica je identificirana s korenom

Za ucinkovito implementacijo, vozlisce potrebuje st. elementov poddrevesa:

```java
public class DisjointSubset {
  Object value;
  DisjointSubset parent;
  int noNodes; // moc podmnozice
}
```

Operacija MAKESET iz enega elementa `x` tvori mnzoico `{x}` --> `O(1)`
```java
public DisjointSubset makeset(Object x) {
  DisjointSubset newEl = new DijsointSubset();
  newEl.value = x;
  newEl.noNodes = 1;
  newEl.parent = newEl;
  return newEl;
}
```
Operacija FIND(X): vrne mnnozico(t.j. koren drevesa), ki ji pripada element `x`. Ce je drevo izrojeno, je plezanje
do korena lahko reda `O(n)`. Da se izrojenosti na dolgi rok izognemo, vsa vozlisca na poti prevezemo na koren:

Ackermanova funkcija ce te zanima zakaj :kekw:
```java
public disjointSubset find(DisjointSubset x) {
  if(x == x.parent)
    return x;
  else {
    x.parent = find(x.parent); // prevezava
    return x.parent; // in hkrati rezultat
  }
}
```

`O(n)` -> `O(1)`
```
FIND (d):

    a
    ^                                a    
    |                              / | \ 
    b       ===>                  d  c  b
    ^                                    \
    |                                     i
    c
   /  \
  d    e
```
Operacija UNION: Koren ene podmnozice prevezemno na koren druge. Ker zelimo cimmanj izrojeno drevo, vedno prevezemo manjso mnozico na vecjo.

Ce ignoriramo finde, je casovna zahtevnost `O(1)`.
```java
public void union(DisjointSubset a1, DisjointSubset a2) {
  DisjointSubset s1 = find(a1);
  DisjointSubset s2 = find(a2);

  if(s1.noNodes >= s2.noNodes) {
    s2.parent = s1;
    s1.noNodes += s2.noNodes;
  } else {
    s1.parent = s2;
    s2.noNodes += s1.Nonodes;
  }
}
```


## Analiza kriticne poti
Basically isces najdaljso pot od zacetka do konca. To je NP hard problem :tipspepe:. 
No pa pejmo skozi dinamicen alogritem(predpostavimo da ni ciklov!):
- Graf pregledujemo od zacetka proti koncu
- Hranimo seznam vozlisc, za katere smo pregledali ze vse poti do njih, nismo pa se pregledali njihovih naslednikov
- za vsako vozlisce hranimo cas maksimalne poti, ki vodi do njega
- zato, da ugotovimo, ce smo pregledali vse poti, ki vodijo do vozlica, potrebujemo vstopno stopnjo vozliscam ki se med iskanjem zmanjsa ob pregledu vsake nove poti
- ce zelimo izpisati se kriticno pot, shranimo se predhodnika na maksimalni poti

### inicializacija
- izracunamo vstopne stopnje vseh vozlisc, postavimo zacetne case/razdalje na 0;

```java
class ValueType {
  String name;
  int inDegree;
  Vertex parent; // kazalec na predhodnika
  double time; // alpa dist
}
```
Algorithm:
```java
// a - zacetno vozlisce, c - zakljucno vozlisce
public double tDynimic(Vertex a, Vertex c, DiGraph g) {
  Vertex v, w;
  Edge e; // povezava <v, w>
  List<Vertex> ls = new LinkedList<>(); // seznam vozlisc, katerih naslednikov se nismo pregledali

  Object pos;

  ls.insert(a);

  while(!ls.empty()) {
    pos = ls.first(); // izberemo kr prvega
    v = (Vertex)ls.retrieve(pos); //  we doo the same thing
    ls.delete(pos);  // pa ga odstranimo iz seznama

    // poberemo prvo povezavo, iz elementa katerega smo pobrali iz seznama
    e = g.firstEdge(v);
  

    while(e != null) {
      w = g.endPoint(e); // vrne vozlisce, ka katerega kaze e
      // preveri ce ima vozlisce ma katerega kaze e mmanjsi cas kot kot vozlisce iz seznama + vozlisce e
      if(((ValueType)w.value).time < ((ValueType)v.value).time + ((Double)e.value).doubleValue()) {
        // ce ima, mu nastavimo to
        ((ValueType)w.value).time = ((ValueType)v.value).time + ((Double)e.value).doubleValue();
        ((ValueType)w.value).parent = v; // mu nastavimo se pointer na parenta
      }
      ((ValueType)w.value).inDegree--; // ker smo pregledali eno pot do w, ji count zmanjasmo
      if(((ValueType)w.value).inDegree == 0) {
        // ce smo pregledali use poti do w, je w naslednji kandidat za pregledovanje
        ls.insert(w);
      }
      e = g.nextEdge(v, e);
    }
  }
  // konci cas / pot nas caka v zakljucnem vozliscu
  return ((ValueType)c.value).time;
}
```
**Inicialzizacija** grafa ima zahtevnost `O(n+m)`
- izracunamo vstopne stopnje vseh vozlisc
- postavimo zacetne case za vsa vozlisca na 0
- sepravi sprehod preko vseh vozlisc `n` in vseh povezav `m`

Casovna zahtevnost algoritma za iskanje kriticne poti z dinamicnim programiranjem je `O(n+m) = O(m)`

  - pregledamo vse povezave (m) in vsa vozlisca (n)
  - ker je graf povezan, velja `n-1 <= m`

Izpis kriticne poti
```java
w = c;
while(w!=a) {
  v = ((ValueType)w.value).parent;
  e = g.firstEdge(v);

  while(g.endPoint(e) != w)
    e = g.nextEdge(v, e);
  
  System.out.println("<" + v + ", " + w ", " + e + ">");
  w = v;
}
```

## DIJKSTRA
Gradimo vpeto drevo od zacetnega vozlisca, ki je koren do vpetega devesa, proti listom. Vsakic iz mnozice vozlisc, ki se niso v drevesu izberemo tisto z najkrajso potjo od
zacetnega vozlisa - pozresno (greedy). To zagotavlja, da ne obstaja krajsa pot od zacetnega vozlisca do `v` preko nekega drugega vozlisca `w`, ki se ni v drevesu.

Ko vozlisce dodamo, pregledamo njegove naslednike:
- ce je naslednik ze v drevesu, ga ignoriramo
- ce je ze v prioritetni vrsti, eventuelno zmanjsamo prioriteto
- sicer ga vstavimo v prioritetno vrsto

Za izbiro vozlisca `v` z najkrajso potjo uporablja algoritem prioritetno vrsto vozlisc, za katera je ze znana dozlina vsaj ene poti od zacetnega vozlisca `a`.
V prioritetni vrsti se hranijo dolzine **najkrajsih** znanih poti za vsako vozlisce
Za napredovanje algoritme se te poti lahko skrajsajo, zato je potrebno uvesti se operacijo zmanjsanja prioritete.

Za zmanjsevanje prioritete definiramo novo funkcijo DECREASE_KEY(x, new, Q):
  - zmanjsa prioriteto elementa `x` na `new`
  - v kopici operacijo implementiramo tako, da element z zmanjsano prioriteto zamenjujemo z ocetom
  - postopek se ustavi, bodisi ce je oce manjsi od elementa ali ce element pride v koren kopice
  - casovna zahtevnost je reda `O(logn)` pod pogojem, da imamo direkten dostop do elementa v kopici

#### Operacije nad prioritetno vrsto v dijkstrinem algoritmu
```
O(n * (insert + delete_min(find, pazi hash table!)) + m * decrease_key(rebalance)))
```


**Vsako** vozlisce hrani svoj polozaj (indeks) v kopici.
```java
class DijkstraVertex {
  boolean visited;
  DijkstraVertex parent;
  double distance;
  int heapIndex;
}
```
Algoritem:
- Vsako vozlisce dodamo in izbrisemo iz prioritetne vrste, torej `n` operacij INSERT in `n` operacij DELETEMIN
- notranja zanka gre preko vseh povezav, torej se izvrsi `m`-krat (ena izvrsitev zahteva bodisi INSERT bodisi DECREASEKEY ali pa nobene od teh operacij)
- ce implementiramo prioritetno vrsto s kopico, potem je casovna zahtevnost v najslabsem primeru reda `O(2nlogn + mlogn) = O((n+m)logn)`
- Ker za povezan graf velja `m >= n -1`, je casovna zahtevnost algoritma reda `O(mlogn)`
- je pozresen, vendar vseeno zagotavlja optimalno resitev

```java
public void dijkstra(DijkstraVertex a, DiGraph g) {
  // rezultat sta za vsako vozlisce 'parent' in 'distance'
  PQDecrease q = new HeapPos(); // prioritetna vrsta vozlisc
                                // urejena po distance
  Edge e; // treuntna povezava
  DijkstraVertex v, w; // trenutno vozlisce in njegov naslednik

  // nobeno vozlisce se ni v prioritenti vrsti
  for(DijkstraVertex t=(DijsktraVertex).g.firstVertex();
      t!=null;
      t=(DijsktraVertex)g.nextVertex(t)) {
    t.visited = false;
  }
  // pripravi zacetno vozlisce in prioritetno vrsto
  a.visited = true;
  a.parent = null
  a.distance = 0.0;
  q.insert(a);

  // oke zacnimo z algoritmom brt
  while(!q.empty) {
    v = (DijkstraVertex).q.deleteMin(); // uzamemo najcenejsega iz prioritetne vrste
    e = g.firstEdge(v);
    while(e != null) {
      w = (DijkstraVertex).g.endPoint(e); // naslednik vozlisca v

      if(!w.visited) {
        // uredi w in dodaj v prioritetno vrsto
        w.visited = true;
        w.parent = v;
        w.distance = v.distance + ((Double)e.value).doubleValue();
        q.insert(w);
      } else if(v.distance +
                ((Double)e.value).doubleValue() <
                w.distance 
              ) {
        w.parent = v;
        q.decreaseKey(w, new Double(v.distance + ((Double)e.value).doubleValue()));
      }
      e = g.nextEdge(v,e);
    }
  }  
}
```

## PRIMOV algoritem
Je pozresen in zelo podoben algoritmu Dijkstra(le da je graf neusmerjen). Gradimo MST od poljubnega zacetnega vozlisca. Vsakic iz mnozice vozlisc, ki se niso v drevesu, izberemo tisto z najkrajso povezavo od nekega vozlisca v **MST**.
Zatem pogledamo sosede dodanega vozilsca:
- ce je sosed ze v MST, ga ignoriramo
- ce je sosed ze v prioritetni vrsti, mu posodobimo prioriteto
- sicer ga dodamo v prioritetno vrsto

Za izbiro vozlisca `v` z najkrajso razdaljo, uporablja algoritem prioritetno vrsto vozlisc, za katera je ze znana dolzina povezave od nekega vozlisca v MST.
V prioritetni se heranijo dolzine najkrajsih povezav za vsako vozlisce. Z napredovanjem algoritme se te povezave lahko skrajsajo, zato je potrebno tudi skrbeti za zmanjsevanje prioritete.

#### Operacije nad prioritetno vrsto v primovem algoritmu
```
O(n * (insert + delete_min(find, pazi hash table!)) + m * decrease_key(rebalance)))
```

```java
class PrimVertex extends Vertex {
  boolean visited; // obiskan
  boolean intree; // je ze v drevesu
  PrimVertex parent; // hranimo pointer, za se sprehodit po rezultatu algoritma
  double distance;
  int heapIndex;
}
```
Algortim `O(mlogn) ~ greedy`:
```java
public void prim(UGraph g) {
  PQDecrease q = new HeapPos(); // urejena po razdaljah
  Prim vertex v, w;
  Edge e;

  // nobeno vozlisce se ni bilo pregledano
  for(PrimVertex t = (PrimVertex)g.firstVertex();
      t! = null;
      t = (PrimVertex)g.nextVertex(t)) {
        t.visited = false;
      }
  // inicializiraj prvo vozlisce in ga dodaj v prioritetno vrsto
  v = (PrimVertex)g.firstVertex();
  v.visited = true;
  v.parent = null;
  v.intree = false;
  v.distance = 0;
  q.insert(v);

  while(!q.empty()) {
    v = (PrimVertex)q.deleteMin();
    v.intree = true;
    e = g.firstEdge(v);

    while(e != null) {
      w = (PrimVertex)g.adjacentPoint(e, v);

      // ce ga se nismo obiskali, ga dodamo v kopico
      if(!w.visited) {
        w.visited = true; // je v kopici
        w.intree = false; // ni se v drevesu
        w.parent = v; // potencialni oce
        // trenunta najkrajsa povezava do drevesa
        w.distance ((Double)e.value).doubleValue();
        q.insert(w);
      } // ce element se ni v drevesu preverimo ce je slucajno povezava cenejsa kot ta v e
      else if (!w.intree && ((Double)e.value).doubleValue() < w .distance) {
          w.parent = v; // novi potencialni oce
          q.decreaseKey(w. e.value); // popravi ceno v prioritetni vrsti
      }

      e = g.nextEdge(v, e); // se sprehodimo naprej po grafu
    }
  }
}
```
## KRUSKALOV algoritem
Gradi minimalni vpeti gozd, uporaben tudi za nepovezane grafe.
Na zacetku je vsako vozlisce svoje drevo. V enem koraku v gozd dodamo najkrajso povezavo - zdruzimo dve razlicni drevesi v eno (brez ciklov!)

Basically v enem koraku algoritma z najkrajso povezavo zdruzi dve drevesi v enega.

- Na zacetku je vsako vozlisce svoje drevo. 
- Na zacetku vse povezave damo v prioritetno vrsto.
- v enem koraku najkrajso povezavo dodamo v **minimalni vpeti gozd** (MSF), ce povezuje
razlicni drevesi(stevilo dreves se vsakic zmanjsa za 1)
- devo je mnzoica vozlisc -> ADT disjunktne mnozice.

Ker je kruskalov algoritem, bascically samo algoritem nad mnzoico elementov, potrebujemo samo spremeniti nekaj operacij v ADT GRAFU,da bodo vracali elemente iz mnozic.

#### Operacije nad prioritetno vrsto v kruskalovem algoritmu
```
O(m * (insert + delete_min(find, pazi hash table!)))
```

### GRAPH -> KGRAPH
- MAKENULL(G) ~ naredi prazen graf
- INSERT_VERTEX(v, G) ~ doda vozlisce v graf G
- INSERT_EDGE(v1, v2, G) ~ doda povezavo `<v1, v2>` v graf `G`
- FIRST_VERTEX(G) ~ vrne prvo vozlisce v grafu `G`
- NEXT_VERTEX(v, G) ~ vrne naslednje vozlisce danega vozlisca `v` po nekem vrstnem redu v grafu G
- FIRST_EDGE(G) ~ vrne prvo povezavo v grafu `G`
- NEXT_EDGE(e, G) ~ vrne naslednjo povezavo dane povezave `e` v grafu `G` po nekem vrstnem redu.
- ENDPOINTS(e, G, v1, v2) ~ vrne oba konca, `v1` in `v2` povezave

```java
public class Kedge extends Edge {
  KVertex v1, v2;
  Kedge nextEdge;
  boolean inForest; // rezultat algoritma
}
```
Algoritm `O(m log m)`:
```java
public void kruskal(KGraph g) {
  KruskalVertex v1, v2;
  DisjointSubset s1, s2; // dve disj. podmnozici - poddrevesi
  // inicializcija disjunktnih mnzoizic vozlisc
  // ena mnozica je vpeto drevo
  DisjointSet dSet = new DisjointSetForest();

  for(KruskalVertex t = (KruskalVertex)g.firstVertex();
      t != null;
      t = (KruskalVertex)g.nextVertex(t)) {
        t.subset = dSet.makeset(t);
      }
  // inicializacija prioritetne vrste povezav
  PriorityQueue q = new Heap(); // urejena po value
  KruskalEdge e;

  for(e (KruskalEdge)g.firstEdge();
      e != null;
      e = (KruskalEdge)g.nextEdge(e)) {
        q.insert(e);
        e.inForest = false;
      }
  // zgradi minimalni vpeti gozd
  // ce je graf povezan, zgradi minimalno vpeto drevo
  while(!q.empty()) {
    e = (KruskalEdge)q.deleteMin(); // poberi najcenejsega iz prioritetne vrste
    v1 = (KruskalVertex)g.endPoint(e);
    v2 = (KruskalVertex)g.endPoint(e);
    // doloci poddrevesi obeh vozlisc
    s1 = dSet.find(v1.subset);
    s2 = dSet.find(v2.subset);

    if(s1 != s2) {
      dSet.union(s1, s2);
      e.inForest = true;
    }
  }
}
```

## DOKAZOVANJE PRAVILNOSTI PROGRAMOV (najbol izi snov tbh :wink:)

!!! Vse narobe !!! (popravki dobrodosli)

### Formalizacija
Program definiramo kot preslikavo:

  `f: X ---> Z` ,

ki preslika vhodne podatke `<x1, .., x_n> \in X` v izhodne podatke `<z1, .., z_n>. Pri tem morajo 
vhodni podatki izpolnjevati zacetni pogoj:

`\theta(x1, ... x_n)`

Izhodni podatki, pa morajo izpolnjevati zakljucni pogoj:

`\idk(z1, ..., z_n, x1, ... , x_n)`

Pravimo, da je program:
- **parcialno pravilen**, ce v primeru, da se za vhodne podatke, ki izpolnjujejo zacetni pogoj, ustavi, izhodni podatki pa izpolnjujejo zakljucni pogoj.
- **totalno pravilen**, ce je parcialno pravilen, in ce se za vse vhodne podatke, ki izpolnjujejo zacetni pogoj, po koncnem stevilu korakov ustavi.

Pri dokazovanju pravilnosti programa iz pogojev P, ki veljajo pred izvrsevanjem stavka, izpeljemo pogoje `Q`, ki veljajo po izvrsitvi stavka.
```
// P(Y)
Stavek;
// Q(Y)

Prireditev:
// P(izraz)
y = izraz;
// P(y)

Izbira:
// P(y)
if(Pogoj(y))
  // P(y) & Pogoj(y)
else
  // P(y) & !Pogoj(y)

Zaporedje:
// P_0(y)
{S1; S2; ... ; Sk}
// P_k(y)
--> pri cemer velja
// P_(i-1)(y)
Si;
// Pi(y)

```
- https://www.youtube.com/watch?v=5eGsdrdeBQ8
- https://www.youtube.com/watch?v=3YP6NP1_tF0

```java
//Conditionals

max(x, y) {
  tmp = x; // tmp == x
  if(y > tmp) // if y > tmp (where tmp == x)
    tmp = y; // then tmp == y (ow tmp == x)
  return tmp; // returns max(x, y)
}

// Loop invariant --> tmp = sum from i=1 to n A[j]
// base case: i == 1, tmp == A[1]
// prove that it holds on the i + 1st;
// induction my friend
// termination when i = n
avg(A[n]) {
  tmp = 0;
  for(i in n) {
    tmp = tmp + A[i];
  }
  return tmp/n;
}
```
Primeri iz starih izpitov
```java
// Dan je algoritem za sestevanje dveh nenegativnih celih stevil, ki uporablja operacijo inkrementa
public static int sum(int x, int y) {
  // phi(x >= 0, y >= 0)
  int i, s;
  s = 0;
  i = 0;

  // zancna invarianta
  // s = i, i <= x
  while(i != x) {
    i++;
    s++;
  }

  i = 0;
  // zancna invarianta
  // s = x + i, x + i <= y
  while(i != y) {
    i++;
    s++;
  }

  return s;
}
// psi(x >= 0, y>=0, i = y, s = x + y)
```

```java
// basically iskanje z bisekcijo, maxX je stevilo elementov v tabeli
boolean vsebovan(int y, int x[]) {
  // phi(every i in x[]: x[i] in N, 0 < i <= maxX, y in N, x[i] < x[i + 1])
  int min, max, s;

  max = maxX;
  min = 1;

  // Zancna invarianta
  //(y is element x[] => x[min] <= y <= x[max])
  while(min < max) {
    s = (int) ((min + max) / 2)

    if(y > x[s])
      min = s + 1;
    else
      max = s;
  }

  if(x[min] == y)
    return true; // psi x[min] == y ==> true
  else
    return false; // psi x[min] != y ==> true
}
```
