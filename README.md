# Discrete Multi-Objective Grey Wolf Optimizer (DMO-GWO)

This code is a discrete version to Multi-Objective Grey Wolf Optimizer (MOGWO) for millimeter wave vehicular communications. At first, all possible input settings and their objective functions are contained in a file (tabela3.csv), as described below:
 

Discrete parameters:


* x1: sfperiod (75, 100, 150, 200)
* x2: sympersf (16, 24, 32, 40)
* x3: nharqproc (5, 20, 35)
* x4: txpower (5, 10, 15, 20, 25, 30, 35, 40, 45, 50)


Objective functions:


* f1: Packet loss
* f2: Latency (ns)
* f3: 1/Throughput (1/Mbps)


In order to minimize f1, f2 and f3 should be executed the main code “DMOGWO.m”. After that, the results are saved in the folder “ws_vanets/GWXXgYY”. Where, XX is the population of candidate solutions (grey wolves), and YY is the maximum number of generations. From these results we can generate figures and metrics such as:


* “GeneratePareto.m” to show the pareto in 3D and 2D.
* “GenerateCurves.m” to show Packet loss, Latency, Throughput and Number of simulations versus Generations.
* “GenerateMetrics.m” to calculate the metrics (e.g., HV, GD, IGD, SP). The code for these metrics can be found at PlatEMO [3].


### Previous works

[1] Mirjalili, S., Saremi, S., Mirjalili, S. M., & Coelho, L. D. S. (2016). Multi-objective grey wolf optimizer: a novel algorithm for multi-criterion optimization. Expert Systems with Applications, 47, 106-119.

[2] Yang, X. S., Karamanoglu, M., & He, X. (2014). Flower pollination algorithm: a novel approach for multiobjective optimization. Engineering optimization, 46(9), 1222-1237.

[3] Tian, Y., Cheng, R., Zhang, X., & Jin, Y. (2017). PlatEMO: A MATLAB platform for evolutionary multi-objective optimization [educational forum]. IEEE Computational Intelligence Magazine, 12(4), 73-87.
