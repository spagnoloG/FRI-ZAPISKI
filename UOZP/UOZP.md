# KNN
very slow algo:
prostorska zahtevnost: O(n2), casovna O(m3). -> m krat racunas matriko razdalj in povezes dva najblizja primera / clusterja.
pac se da malo pohitrit da prides na O(m2*logm).

### mere razdalj:

obicanjo si izberemo se kaksno napako bomo merili (razdaljo basically) al evklidsko, al manhatnsko, al..

- single linkage( razdalja med najblizjima primeroma),
    - prednost daje primerkom, ki so si blizje
    (. Single linkage je dober tudi, če so podatki zelo razpršeni in želiš izolirati skupine primerkov, ki so zelo blizu drug drugemu.)
     Uporabi to mero, če želiš detektirati grozde, ki so dolgi in ozki (npr. v obliki črke "U" ali "V").

- complete linkage(razdalja med najbolj oddaljenima primeroma),
    - prednost daje primerkom, ki so si bolj oddaljeni.
     Complete linkage je boljši za odkrivanje kroglastih in kompaktnih grozdov, saj minimizira možnost, 
     da se med seboj zelo različne skupine primerkov združijo v isti grozd.

- average linkage (povprecje razdalj med vsemi primeri), 
    - v splosnem dobra izbira in robustna izbira ali pa Wardova razdalja

# K-means
better friend, works on any size of dataset

( ful je hitrejsi ker sta obicajno K in i ful majhni stevilki, edino m je pac lahko ful velik ampak ne mors primerjat szi knn)
cas zahtevnost O(I * k * m):
    - I je stevilo iteracij
    - k je stevilo prvih centroidov
    - m je stevilo primerov v datasetu 

### algo:
- pricni s K nakljcno izbranimi voditelji `C_1, C_2, C_k`.
- ponavljaj:
    - doloci razvrstitev C tako, da vsak primer priredis najblizjemu voditelju
    - novi voditelji naj bodo centroidi naj bodo centroidi `R_Ci`. -> `RC_i` = (1 / | C_i| )* sum(x)

- dokler se lega voditeljev spreminja ali pac setas nek max iter ce zadeva ne konvergira.

### Izbor zacetnih voditeljev

- **Random** ( ampak lahko nas pripelje v stanje nekonvergence -> neoptimalno razbtije) 
    - Temu se izognemo tako, da postopek veckrat ponovimo in med poiskanimi razbijti izberemo najboljse.
- **Razprseni voditelji** poiscemo primer, ki je nabolj oddaljen od vsem. Potem pa poiscemo se k-1 najbolj oddaljenih  temu primeru. To bojo nasi zacetni centroidi
- **Uporabis knn na subsamplu** in potem so tej centrodi dober priblizek originalnim centroidom.


### Izracun silhuete
Ce imamo osamelca, je silhueata 0, drugace se silhueto izracuna tako:

#### Izracun silhuete za en primer
s_i = (b-a) / max(b,a)

a -> povprecna oddaljenost primera do vseh v istem clusterju
b -> povprecna oddaljenost primera do vseh v najblizjem clusterju temu, v kateremu se primer nahaja.

Ce je b zelo velik:
s => b/b => 1

a obicajno zelimo da je cimmanjsi, b pa zelimo da je cimvecji.

 -1          0           1
----------------------------
(miss) (osamelec) (centroid)

#### Izracun silhuete za celotno razbitje
S = 1 / |U|  * sum (s_i)
Basically normalizirana usota.

Hevristika ni idealna, vendar nam lahko da kaksno idejo kako se problema lotiti.
V primeru nakljucnih podatkov faila. 
Spomni se na smiley face: oci so bli en cluster, usta pa tvorila dva clusterja. Single linkage je to resil najboljse.

```python
def silhouette(el, clusters, data):
    """
    Za element el ob podanih podatkih data (slovar vektorjev) in skupinah
    (seznam seznamov nizov: ključev v slovarju data) vrni silhueto za element el.
    """
    # Find the cluster belonging to the el
    cluster = None
    for c in clusters:
        if el in c:
            cluster = c
            break

    # osamelec 
    if len(cluster) == 1:
        return 0

    # Compute the average distance to the elements in the same cluster
    a_i = 0
    for e in cluster:
        if e != el:
            a_i += cosine_dist(data[el], data[e])
    a_i /= (len(cluster) -1)

    # Compute the average distance to the elements in the closest cluster
    b_i = float("inf")
    for c in clusters:
        if c != cluster:
            b_i_per_cluster = 0
            for e in c:
                b_i_per_cluster += cosine_dist(data[el], data[e])
            b_i_per_cluster /= len(c)
            if b_i_per_cluster < b_i:
                b_i = b_i_per_cluster

    s_i = (b_i - a_i) / max(a_i, b_i)
    return s_i
```

# Razvrscanje besedil

## Elementi predstavitve besedilnih dokumentov

### k-terke znakov
k-terke za n = 2 => murskosoboski -> mu ur rs...
(na podlagi k terk, lahko razpoznamo v katerem jeziku je napisano doloceno besedilo)

### Besede (bow)
- Najprej odstranimo manj pomembne besede kot so (in, ter, ali, ..).
- Vse besede nadomestimo z njihovimi koreni ali pa lemami (lematizacija; postopek ni enostaven in je odvisen od jezika).

(namesto stetja, zaradi razlicnih dolzin dokumentov, uporabimo relativno frekvenco) drugace klasicn bow.

bow zanemarja dejstvo, da je pomen besed mnogokrat odvisen od konteksta. Taksna predsavitev nam ne bomm mogla razresiti problema
podpomenk in drugacnih povezav med razlicnimi izrazi.

### Fraze
K-terke besed, ki se v besedilu nahajajo druga ob drugi ali v bliznji okolici. (Okolico lahko doloca npr. okno zaporedja 5ih besed).
lahko jih uporabimo za bow, da dodamo nekakaksno povezavo med razlicnimi besedami.

### Uporaba oznak
Na spletu so oznaceni tudi dokumenti, pomagajo nam lahko pri treniranju modelov (idk znanstveni clanki, knjige itd).

## Ocenjevanje podobosti med dokumenti

### Transformacija tf-idf
Zaradi razlicnih dolzin dokumentov se raje zavrzemo k pojmu relativne frekvence.
Naceloma imamo raje elemente, ki se pojavijo v manj dokumentih in so zaradi tega bolj specificni.
Zato uporabimo inverse document frequency. Kjer uzamemo logaritem stevila useh dokumentov deljeno s stevilom terma v tem dokumentu.

$ idf(t) = log \frac{|D|}{|d: t \in d|} $

Utez posameznega elementa je potem:

$ tf-idf(t, d) = tf(t, d) \times idf(t) $

### Kosinusna podobnost
Evklidska razdalja ni gud ker meri samo razdalje v posameznih dimenzijah. Denimo da sta vektorja kratka vendar kazeta v cisto drugo smer.
Njuna razdalja bo majhna, vendar si vektorja nista niti priblizno podobna. Pa tudi ce uzamemo dva vektorja, ki kazeta v isto smer, pa je en 
zelo dolg v vseh dimenzijah. Drugi, pa ima zelo majhne vrednosti. Potem si ne bosta podobna tudi ce oba kazeta v isto smer.
(dolzina vektorja nam obicajno ne pove nic)

Zato se razje zavrzemo k kosinusni razdalji, saj raje meri kot med vektorji kakor razdaljo. Izkaze se da je to boljsa metrika za merjenje razdalj, med visoko dimenzionalnimi
vektorji. 

$ a b = ||a|| ||b|| cos \theta $

$ sim(X,Y) = cos(\theta) = \frac{X Y}{||X|| ||Y||}$


# Projekcije in zmanjsevanje dimenzionalnosti podatkov
