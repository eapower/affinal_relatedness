# affinal_relatedness
R code to create an affinal relatedness matrix. 

The resulting adjacency matrix has values of 0.5 for spouses, 0.25 for children/parents-in-law, etc. 

It draws on the kinship2 and igraph R packages. 

It assumes as input: 

- a data frame (called "parents") with columns Ego, Father, Mother, Sex (here, missing info coded as 0)
- a data frame (called "spouses") with columns Spouse1, Spouse2, and NotDivorced (this is an extra)

This was inspired by [Ed Hagen's earlier work](https://github.com/grasshoppermouse/descent) (see the [Descent Shiny App](https://grasshoppermouse.shinyapps.io/descent/)). 

Thanks also to Jonathan Cardoso Silva and others on Twitter for suggestions! This was something Elspeth Ready and I were working around for an earlier publication (see [https://github.com/eapower/Kinship](https://github.com/eapower/Kinship)). 


