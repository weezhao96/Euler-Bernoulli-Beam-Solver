function [res] = func_differential_solver(beam,res,i)

% Function which Solves (EI * v'')'' = w

% Input :
% beam - struct, beam with information of beam and loading
% res  - struct, contains results of previous section
% i    - int, i-th section of beam

% sect_res  - struct, results of current section


% sect_res.fields :
% eF(i,1) : exact integral of shear force
% i : position, defined in n-th steps from z = 0
% same format for eM, egrad, edisp
%
% udisp(i,1) : A * integral of shear force, 1st constant from integral of section
% udisp(i,2) : B * integral of shear force, 2nd constant from integral of section
% udisp(i,3) : C * integral of shear force, 3rd constant from integral of section
% udisp(i,4) : D * integral of shear force, 4th constant from integral of section
% same format for uF, uM, ugrad

% -------------------------------------------------------------------------
% DEFINING VARIABLES

% Basic Position and Physical Variables
dz = beam.dz;
min = beam.bound(i).pos;
max = beam.bound(i+1).pos;
n_step = (max - min) + 1;


% Initial Values of Integral based on Continuity between Sections
if i > 1
    % For i-th section which is not at the start of beam, initial values
    % based upon final step of last section
    
    iniF = res.sect(i-1).eF(min,1);
    iniM = res.sect(i-1).eM(min,1);
    inigrad = res.sect(i-1).egrad(min,1);
    inidisp = res.sect(i-1).edisp(min,1);
    
    iniM_A = res.sect(i-1).uM(min,1);
    
    inigradA = res.sect(i-1).ugrad(min,1);
    inigradB = res.sect(i-1).ugrad(min,2);
    
    inidispA = res.sect(i-1).udisp(min,1);
    inidispB = res.sect(i-1).udisp(min,2);
    inidispC = res.sect(i-1).udisp(min,3);
    
else % For 1st section, take initial values as zero
    iniF = 0;
    iniM = 0;
    inigrad = 0;
    inidisp = 0;
    
    iniM_A = 0;
    
    inigradA = 0;
    inigradB = 0;
    
    inidispA = 0;
    inidispB = 0;
    inidispC = 0;
end


% Load Distribution
load_dist = beam.load_dist(min:max,1);

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% NUMERICAL INTEGRATION

% ---
% SHEAR DISTRIBUTION

% Initialisation
F = zeros(beam.n_step + 1,1);

% Integration
F(min:max,1) = func_integral(load_dist,n_step,dz,iniF);

% New Constant from Integration
F_A = zeros(beam.n_step + 1,1);
F_A(min:max,1) = ones(n_step,1);
% ---


% ---
% BENDING MOMENT DISTRIBUTION

% Initialisation
M = zeros(beam.n_step + 1,1);
M_A = zeros(beam.n_step + 1,1);

% Integration
M(min:max,1) = func_integral(F(min:max,1),n_step,dz,iniM);
M_A(min:max,1) = func_integral(F_A(min:max,1),n_step,dz,iniM_A);

% New Constant from Integration
M_B = zeros(beam.n_step + 1,1);
M_B(min:max,1) = ones(n_step,1);
% ---


% ---
% GRADIENT

% Initialisation
grad = zeros(beam.n_step + 1,1);
gradA = zeros(beam.n_step + 1,1);
gradB = zeros(beam.n_step + 1,1);

% Integration
grad(min:max,1) = func_integral(M(min:max,1)./(beam.prop.modulus * beam.prop.secmoment(min:max,1)),n_step,dz,inigrad);
gradA(min:max,1) = func_integral(M_A(min:max,1)./(beam.prop.modulus * beam.prop.secmoment(min:max,1)),n_step,dz,inigradA);
gradB(min:max,1) = func_integral(M_B(min:max,1)./(beam.prop.modulus * beam.prop.secmoment(min:max,1)),n_step,dz,inigradB);

% New Constant from Integration
gradC = zeros(beam.n_step + 1,1);
gradC(min:max,1) = ones(n_step,1);
% ---


% ---
% DISPLACEMENT

% Initialisation
disp = zeros(beam.n_step + 1,1);
dispA = zeros(beam.n_step + 1,1);
dispB = zeros(beam.n_step + 1,1);
dispC = zeros(beam.n_step + 1,1);

% Integration
disp(min:max,1) = func_integral(grad(min:max,1),n_step,dz,inidisp);
dispA(min:max,1) = func_integral(gradA(min:max,1),n_step,dz,inidispA);
dispB(min:max,1) = func_integral(gradB(min:max,1),n_step,dz,inidispB);
dispC(min:max,1) = func_integral(gradC(min:max,1),n_step,dz,inidispC);

% New Constant from Integration
dispD = zeros(beam.n_step + 1,1);
dispD(min:max,1) = ones(n_step,1);
% ---

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% ASSIGNING INTEGRALS TO res

% Initialise Zero Matrix
zeromat = zeros(beam.n_step + 1,1);


% Shear
res.sect(i).eF = F; % ( EI * v'' )' = -F
res.sect(i).uF = [F_A , zeromat , zeromat , zeromat]; % ( EI * v'' )' = -F

% Moment
res.sect(i).eM = M; % EI * v'' = -M
res.sect(i).uM = [M_A , M_B , zeromat , zeromat]; % EI * v'' = -M

% Gradient
res.sect(i).egrad = grad;
res.sect(i).ugrad = [gradA , gradB , gradC , zeromat];

% Displacement
res.sect(i).edisp = disp;
res.sect(i).udisp = [dispA , dispB , dispC , dispD];

% -------------------------------------------------------------------------
end