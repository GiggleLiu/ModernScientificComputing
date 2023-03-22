1. FLOPS:  X\*10\*8\*2\*4
number of core: 10
I fail to find the frequency of CPU in my macbook, so here I replace it with X 
![9ac9558ea148de6a01b4e0f49ce51069.png](../../_resources/9ac9558ea148de6a01b4e0f49ce51069.png)


There is no lscpu in mac. Here I use  sysctl hw.
![6337526dea0703086400ad5a3e22c7a3.png](../../_resources/6337526dea0703086400ad5a3e22c7a3.png)
Also, I failed to find the way to know whether my macbook support fma or AVX2, so I assume it supports them.



2. Here I assume the frequency is $3GHz=3\times 10^{9}/s$

 minimum latency time: $2\times \frac{0.1m}{3\times10^{8}m/s}=6.6 \times 10^{-10}s$
CPU clock time: $\frac{1}{3\times 10^{9}}=3.33\times 10^{-10}s$
They are the same order.

3.
1).*Neural Network Processing Unit (NPU)*

A neural processing unit (NPU)  is a specialized circuit that implements all the necessary control and arithmetic logic necessary to execute machine learning algorithms. NPUs are designed to accelerate the performance of common machine learning tasks such as image classification, machine translation, object detection, and various other predictive models.  They may be part of a large SoC, a plurality of NPUs may be instantiated on a single chip, or they may be part of a dedicated neural-network accelerator. HUAWEI's flagship Kirin 970 is HUAWEI's first mobile AI computing platform featuring a dedicated Neural Processing Unit (NPU).
. 
>https://en.wikichip.org/wiki/neural_processor
>https://consumer.huawei.com/en/press/news/2017/ifa2017-kirin970/

2)*Field-Programmable Gate Array (FPGA)*

A field-programmable gate array (FPGA) is an integrated circuit designed to be configured by a customer or a designer after manufacturing. FPGA designs employ very fast I/O rates and bidirectional data buses. and 
the configuration is generally specified using a hardware description language (HDL) which contain a hierarchy of reconfigurable interconnects allowing blocks to be wired together and an array of programmable logic blocks which can be configured to perform complex combinational functions, or act as simple logic gates. They have ample logic gates and RAM blocks to implement complex digital computations. In most FPGAs, logic blocks also include memory elements, which may be simple flip-flops or more complete blocks of memory. Many FPGAs can be reprogrammed to implement different logic functions, allowing flexible reconfigurable computing as performed in computer software. Moreover, FPGAs are also being used as accelerators to speed up the execution of deep learning algorithms. They are also featured by the ability to update the functionality after shipping, partial reconfiguration of a portion of the design and the low non-recurring engineering costs relative to an ASIC design and it makes them more competitive to other  integrated circuits. What's more, some FPGAs have analog features in addition to digital functions, including a programmable slew rate on each output pin, allowing the engineer to set low rates on lightly loaded pins that would otherwise ring or couple unacceptably, and to set higher rates on heavily loaded high-speed channels that would otherwise run too slowly. Also common are quartz-crystal oscillator driver circuitry, on-chip resistance-capacitance oscillators, and phase-locked loops with embedded voltage-controlled oscillators used for clock generation and management as well as for high-speed serializer-deserializer (SERDES) transmit clocks and receiver clock recovery. 
>https://en.wikipedia.org/wiki/Field-programmable_gate_array


3)*Tensor Processing Unit (TPU)*
Tensor Processing Unit (TPU) is an AI accelerator application-specific integrated circuit (ASIC) developed by Google for neural network machine learning, using Google's own TensorFlow software. Google began using TPUs internally in 2015, and in 2018 made them available for third party use, both as part of its cloud infrastructure and by offering a smaller version of the chip for sale.

To make comparison to GPU, TPUs are designed for a high volume of low precision computation (e.g. as little as 8-bit precision) with more input/output operations per joule, without hardware for rasterisation/texture mapping. The TPU ASICs are mounted in a heatsink assembly, which can fit in a hard drive slot within a data center rack. As we all know, different types of processors are suited for different types of machine learning models. TPUs are well suited for CNNs, while GPUs have benefits for some fully-connected neural networks, and CPUs can have advantages for RNNs.
>https://en.wikipedia.org/wiki/Tensor_Processing_Unit



4. 
4: 1,5,7,8  are violated by floating point numbers.

1&5:  The addition and multiplication of floating point numbers is not associative, as rounding errors are introduced when dissimilar-sized values are joined together.

7&8  Because the number of bits to store a floating-point is limited, accuracy is lost during the process of calculating 1/x. For the same reason, because of the different lost accuracy caused from different order of operations, the distributive law is violated by floating point numbers.


