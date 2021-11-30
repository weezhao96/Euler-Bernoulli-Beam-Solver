function [A,B] = func_eqbuild_0(beam,i,A,B,res)

% Forms Boundary Conditions for z = 0, depending on the type of bound

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

% No. of Unknowns, n_uk
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
    
    disp ('Applying Bound Cond. at z = 0 m, Type 0');
    
    % F = 0
    B = [B ; -res.sect(j).eF(pos)];
    
    % - Coefficient of uF
    temp = zeros(1,n_uk);
    temp(1,1:4) = res.sect(j).uF(pos,:);
    A = [A ; temp];
    
    disp ('F = 0');
    
    
    % M = 0
    B = [B ; -res.sect(j).eM(pos)];
    
    % - Coefficient of uM
    temp = zeros(1,n_uk);
    temp(1,1:4) = res.sect(j).uM(pos,:);
    A = [A ; temp];
    
    disp ('M = 0');
    
    disp (' ');
    
elseif type == 1
    
    disp ('Applying Bound Cond. at z = 0 m, Type 1');
    
    % v = 0
    B = [B ; -res.sect(j).edisp(pos)];
    
    % - Coefficient of udisp
    temp = zeros(1,n_uk);
    temp(1,1:4) = res.sect(j).udisp(pos,:);
    A = [A ; temp];
    
    disp ('v = 0');
    
    
    % M = 0
    B = [B ; -res.sect(j).eM(pos)];
    
    % - Coefficient of uM
    temp = zeros(1,n_uk);
    temp(1,1:4) = res.sect(j).uM(pos,:);
    A = [A ; temp];
    
    disp ('M = 0');
    
    disp (' ');
    
elseif type == 2
    
    disp ('Applying Bound Cond. at z = 0 m, Type 2');
    
    % v' = 0
    B = [B ; -res.sect(j).egrad(pos)];
    
    % - Coefficient of ugrad
    temp = zeros(1,n_uk);
    temp(1,1:4) = res.sect(j).ugrad(pos,:);
    A = [A ; temp];
    
    disp ('v_prime = 0');
    
    
    % v = 0
    B = [B ; -res.sect(j).edisp(pos)];
    
    % - Coefficient of udisp
    temp = zeros(1,n_uk);
    temp(1,1:4) = res.sect(j).udisp(pos,:);
    A = [A ; temp];
    
    disp ('v = 0');
    
    disp (' ');
    
elseif type == 3
    
    disp ('Applying Bound Cond. at z = 0 m, Type 3');
    
    % F = -F_applied
    B = [B ; -res.sect(j).eF(pos) - beam.bound(i).load];
    
    % - Coefficient of uF
    temp = zeros(1,n_uk);
    temp(1,1:4) = res.sect(j).uF(pos,:);
    A = [A ; temp];
    
    disp ('F = -F_applied');
    
    
    % M = -M_applied
    B = [B ; -res.sect(j).eM(pos) - beam.bound(i).moment];
    
    % - Coefficnet of uM
    temp = zeros(1,n_uk);
    temp(1,1:4) = res.sect(j).uM(pos,:);
    A = [A ; temp];
    
    disp ('M = -M_applied');
    
    disp (' ');
       
end 