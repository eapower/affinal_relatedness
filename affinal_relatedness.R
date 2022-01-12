
## requires: kinship2 and igraph (because that's what I know)

## assumes inputs of :
## "parents" with columns Ego, Father, Mother, Sex (here, missing info coded as 0)
## "spouses" with columns Spouse1, Spouse2, and NotDivorced (yeah, stupidly reverse coded to make it easier to populate with 1s)
parents <- read.csv("parents.csv", header = TRUE, as.is = TRUE)
spouses <- read.csv("spouses.csv", header = TRUE, as.is = TRUE)

ped <- kinship2::pedigree(id = parents$Ego, dadid = parents$Father, momid = parents$Mother, sex = parents$Sex, missid = 0)

gen <- kinship2::kinship(ped)*2

## get immediate kin (parent/child and siblings)
imm <- (gen==0.5)*1

## if desired, exclude divorced people (that's how I've coded this). 
## NOTE: this effectively removes the *direct* connection between spouses, 
## but if they have had children, there will still be a value for affinal relatedness:  
## it will be half of what it otherwise would have been, as it will come through the longer path through the child
sp.mar <- subset(spouses, spouses$NotDivorced==1) 

sp.df <- as.data.frame(rbind(as.matrix(sp.mar[,c(1,2,3)]),as.matrix(sp.mar[,c(2,1,3)])))

## create matrix for spousal relationships, and populate with values from sp.df
sp.matrix <- matrix(data = 0, nrow = nrow(gen), ncol = nrow(gen))
rownames(sp.matrix) <- rownames(gen)
colnames(sp.matrix) <- rownames(gen)
  
for(i in 1:nrow(sp.df)){sp.matrix[rownames(sp.matrix)==sp.df[i,1],colnames(sp.matrix)==sp.df[i,2]] <- as.numeric(sp.df[i,3])}

## create matrix with immediate kin and spouses, and then create distance matrix from this
both <- imm + sp.matrix
net <- igraph::graph_from_adjacency_matrix(both)
aff_length <- distances(net)

## recode distance matrix to reflect affinal relatedness (so, spouses = 0.5, and all steps from there halve each time)
aff <- apply(aff_length, 1, function(x) 2^-x)
aff <- aff - gen
