---
layout: post
title: Training Quantum circuits using group leaders optimization algorithm
---

## Problem setup
Simulate target unitary operation $U_{t}$ using a quantum circuit.

A quantum circuit is composed of unitary gate sequence $U_{a}=\prod\limits_i G_i(\theta_i)$,
where $G_i$ is from a finite gate set $\mathcal{G}$, and $\theta_i$ is the parameter to parametrize it,

What we want to minimize (the **loss**) is "operator fidelity" $\mathcal{F}=\frac{1}{N}\vert{\rm Tr}(U_a U_t^\dagger)\vert$.

## optimize quantum circuit's "genotype"

The **genotype** of quantum circuit is the encoding of its serie of gates, which is a integer/float number sequence here. For example, Daskin introduce the following encoding

* a pool of gates


## Introduction to Genetic Algorithms

The easy way is learn a package [deap](https://github.com/DEAP/deap.git).

Its tutorial can be found [here](http://deap.readthedocs.io/en/master/index.html).

$$

Here, we should be familiar following genetic algorithms.

* **Multiple objective optimization (MOO)**
  * **Strength Pareto Evolutionary Algorithm (SPEA2)**: [Zitzler 2001]
  * **NSGA-II**: [Deb 2002]
  * **MO-CMA-ES**: Multi-Objective version of CMA-ES.


* **Evolution strategy** mutation strength is learnt during the evolution.
* **partical swarm optimization**: PSO optimizes a problem by having a population of candidate solutions, here dubbed particles, and moving these particles around in the search-space according to simple mathematical formulae. The movements of the particles are guided by the best found positions in the search-space which are updated as better positions are found by the particles.

## References
* [Daskin, A., & Kais, S. (2011). Decomposition of unitary matrices for finding quantum circuits: Application to molecular Hamiltonians. Journal of Chemical Physics.](https://doi.org/10.1063/1.3575402)
* [Daskin, A., & Kais, S. (2010). Group Leaders Optimization Algorithm. Molecular Physics, 1(0), 1–18.](https://doi.org/10.1080/00268976.2011.552444)
* Zitzler, E., Laumanns, M., & Thiele, L. (2001). SPEA2 : Improving the Strength Pareto Evolutionary Algorithm, 1–21.
* Deb, K., Member, A., Pratap, A., Agarwal, S., & Meyarivan, T. (2002). A Fast and Elitist Multiobjective Genetic Algorithm :, *6*(2), 182–197.
