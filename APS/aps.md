# APS

## REKURZIJA
Zahteva vec rezije kot iteracija in je pomnilnisko bol zahtevna od iteracije(sklici se shranijo na stacku). Globina rekurzije = potrebna velikost sklada.
Rekurzivne probleme lahko resujemoo tudi z iteracijami:
- vsako repno rekurzijo lahko zamenjamo z iterativno zanko
- vsak rekurzivni program lahko spremenimo v iterativnega s skladom

### PRETVORBA REKURZIJE V ITERACIJO S SKLADOM

very good article: https://www.cs.odu.edu/~zeil/cs361/latest/Public/recursionConversion/index.html

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

### BINARNO ISKALNO DREVO
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


