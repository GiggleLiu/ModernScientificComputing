---
layout: post
title: Graph Models
---

Graph Models include two major catagories:
* Bayesian networks (directed graph models)
* Markov random field (undirected graph models)

### An example on Bayesian network

![bayesian_sample](../images/bayesian_sample.jpg)

The left graph is a valid Bayesian network, it represents joint probability $p(A,B,C,D,E,F)=p(B|A)p(E|B)p(C|A,E)p(D|B)p(F|C,D,E)$.

The Beyesian network describes causal relations, so it should not contain a loop (right).

#### example on conditional (in)dependent notation

$a,b$ are **conditional independent** on $c$ mean $p(a,b|c)$ can be reduced to  $const\cdot p(a)p(b)$ form. Means $a,b$ are statistical independant if $c$ is known to us.

1. the condition independant case $a\bot b\vert c$

![](../images/condition-independant.png)

2. the condition dependant case $a\not\bot b\vert c$, because $p(a,b|c)=\frac{p(a,b,c)}{p(c)}=\frac{p(a)p(b)p(c|a,b)}{p(c)}$ can not be reduced to $const\cdot p(a)p(b)$ form.

![](../images/condition-dependant.png)

The above results can be easily obtained using the d-seperation property. Suppose we have seperate sets of nodes $A,B,C$ in a graph, this property states: if all paths from $A$ to $B$ is **blocked** by nodes in $C$, then $A$ is d-seperated $B$ by $C$, so that $A\bot B|C$ . For a directed graph, **block** means

* the arrow on the path meet either head to tail (like in e.g. 1) or tail to tail at a node in $C$.
* the arrow on the path meet either head to head (like in e.g. 2) not in $C$, nor any of its descendants.

### An example on Markov Random Fields


## From Data to Factor Graph

For a tree graph, directed graphs are equivalent to undirected graph. [Kevin Sec. 26]
### data $\rightarrow$ undirected graph: Chow-Liu algorithm
The probability intepretation of a undirected graph is
$$p(\textbf{x}|T)=\prod_{t\in V}\prod_{(s,t)\in E}\frac{p(x_s,x_t)}{p(x_s)p(x_t)}$$
where $V,E$ represent vertex and edge respectively.
### data $\rightarrow$ directed graph: Chow-Liu algorithm
