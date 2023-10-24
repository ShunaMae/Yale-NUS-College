## Multi-Locus Phylogenetics and Coalescent Theory 
What is the best way to carry out the multi-locus phylogenetics? 

#### Concatenation
combination of multiple loci (both nDNA and mtDNA)to get a 'total DNA evidence' tree 

However, this forces the SNP information from all loci to be derived from a single evolutionary trajectory 

We can improve it by appplying different evolutionary models to each locus under maximum likelihood 

Species tree ... true tree
Gene tree ... tree derived from gene topology 

**Gene tree heterogeneity ... the different patterns that gene trees can show. They may derive from different ancestory in loci (e.g., hybridization), or poor information \
** deep coalescence (incomplete lineage sorting, ILS) ... chimp and bonobo, where about 3% of the genome show incorrect gene trees 

(The bonobo genome compared with the chimpanzee and human genomes)

#### Hemiplasy

aaaaaaabbb \
aaaabb|abb \
aaaabb|bbb \
aaa|bb|bbb 

### Species Tree Methods 

#### Deep coalenscence method 
Still takes multiple loci, but build gene trees independently and combine them later to produce species tree 
- too much trust on the gene tree estimation on each loci 

#### Gene tree parsimony method / Consensus tree method
consider bootstrap values as well but estimate gene trees independently

#### Modern species tree methods 
BEST (Bayesian Estimation of Species Tree), *BEAST, ... etc. They are all based on coalescence theory

In coalescene theory, we compute back in time to where they coalesce between individual A and B to estimate 

- species tree divergence (=/tauAb) ... the time when the gene trees diverged between A and B
- ancestral effective population sizes (=/thetaAB) ... correlates with the genetic diversity. theta (genetic diversity)= 4 * N (effective population size) * /mu(mutation rate)
- the topology of the tree ... how the species tree diverges

Topology and tau are pretty robust, if you get the same tree. /theta is less robust. 


### Cloudgrams 
allows us to see conflicting stories from individual locus blocks 

### Bayesian Sklyline Plot
tracks the change of effective population sizes across time

### Allele Frequency Spectrum 

see allele in two different population. If the populations are similar (low genetic diversity between), the plot is almost diagnol (high allele freq in one population also shows high allele freq).
If the populations are diverging, the plot will show some L shape. 

(Demographic history and rare allele sharing among human populations)

(Comparative and demographic analyis of orang-utan genomes)

(Insights into hominid evolution from the gorilla genome sequence) ... allows migration between two species/populations. If you allow migration between species, the split time is much earlier

### Approximate Bayesian Computation (ABC) and Similar Modeling Appriaches 
Can test multiple hypothesis that concern time, population size, and topology 

### Coalescent Species delimitation methods
too differentiating \
uses coalescent theory to determine the species delimitation 

(Morphometric, Behavioural, and Genomic Evidence for a New Orangutan Species)



