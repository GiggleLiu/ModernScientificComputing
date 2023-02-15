1. My CPU has 6 cores with max frequency 2.6 GHz, and it support FMA, so its computing power is given by
   $$
   6 \times 2.6 \times 4 = 62.4 ~\text{GFLOPS}
   $$

2. Consider that spead of light given by $3 \times 10^8 ms^{-1}$, it takes 
   $$
   t_{signal} = 2 \times 10^{-1}/(3e8) \sim 6 \times 10^{-10} s = 0.6 ns
   $$
   and one loop on my CPU takes
   $$
   t_{loop} = 1/(2.6e9) \sim 3.8 \times 10^{-8} s
   $$
   and these two times are almost the same.

3. Neural Network Processing Unit (NPU), Field-Programmable Gate Array (FPGA) and Tensor Processing Unit (TPU)

   NPU is a specialized circuit that implements all the necessary control and arithmetic logic necessary to execute machine learning algorithms. With its special designs, NPU do not need to transfer the data into the memory, but can directly put them into to its next layer, so that can greatly enhance the calculation speed and reduce the power cost.

   FPGA is another kind of processor, which is an [integrated circuit](https://en.wikipedia.org/wiki/Integrated_circuit) designed to be configured by a customer or a designer after manufacturing. The most interesting preperity of FPGA is that the program on it can directly change the structure of its logic gate circuits, so that can run on a extremely high efficency.

   TPU is designed by Google to speed up their tenserflow network, and it actually is a specially designed processor used to calculate matrix multiplication in a lower accuracy, which is of great need in AI training.

4. Floating point number is not a Group

   1. **Associativity of addition**: Yes
   2. **Existence of additive identity**: Yes
   3. **Existence of additive inverses**: Yes
   4. **Commutativity of multiplication**: Yes
   5. **Associativity of multiplication**: No, for example, consider a 2 digital numer system, $(0.52 \times 0.46) \times 0.81 = 0.18 \neq 0.19 = 0.52 \times (0.46 \times 0.81)$
   6. **Existence of multiplicative identity**: Yes
   7. **Existence of multiplicative inverses**: No. All floating point numbers can be given by $p/q$, but $q/p$ may not be given by floating point number.
   8. **Distributive law**: No, same as above, multiple for floating point numbers is not exact
   9. **Zero-one law**: Yes