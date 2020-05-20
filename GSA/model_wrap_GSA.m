%--------------------------------------------------------------------------
%Used to fix some parameters and let the others vary (INDMAP) before
%solving ODE
%--------------------------------------------------------------------------

function QoI = model_wrap_GSA(pars,data)

ALLPARS = data.gpars.ALLPARS;
INDMAP  = data.gpars.INDMAP;
 
tpars = ALLPARS;
tpars(INDMAP') = pars;


[~,QoI,~] = model_sol(tpars,data);

