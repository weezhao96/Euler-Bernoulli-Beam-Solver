function [beam,res,x,A,B] = func_main(beam)

% Main Function which links all functions together

% Input :
% beam - struct, containing beam and load data

% Output : 
% beam - struct, updated structure
%
% res  - struct, containing Shear Force, Bending Moment, Gradient and
%        Displacement
%      - results are broken into individual sections,
%        res.sect(i), i = n-th section
%      - check comments in func_differential_solver for definitions of
%        fields in res
%
% x    - vector, solution of unknown variables from integration
%
% A    - matrix of boundary conditions
% B    - vector of boundary conditions
% where A * x = B



% -------------------------------------------------------------------------
% NUMERICAL INTEGRATION OF LOAD DISTRIBUTION

% Initialise res, a struct for results
res = struct();

for i = 1 : beam.n_sect % i-th section
    [res] = func_differential_solver(beam,res,i);
end

for i = 1 : beam.n_sect
    res.sect(i).eF = -res.sect(i).eF;
    res.sect(i).uF = -res.sect(i).uF;
    
    res.sect(i).eM = -res.sect(i).eM;
    res.sect(i).uM = -res.sect(i).uM;
end

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% FORM BOUNDARY CONDITIONS TO SOLVE FOR CONSTANT FROM INTEGRATION

A = [];
B = [];

for i = 1 : beam.n_bound % i = n-th bound of beam
    
    % Boundary Condition at z = 0
    if i == 1
       [A,B] = func_eqbuild_0(beam,i,A,B,res); 
    
    % Boundary Condition between z = 0 and z = L
    elseif (beam.n_bound > 2) && (i < beam.n_bound)
       [A,B] = func_eqbuild_mid(beam,i,A,B,res);
       
    % Boundary Condition at z = L
    elseif i == beam.n_bound
       [A,B] = func_eqbuild_end(beam,i,A,B,res);
    end
    
end

% Force Equilibrium Condtion
% [beam,A,B] = func_forceeq(beam,A,B,res);

% Moment Equilibrium Condition
% [beam,A,B] = func_momenteq(beam,A,B,res);

% Solve Unknowns of Boundary Condition
x = linsolve(A,B);

% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% SORTING RESULTS

% Summing Constants and Function of Solutions

for i = 1 : beam.n_sect % i-th section
    res.sect(i).totF = res.sect(i).eF + res.sect(i).uF * x(4*i-3:4*i,1);
    res.sect(i).totM = res.sect(i).eM + res.sect(i).uM * x(4*i-3:4*i,1);
    res.sect(i).totgrad = res.sect(i).egrad + res.sect(i).ugrad * x(4*i-3:4*i,1);
    res.sect(i).totdisp = res.sect(i).edisp + res.sect(i).udisp * x(4*i-3:4*i,1);
end

% Reaction Force and Moment
[beam] = func_reaction(beam,res);

% Stress Distribution
[res,stress_state] = func_stress_analy(beam,res);

if stress_state == 0
    disp('The bending stress is over the maximum stress.');
end


% -------------------------------------------------------------------------



end       