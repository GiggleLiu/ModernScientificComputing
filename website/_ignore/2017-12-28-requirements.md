---
layout: post
mathjax: true
title: Setup your Jekyll on Github pages
---
# SDN

## Problem Description

* A graph $G$ with degree $N=V\vert(G)\vert=40$, $\vert E(G)\vert=?$, number of neighbor $\vert\delta(V_i)\vert\leq 20$.
* 信噪比衰减值$c:E(G)\rightarrow R+$.
* 波数 $K=40$, 带宽 $B=100G$.

Suppose we have a set of tasks $\{T_k(V_{k_1},V_{k_2},B_k)\}, k=1,...,t, t\sim400$, assign each $T_i$ with a undirected path $R_i$, assign each node a port $p:V(G)\rightarrow Z_+^2$ and repeater $r:V(G)\rightarrow0,1$, satisfying the following **contraints** with minimal **cost** $J$.

#### Constraints
* 带宽约束, $n_c\leq 100$.
* 业务不可分割到不同wave传输
* *增加端口时的网元背板约束和上下路约束$G$，给业务分配路径的汇聚约束条件$F(T_1,T_2,T_3,...,T_k,E_i,w_j) = {\rm true}$， 需要考虑风险隔离组，这些函数接口需要保留。*
#### Costs
* 信噪比cost
* 跳波cost:
    * 业务改变传输路线，电交叉
    * 同一波长业务内容改变

#### Questions

* $F,G$ 返回false的几率大吗？是否会成为算法的重要影响因素？
* 尝试过哪些建模和算法？

## Modeling
1. $p,r\rightarrow\{R_k\}$, Hilbert space dimension is $\sim2^{t\vert E(G)}\vert$.
2. $\{R_k\}\rightarrow p,r\rightarrow J$, Hilbert space dimension is $(2N_p^2)^N$ (prefered).

![devide](devide.png)

#### Encoding of structure
Borrow some idea from [Kerschke, P. (2017)](https://arxiv.org/abs/1708.05258).
* graph encoding $\rightarrow$ hard to define crossover $\rightarrow$ nonmating.
* Indirect Encoding
* binary encoding $\rightarrow$ impossible


#### Applying algorithms

Using Exploratory Landscape Analysis (ELA) to tacle Algorithm Selection Problem (ASP). [Bischl 2012]

## Advices on Algorithms and Tools

#### Genetic Algorithm

- multi-objective genetic algorithm (MOGA), maintaining a [Pareto front](https://en.wikipedia.org/wiki/Pareto_frontier).
    * **Strength Pareto Evolutionary Algorithm (SPEA2)**: [Zitzler 2001]
    * **NSGA-II**: [Deb 2002]
    * **MO-CMA-ES**: Multi-Objective version of CMA-ES.

#### Reinforcement Learning

- Markov decision problem: current state $s_k$, action $a_k$ with reward $R(s_k,s_{k+1})$,
  $s_{k+1}$ depends on $s_k$ and $a_k$ but not the whole history, i.e. $s_k,a_k$ seperates the probability graph.
  Here, $s_k\rightarrow $\{R_i\}_{i<k}, \{T_i\}$

#### Traditional Combinatorial Algorithms

- shortest path, spanning tree ...

- maximum flow problem ($s$-$t$-flow), undirected multicommodity flow

  - LP $\rightarrow$ polynomial time.

- minimum cost flow

- Undirected Multicommodity Flow Scheme

  Given a flow network $G(V,E)$, where edge $(u,v)\in E$ has capacity $c(u,v)$.
  There are $k$ commodities $K_{1},K_{2},\dots ,K_{k}$, defined by $K_{i}=(s_{i},t_{i},d_{i})$,
  where $s_{i}$ and $t_{i}$ is the **source** and **sink** of commodity $i$, and $d_{i}$ is its demand.
  The variable $f_{i}(u,v)$ defines the fraction of flow $i$ along edge $(u,v)$,
  where $ f_{i}(u,v)\in [0,1]$ case the flow can be split among multiple paths,
  and $f_{i}(u,v)\in \{0,1\}$ otherwise (i.e. "single path routing"). Find an assignment of all flow variables which satisfies the following four constraints:

  * **(1) Link capacity:** The sum of all flows routed over a link does not exceed its capacity.
  * **(2) Flow conservation on transit nodes:** The amount of a flow entering an intermediate node $a$ is the same that exits the node.
  * **(3) Flow conservation at the source:** A flow must exit its source node completely.
  * **(4) Flow conservation at the destination:** A flow must enter its sink node completely.

- falcility location problem: the position of repeators.


