# Randall_GSA_VM
This repository contains the code for the manuscript "“Global sensitivity analysis informed model reduction and selection applied to a Valsalva maneuver model". 

FullModel directory 
- contains folders with code computing the full model given in the manuscript: 

ForwardEvaluation subdirectory
- computes the forward model evaulation with nominal parameter values computed from data
- plots data figures (Figure 2a-d)
- To run, compile the driver executable using all of the .f files in the command line and run DriverBasic.m

LSA subdirectory 
- computes local sensitivity analysis for the full model
- plots the LSA shown as x's in Figure 5
- To run, compile the driver executable and run DriverBasic_LSA.m 
- To plot, run plotLSA.m 

Figure 5 subdirectory 
- computes the heart rate model output evaluating each of the noninfluential parameters at 10 equidistant points within their parameter bounds and plots them (Figure 6)
- To run and plot, compile the driver executable and run OTAanalysis.m 

Optimization subdirectory 
- determines the parameters that minimize the least squares cost of the heart rate residual 
- plots optimized figures (Figure 2f and g)
- To plot, run plotopt.m 
  
The folders m1_no_taub, m2_no_taub_B0, and m3_no_taub_B1 are structured similarly as FullModel with the removals discussed in the manuscript. 

The folder GSA computes the scalar and time-varying Sobol' indices (SIs) discussed in the manuscript.
- Contains the code tvSob.m, a noninvasive program that calculates scalar and time-varying SIs   
- Plots the scalar SIs (Figure 5) and the point wise in time, generalized, and limited memory SIs (Figure 7)
- To run, compile the driver executable and run DriverBasic_GSA.m 
- To calculate moving windows of several sizes, run differentwindows.m 
- To plot the different window sizes, run plotdifferentwindows.m (Figure 4)
- To plot the scalar SIs, run plotScaSI.m 
- To plot the pointwise in time SIs, run plotPTSI.m
- To plot the generalized SIs, run plotGSI.m
- To plot the limited memory SIs, run plotLMSI.m 

