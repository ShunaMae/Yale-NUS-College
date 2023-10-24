## Phylogenetics in Practice

Anything below the species level is the domain of population genetics and anything above is phylogenetics 

Phylogenetics 
1. Cladogram ... no information on branch length 
2. Phylogram ... # of mutations 
3. Chronogram ... time lapse 

** for phylogram, the branches can end anywhere. for chronogram, they have to end at the same level unless the species went extinct. 

#### Polytomy 

A node on a phylogeny where more than two lineages descend from a single ancestral lineage

- Hard Polytomy ... a true multifurcation in time 
- Soft Polytomy ... a multifurcation that is a function of insufficient phylogenetic information 
- MRCE ... most recent common ancestor 


#### How to read the trees 

cut-off for bootstrap > 90
if two "sister" species have the bootstrap value of < 90, we can collapse the branch and make them into polytomy 

#### Traits 

1. Apomorphy ... a novel traits (e.g. bird feathers)
   - autapomorphy ... a novel trait not shared with any other lineage (e.g. human speech)
   - Synapomorphy ... a novel trait also present in closely related forms (e.g. human loss of tail)
2. Plesiomorphy .. ancestral trat (e.g. lung)
3. Homoplasy ... independetly derived trait resulting in convergent evolution (e.g. homeothermy in birds and mammals)

- Homologous ... same evolutionary origin (e.g. human arms and bird wings)
- Analogous ... different evolutionary origins but same function (e.g. bird wings and bat wings)
- Paralogy ... pseudogenes, gene duplication. (sometimes the genes get copied and pasted somewhere else in the gene, jut becomes nonfunctional locus in nDNA. If you compare mtDNA and pseudo nDNA, you're not comparing homologous loci)


### Marker Choice for Phylogenetics in the non-NGS era 

#### Gel-band methods (RAPDs, AFLPs, Microsatellites)

Not much for Phylogenetics, still used in Population genetics 
- little information per locus 
- super variability renders them of little use of phylogenetic time scales (mom-kid difference)

#### Organelle DNA 

mtDNA is wildely used in phylogenetics \
we have many copy of mtDNA (nDNA being 2)

MtDNA control region (600-700 bp) is non-coding and has 2-6 times higher evolution rate 
- more often used in pop-gen 
- frequently saturated at phylogenetic level 
  ... the mutation happened too many times that allowed back-mutation and double mutations, divergnce cannot go deeper and we lose information content 

- wide applications at species and genus level, but often saturated at family level 
- Mitochondrion forms one haploid, maternally inherited linkage grop consisting of ~15 genes and ~16 kb 
- if you get multiple locus from nDNA, you get more information about your ancestors 
- if you get multiple locus from mtDNA, you only get information about the mother of the mother of the mother...
- relying on mtDNA can really mislead the analysis (imagine Frank's mother's mother's mother being Chinese, he would come out as a 100% chinese)
- and thus limited window phylogenetic relationships 
- mtDNA is under heavy selection, because they are important in metabolic body functions and are subject to frequent selective sweeps 


#### nDNA 

Alignable nDNA markers generaly are slowly evolving (exons, introns, other non-coding DNA). \
Coding regions are so fast evolving and under selections that they are not even alignable 


#### DNA Barcoding 

CO1 - barcoding gene 
every species shuold be identifiable by a snippet of genes  \
in 2003, Herbet et al proposed a 658 bp region (Folmer region) in the mtDNA gene Co1 as the universal barcode sequence for all animals \
in plants, no such universal barcode has gained wide traction yet (combination of multiple genes)

#### Dating 

BEAST ... software widely used now \

- Fossil calibrations ... use fossils and identify their position in the phylogenetic trees to date the entire tree (no available fossils for inverts and most of birds) 

- earth-historic calibrations ... use island age to date the diversification events (but how early was the migration of the species to the newly-emerged island?)

- molecular clocks ... 2% mtDNA divergence / million years across many tetrapods (mtDNA coding genes). \
  this became troublesome since people started using multiple locus that have different mutation rates. People use average mutation rate nowadays, but the result shows a lot shorter than what you'd see in the traditional dating (1 mil -> 100 thou). So people dont know what we can trust right now.

### Tree-building Methods 

#### Distance methods (Neighbor-joining)

Often based on 'raw p-divergence' (Dxy)
Compare all the pairwise divergence. \
it doesnt consider the SNP trait. \
too simple to be trusted sometimes, but very useful because of convenience. 

#### Maximum Parsimony

The 'cladistic choice' \
Simple, intuitive, assumption-less, occum's raser 
 -> how many mutations do you have to go through to get to the tree? 


#### Maximum Liklihood 

Not all DNAs are the same!
1. Codon position bias ... third gene mutation is cheap. if we see the first position mutation, that's very rare so we have to consider that 
2. mutations at non-coding regions are cheap 
3. Substituion bias 
   - transition (C <-> G, A <-> T) ... cheap 
   - trasversion (C <-> A, T <-> G) ... expensive 
   - purine (A and T)
   - pyrimidine (C and G)

1. base compositional bias 

Assign weights to the genes 

#### Bayesian Inference 

takes maximum liklihood thinking to its reverse (complicated! check the slides later) \
Computationally intensive \
overly optimistic sometimes 





