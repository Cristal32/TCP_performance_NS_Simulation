# TCP_performance_NS_Simulation
Evaluating the performance of two TCP variants: TCP Vegas and TCP new Reno in a simulated SANET network.

Our goal is to compare which TCP variant is best fit in a SANET (Static Ad hoc Network) environment. 
One of the effective indicators we can use to compare is the Packet Loss Ration (PLR).

## Tools:
- NS2 (v2.35) Network Simulator
- NAM (v1.14) Network Animator
- AWK Programming Language

## Steps:
1.  Simulate the SANET network using the TCP Vegas variant. In order to do so, we execute the TCL file using ns:
```shell
ns sanet_vegas.tcl
```
This will generate 2 files: 
- sanet_vegas.nam: can be used by the nam tool to graphically visualize the simulation.
- sanet_vegas.tr: contains all information about events during the simulation, is often used for analysis.
   
2. Simulate the SANET network using the TCP new Reno variant:
```shell
ns sanet_reno.tcl
```
This will also generate 2 files: sanet_reno.nam and sanet_reno.tr.

3. In order to compare the results, an AWK script is provided that measures the PLR accross time for each trace file:
```shell
awk -f loss_rate.awk sanet_vegas.tr >> plr_results_vegas.txt
awk -f loss_rate.awk sanet_reno.tr >> plr_results_reno.txt
```
This way, we can transfer the resulted PLR values in text files, that we can use to visualise the PLR curve for the two TCP variants and determine which 
one results in the least packet loss.
