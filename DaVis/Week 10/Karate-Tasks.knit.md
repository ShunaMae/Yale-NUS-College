---
title: "Zachary's karate-club network"
author: "Team Red"
date: "3/23/2022"
output:
  pdf_document: default
  html_document: default
---



Loading the necessary packages:

```r
library(tidyverse)
library(ggraph)
library(igraph)
library(tidygraph)
library(ggforce)
library(concaveman)
```

(1) Import the data and create an undirected `tbl_graph` called `karate_netw`.

```r
karate_edges <- read_table("soc-karate.zip",
  col_names = FALSE, skip = 24
)

karate_nodes <- tibble(node = 1:34)

karate_netw <- tbl_graph(
  nodes = karate_nodes,
  edges = karate_edges,
  directed = FALSE
)
karate_netw
```

```
## # A tbl_graph: 34 nodes and 78 edges
## #
## # An undirected simple graph with 1 component
## #
## # Node Data: 34 x 1 (active)
##    node
##   <int>
## 1     1
## 2     2
## 3     3
## 4     4
## 5     5
## 6     6
## # ... with 28 more rows
## #
## # Edge Data: 78 x 2
##    from    to
##   <int> <int>
## 1     1     2
## 2     1     3
## 3     1     4
## # ... with 75 more rows
```
(2) How many nodes and edges are in the network?

```r
number_nodes <- gorder(karate_netw) |> print()
```

```
## [1] 34
```

```r
number_edges <- gsize(karate_netw) |> print()
```

```
## [1] 78
```
\Ans There are 34 nodes and 78 edges in the network. 

(3) Are there parallel edges or loops in the network?

```r
is_simple(karate_netw)
```

```
## [1] TRUE
```
\Ans There are no parallel edges or loops in the network. 

(4) Node 1 is the karate instructor. Node 34 is the club president. Add a node attribute called `role` to the `tbl_graph` with the values `Instructor`, `President` and `Other`.

```r
karate_netw <- karate_netw |>
  activate(nodes) |>
  mutate(
    role = case_when(node == 1 ~ "Instructor",
                     node == 34 ~ "President",
                     TRUE ~ "Other")) |>
  print()
```

```
## # A tbl_graph: 34 nodes and 78 edges
## #
## # An undirected simple graph with 1 component
## #
## # Node Data: 34 x 2 (active)
##    node role      
##   <int> <chr>     
## 1     1 Instructor
## 2     2 Other     
## 3     3 Other     
## 4     4 Other     
## 5     5 Other     
## 6     6 Other     
## # ... with 28 more rows
## #
## # Edge Data: 78 x 2
##    from    to
##   <int> <int>
## 1     1     2
## 2     1     3
## 3     1     4
## # ... with 75 more rows
```

(5) Show that the two nodes with the highest degree are the president and the instructor.

```r
karate_netw |>
  mutate(degree = centrality_degree()) |>
  arrange(-degree) |>
  as_tibble() |>
  head(2) |>
  print()
```

```
## # A tibble: 2 x 3
##    node role       degree
##   <int> <chr>       <dbl>
## 1    34 President      17
## 2     1 Instructor     16
```

(6) Find all shortest paths between the instructor and the president.

```r
all_shortest_paths(karate_netw, 1, 34)$res
```

```
## [[1]]
## + 3/34 vertices, from bfbcbd1:
## [1]  1 32 34
## 
## [[2]]
## + 3/34 vertices, from bfbcbd1:
## [1]  1 20 34
## 
## [[3]]
## + 3/34 vertices, from bfbcbd1:
## [1]  1 14 34
## 
## [[4]]
## + 3/34 vertices, from bfbcbd1:
## [1]  1  9 34
```

(7) What is the local clustering coefficient of the instructor? What is the local clustering coefficient of the president? How do you interpret these numbers?

```r
karate_netw |>
  mutate(local_transitivity = local_transitivity())  |>
  filter(role != "Other") |>
  print()
```

```
## # A tbl_graph: 2 nodes and 0 edges
## #
## # An unrooted forest with 2 trees
## #
## # Node Data: 2 x 3 (active)
##    node role       local_transitivity
##   <int> <chr>                   <dbl>
## 1     1 Instructor              0.15 
## 2    34 President               0.110
## #
## # Edge Data: 0 x 2
## # ... with 2 variables: from <int>, to <int>
```
\Ans
The fact that the clustering coefficient for the instructor and president is below 1, it shows that there are a larger number of triplets than triangles that can be formed. Since the instructor has a slightly higher local transitivity, it means that there are slightly more triangles that can be formed (that contain the instructor), compared to the president. 

(8) Which are the largest cliques in the network? Which nodes are in these cliques?

```r
largest_cliques(karate_netw)
```

```
## [[1]]
## + 5/34 vertices, from bfbcbd1:
## [1] 8 1 2 3 4
## 
## [[2]]
## + 5/34 vertices, from bfbcbd1:
## [1]  4  1  2  3 14
```
\Ans One of the largest cliques in the network has the nodes 8, 1, 2, 3, 4, and the other largest clique in the network has the nodes 4, 1, 2, 3, 14.

(9) Confirm that the network is connected (i.e. there is only one component).

```r
count_components(karate_netw)
```

```
## [1] 1
```
\Ans Since there is only one component, the network is connected.

(10) Which communities does the Louvain algorithm detect? Use **tidygraph** to add information about the communities to `karate_netw`.

```r
karate_netw <- 
  karate_netw |>
  activate(nodes) |>
  mutate(community_id = group_louvain(),
         community_name = paste("Community", community_id)) |>
  print()
```

```
## # A tbl_graph: 34 nodes and 78 edges
## #
## # An undirected simple graph with 1 component
## #
## # Node Data: 34 x 4 (active)
##    node role       community_id community_name
##   <int> <chr>             <int> <chr>         
## 1     1 Instructor            1 Community 1   
## 2     2 Other                 1 Community 1   
## 3     3 Other                 1 Community 1   
## 4     4 Other                 1 Community 1   
## 5     5 Other                 4 Community 4   
## 6     6 Other                 4 Community 4   
## # ... with 28 more rows
## #
## # Edge Data: 78 x 2
##    from    to
##   <int> <int>
## 1     1     2
## 2     1     3
## 3     1     4
## # ... with 75 more rows
```
(11) Make a plot similar to figure 1.

```r
karate_layout <- create_layout(karate_netw, layout = "stress")
layout_attributes <- attributes(karate_layout)
node_positions <- read_csv("karate_node_positions.csv")

karate_layout <-
  karate_layout |>
  select(-x, -y) |>
  left_join(node_positions, by = "node") |>
  select(x, y, everything())

attributes(karate_layout) <- layout_attributes

ggraph(karate_layout) +
  geom_edge_link() +
  geom_mark_hull(
    aes(
      x, y,
      fill = community_name,
      description = community_name,
      alpha = 0.5
    ),
    show.legend = FALSE,
    concavity = 3
  ) +
  # set the colours for communities
  scale_colour_brewer(name = "Role", palette = "Set2") +
  geom_node_label(aes(label = node, colour = role)) +
  labs(
    title = "Zachary's Karate Club",
    subtitle = "Communities assigned by Louvain algorithm",
    caption = "Source: https://networkrepository.com"
  ) +
  theme(legend.position = c(0.9, 0.8))
```



\begin{center}\includegraphics{Karate-Tasks_files/figure-latex/unnamed-chunk-12-1} \end{center}

(12) Briefly explain to a reader what the figure reveals about the karate-club network. 

\Ans From the figure, readers understand that there are 4 communities in the karate-club network. Community 2 has the original president (of the karate-club) and community 1 has the original instructor (community 1 has become his new organisation. From the black curve, we also know where the observed split happened between the members of the karate-club, the members that stayed in the old club were mainly from community 2 and 3 (with the exception of 9 and 10). 
