function [A,B] = func_eqbuild_end(beam,i,A,B,res)

% Forms Boundary Conditions for Boundary at z = L, depending
% on the type of bound

% Input
% beam - struct, containing beam and load data
% i    - int, n-th bound of beam
% A    - matrix, current coefficient of boundary equations
% B    - vector, current constant of boundary equations
% res  - struct, containing integrals solution

% Output
% A - matrix, updated A
% B - vector, updated B


% -------------------------------------------------------------------------
% DEFINING INITIAL VARIABLES

pos = beam.bound(i).pos;
type = beam.bound(i).type;

% No. of Unknowns
n_uk = 4 * beam.n_sect;

% j, n-th section
if i < beam.n_bound
    
    j = i;
    
elseif i == beam.n_bound
    
    j = i-1; 
    
end

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% APPLYING BOUNDARY CONDITION BASED OF SUPPORT TYPE

if type == 0
    
    disp ('Applying Bound Cond. at z = L, Type 0');
    
    % F = 0
    B = [B ; -res.sect(j).eF(pos)];
    
    temp = zeros(1,n_uk);
    temp(1,4*j - 3 : 4*j) = res.sect(j).uF(pos,:);
    
    A = [A ; temp];
    
    disp ('F = 0');
    
    % M = 0
    B = [B ; -res.sect(j).eM(pos)];
    
    temp = zeros(1,n_uk);
    temp(1,4*j-3 : 4*j) = res.sect(j).uM(pos,:);
    
    A = [A ; temp];
    
    disp ('M = 0');
    
    disp (' ');
    
elseif type == 1
    
    disp ('Applying Bound Cond. at z = L, Type 1');
    
    % v = 0
    B = [B ; -res.sect(j).edisp(pos)];
    
    temp = zeros(1,n_uk);
    temp(1,4*j-3 : 4*j) = res.sect(j).udisp(pos,:);

    A = [A ; temp];
    
    disp ('v = 0');
    
    
    % M = 0
    
    B = [B ; -res.sect(j).eM(pos)];
    
    % - Coefficient of uM
    temp = zeros(1,n_uk);
    temp(1,4*j-3 : 4*j) = res.sect(j).uM(pos,:);
    A = [A ; temp];
    
    disp ('M = 0');
    
    disp (' ');
    
elseif type == 2
    
    disp ('Applying Bound Cond. at z = L, Type 2');
    
    % v' = 0
    B = [B ; -res.sect(j).egrad(pos)];
    
    temp = zeros(1,n_uk);
    temp(1,4*j-3 : 4*j) = res.sect(j).ugrad(pos,:);

    A = [A ; temp];
    
    disp ('v_prime = 0');
    
    
    % v = 0
    B = [B ; -res.sect(j).edisp(pos)];
    
    temp = zeros(1,n_uk);
    temp(1,4*j-3 : 4*j) = res.sect(j).udisp(pos,:);

    A = [A ; temp];
    
    disp('v = 0');
    
    disp(' ');
    
elseif type == 3
    
    disp ('Applying Bound Cond. at z = L, Type 3');
    
    % F = F_applied
    B = [B ; -res.sect(j).eF(pos) + beam.bound(i).load];
    
    % - Coefficient of uF
    temp = zeros(1,n_uk);
    temp(1,4*j-3:4*j) = res.sect(j).uF(pos,:);
    
    A = [A ; temp];
    
    disp ('F = F_applied');
    
    
    % M = -M_applied
    B = [B ; -res.sect(j).eM(pos) + beam.bound(i).moment];
    
    % - Coefficienet of uM
    temp = zeros(1,n_uk);
    temp(1,4*j - 3: 4*j) = res.sect(j).uM(pos,:);
    
    A = [A ; temp];
    
    disp ('M = -M_applied');
    
    disp(' ');
    
end