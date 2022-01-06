# APS

### STACK
Elemente vedno dodajanmo na vrh sklada, in jih tudi brisemo iz vrha sklada
Skladu pravimo tudi LIFO vrsta (last in first out)
#### Operacije v slkadu
- MAKENULL(S) ~ naredi prazen sklad
- EMPTY(S) ~ preveri ce je sklad prazen
- TOP(S) ~ vrne zadnji element iz sklada
- PUSH(x, S) ~ vstavi element x na vrh sklada
- POP(S) ~ zbrise vrhni element iz sklada

### REKURZIJA
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
### ANALIZA CASOVNE KOMPLEKSNOSTI

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
#### Ocena dejanskega casa izvajanja
`T(n) = a * O(g(n)) + c`
Postopek:
- najprej izracunas `a` in `c`, tako da izberes tisto matematicno funkcijo`g(n)`, katera se ti zdi najbolj primerna in v njo ustavis `n` pa enacis s casom izvajanja
- ko imas `a` in `c`, izracunas `T(n)` s pomocjo dobljenega `a`-ja in `c`-ja pa matematicne funkcije `g(n)`. Ce se cas ujema --> success :)

### ADT ENOSMERNI SEZNAM S KAZALCI

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


### ADT DVOSMERNI SEZNAM S KAZALCI
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
