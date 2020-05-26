# Randall_GSA_VM
This repository contains the code for the manuscript "“Global sensitivity analysis informed model reduction and selection applied to a Valsalva maneuver model". 

The FullModel folder contains folders with code computing the full model given in the manuscript: 
  ForwardEvaluation:  computes the forward model evaulation with nominal parameter values; plots data figures (Figure 1a-d)
  LSA:                computes local sensitivity analysis for the full model 
  Optimization:       determines the parameters that minimize the least squares cost of the heart rate residual 
  
The folders m1_no_taub, m2_no_taub_B0, and m3_no_taub_B1 are structured similarly as FullModel with the removals discussed in the manuscript. 

The folder GSA contains the code tvSob.m that computes the scalar and time-varying Sobol' indices discussed in the manuscript. 

The folder Figure5 creates the plots for Figure 5.  

The release of version 1 can be found at DOI: 10.5281/zenodo.3856447. 
