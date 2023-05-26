# KNN
very slow algo:
prostorska zahtevnost: `O(n2)`, casovna `O(m3)`. -> m krat racunas matriko razdalj in povezes dva najblizja primera / clusterja.
pac se da malo pohitrit da prides na `O(m2*logm)`.

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
    - novi voditelji naj bodo centroidi naj bodo centroidi `R_Ci`. -> `RC_i` = $$ (1 / | C_i| )* sum(x) $$

- dokler se lega voditeljev spreminja ali pac setas nek max iter ce zadeva ne konvergira.

### Izbor zacetnih voditeljev

- **Random** ( ampak lahko nas pripelje v stanje nekonvergence -> neoptimalno razbtije) 
    - Temu se izognemo tako, da postopek veckrat ponovimo in med poiskanimi razbijti izberemo najboljse.
- **Razprseni voditelji** poiscemo primer, ki je nabolj oddaljen od vsem. Potem pa poiscemo se k-1 najbolj oddaljenih  temu primeru. To bojo nasi zacetni centroidi
- **Uporabis knn na subsamplu** in potem so tej centrodi dober priblizek originalnim centroidom.


### Izracun silhuete
Ce imamo osamelca, je silhueata 0, drugace se silhueto izracuna tako:

#### Izracun silhuete za en primer
$$ s_i = \frac{(b-a) }{ max(b,a) }$$

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

$$ idf(t) = log \frac{|D|}{|d: t \in d|} $$

Utez posameznega elementa je potem:

$$ tf-idf(t, d) = tf(t, d) \times idf(t) $$

### Kosinusna podobnost
Evklidska razdalja ni gud ker meri samo razdalje v posameznih dimenzijah. Denimo da sta vektorja kratka vendar kazeta v cisto drugo smer.
Njuna razdalja bo majhna, vendar si vektorja nista niti priblizno podobna. Pa tudi ce uzamemo dva vektorja, ki kazeta v isto smer, pa je en 
zelo dolg v vseh dimenzijah. Drugi, pa ima zelo majhne vrednosti. Potem si ne bosta podobna tudi ce oba kazeta v isto smer.
(dolzina vektorja nam obicajno ne pove nic)

Zato se razje zavrzemo k kosinusni razdalji, saj raje meri kot med vektorji kakor razdaljo. Izkaze se da je to boljsa metrika za merjenje razdalj, med visoko dimenzionalnimi
vektorji. 

$$ a b = ||a|| ||b|| cos \theta $$

$$ sim(X,Y) = cos(\theta) = \frac{X Y}{||X|| ||Y||} $$

Kadar imamo opraviti z oznakami (labels) torej ne z besedami besedila, je poleg kosinusne razdalje se smiselno opazovati
tudi podobnost po Jaccardu:

```python
def jaccard(data, k1, k2):
    """jaccard similarity"""
    s1 = data[k1]
    s2 = data[k2]
    return len(s1 & s2) / len(s1 | s2)
```

$$ J(X, Y) = \frac{X \cap Y}{ X \cup Y} $$

# Projekcije in zmanjsevanje dimenzionalnosti podatkov

## PCA

pri PCAju iscemo projekcije iz visjih dimenzij v nizje, tako da ohranjamo varianco med primeri. 

Primer: Ce imamo visoko korelirane 2d primere -> potem jih lahko lepo spravimo v 1d.


$$ S = \frac{1}{m} \sum_{i=1}^{m} (x^{(i)} - \overline{x}) (x^{(i)} - \overline{x}) ^ T $$

$$ Var(u_1^T X^T) =  u_1^T S u_1 $$

Dokaz z uporabo Lagrangeovih multiplikatorjev:


predpogoj:

$$ u_1^T u_1 = 1 $$


minimiziramo:

$$ f(u_1) = u_1^T S u_1 + \lambda_1 (1 - u_1^T u_1) $$

$$ \frac{ \partial f(u_1) } {\partial u_1} = S u_1 - \lambda_1 u_1  = 0 \Rightarrow S u_1 = \lambda_1 u_1 $$

Sepravi iscemo tisti lastni vektor pri najvecji lastni vrednosti:

$$ u_1^T S u_1 = u_1^T \lambda_1 u_1 = \lambda_1 u_1^T u_1 = \lambda_1 $$

### Potencna metoda za iskanje N prvih lastnih vektorjev

Ker je obicajno racunanje SVDja zahteven postpek se zatecemo k optimizcaijskim numericnim metodam.

Pri potencni metodi izkoristimo dejstvo, da ce prvi lastni vektor pomnozimo s kovariancno matriko, se potem vekor ne spremeni (mogoce se malo scalea), ne bo  tudi spremenil svoje orientacije(kota).
Zato najprej inicializiramo nek random vektor, ga pomnozimo s kovariancno matriko in potem ta postopek ponavljamo, dokler ne ta vektor skonvergira do ustavitvenega pogoja. Serpavi
konvergiramo takrat, ko se dolzina vektorja v koraku x ne spremeni vec veliko.

$$ | u_1 | - | u_2 | <= \epsilon $$

Pripadajoco lastno vrednost pa izracunamo na sledeci nacin:

$$ Mu = \lambda u $$

$$ u^T M u = u^T \lambda u = \lambda u^T u = \lambda $$

## MDS (vecrazredno lestvicenje)

Pri MDS iscemo ulozitve, basically iscemo taksne projekcije v nizji prostor, tako, da se razdalje med primeri ohranijo.

Kriterijsko funkcijo sepravi zastavimo takole:

$$ J(X)  = \sum_{i \neq j} (d_{ij} - \delta{ij}) ^2 $$

Kjer $ d_{ij} $ predstavlja, razdaljo med i-tim in j-tim primerom v originalmem prostoru. $ \delta_{ij}$ pa v novem nizje projeciranem prostoru.

Slabost MDS-a je to, da ze ohranjajo tudi razdalje mogoce zelo oddaljenih primerov, kar nam vizualizacijo in interpretabilnost zelo pokvari.


## t-SNE (stohasticna ulozitev sosedov)
Gre za isto metodo kot MDS, kriterijska funkcija pa je nekoliko drugacna.
Tle gledamo samo skupine ki so si blizu. Sepravi razdalje utezimo s pomocjo t-statisticne krivulje. Bolj kot so si primeri blizu, vecjo tezo imajo. Bolj kot so si oddaljeni, manjso tezo imajo.


# Linearna regresija

Kriterijska funkcija (sum of squared errors): 

$$ J(\theta) = \frac{1}{2m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)}) ^2 $$

Gradientni sestop:

$$ \theta_i \leftarrow \theta_i - \alpha \frac{\delta}{\delta \theta_i} J(\theta) $$

Po veriznem odvajanju pridemo do sledecega:

$$ \theta_i \leftarrow \theta_i - \frac{\alpha}{m} \sum_{j=1}^{m} (h_{\theta} (x^{(j)}) - y^{(j)}) x_i^{(j)} $$


### Napovedna tocnost


$$ \text{RMSE} = \sqrt{\frac{{\sum_{i=1}^{n} (y_i - \hat{y}_i)^2}}{n}} $$
$$ R^2 = 1 - \frac{{\sum_{i=1}^{n} (y_i - \hat{y}_i)^2}}{{\sum_{i=1}^{n} (y_i - \bar{y})^2}} $$



### Polinomska regresija
Atribut x razsirimo na:

$$ x^2, x^3, x^4, ... $$
Obicajno se nam z dviganjem stopnje polinoma nas model vedno bolje prilega ucnim podatkom.


### Regularizacija
Kriterijska funkcija (sum of squared errors) dodamo se omejitev, naj se optimizira velikost koeficientov:

#### L1 (Lasso):
$$ J(\theta) = \frac{1}{2m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)}) ^2  + \eta \sum_{j=1}^{n} |\theta_j|$$

#### L2 (Ridge):
$$ J(\theta) = \frac{1}{2m} \sum_{i=1}^m (h_{\theta}(x^{(i)}) - y^{(i)}) ^2  + \eta \sum_{j=1}^{n} \theta^2_j$$

Razlika pri obeh je da Lasso bo spravil nekatere koeficente na cisto 0, Ridge-ovi koeficienti pa ne bodo nikoli cisto na nic. Samo blizu (zaradi kriterija).
