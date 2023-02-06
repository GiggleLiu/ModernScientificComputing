---
layout: post
title: Measurement Based Quantum Computation
---
## Quantum Teleportation
Quantum teleportation begins with a quantum state $\vert\psi\rangle$, in Alice's possession,
that she wants to convey to Bob. This qubit can be written generally as 
$$\vert\psi\rangle_M=\alpha\vert0\rangle+\beta\vert1\rangle$$
The subscript $M$ above is used only to distinguish this state from $A$ and $B$, below.

Next, the protocal requires that Alice and Bob share a maximally entangled state.
This state is fixed in advance, by mutual agreement between Alice and Bob,
and can be expressed in Schmidt form $\vert\phi\rangle_{AB}=\frac{1}{\sqrt d}\sum\limits^{d-1}_{i=0}\vert i\rangle\vert i \rangle $ (e.g. any one of Bell states when $d=2$).

In the total system, the state of these three particles is given by $\vert\Psi\rangle=\vert\psi\rangle_M\otimes\vert\phi\rangle_{AB}$.

Then, **Then the projection ${}_{MA}\langle\phi\vert\Psi\rangle=\frac{1}{d}\vert\psi\rangle_B$** (please verify it by your hand). If we proceed to define $\vert\phi(U)\rangle=U^\dagger\otimes I\vert\phi\rangle$, we will have ${}_{MA}\langle\phi(U)\vert\Psi\rangle=\frac{1}{d}U\vert\psi\rangle$.

Now, we let $d^2$ set $\{\phi(U)\}$ form a complete basis (e.g. $\{I,X,Z,XZ\}$ used to perform Bell measurements for $d=2$). For rotated Bell basis, we have the set $\{IU,XU,ZU,XZU\}$, giving out result $C(X)_{AB}C(Z)_{MB}U\vert\Psi\rangle$. 

## Definition of measurement based quantum computation

Measurement Based quantum computation is a universal quantum computation model, because it can realize a set of **universal quantum gates**. In the above teleportation example, we effectively applied $XZ$ gate to $\vert\psi\rangle$, transporting it to another qubit at the same time (viewed as a side effect here). The only required operation is Bell measurement.