function [A,B] = func_eqbuild_mid(beam,i,A,B,res)


% Forms Boundary Conditions for Boundaries Between Ends of Beam, depending
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

if type == 1
    
    disp ('Applying Bound Cond. at mid section, Type 1');
    
    % v2 = 0
    B = [B ; -res.sect(j).edisp(pos)];
    
    temp = zeros(1,n_uk);
    
    % - Coefficient of v2
    temp(1,4*i-3 : 4*i) = res.sect(j).udisp(pos,:);
     
    A = [A ; temp];
    
    disp ('v2 = 0');
    
    
    % v1 = 0
    
    B = [B ; -res.sect(j-1).edisp(pos)];
    
    temp = zeros(1,n_uk);
    
    % - Coefficient of v1
    temp(1,4*(i-1)-3 : 4*(i-1)) = res.sect(j-1).udisp(pos,:);
    
    A = [A ; temp];
    
    disp ('v1 = 0');

    
    % v'1 = v'2
    
    B = [B ; res.sect(j).egrad(pos) - res.sect(j-1).egrad(pos)];

    temp = zeros(1,n_uk);
    
    % - Coefficient of v'1
    temp(1,4*(i-1)-3 : 4*(i-1)) = res.sect(j-1).ugrad(pos,:);
    
    % - Coefficient of v'2
    temp(1, 4*i-3 : 4*i ) = -res.sect(j).ugrad(pos,:);

    A = [A ; temp];
    
    disp ('v1_prime = v2_prime');


    % M1 = M2

    B = [B ; res.sect(j).eM(pos) - res.sect(j-1).eM(pos)];
    
    temp = zeros(1,n_uk);
    
    % - Coefficient of M1
    temp(1,4*(i-1)-3 : 4*(i-1)) = res.sect(j-1).uM(pos,:);
    
    % - Coeffcient of M2
    temp(1,4*i-3 : 4*i) = -res.sect(j).uM(pos,:);

    A = [A ; temp];
    
    disp ('M1 = M2');
    
    disp (' ');
        
elseif type == 3
    
    disp ('Applying Bound Cond. at mid section, Type 3');
    
    % M1 - M2 = M_applied
    
    B = [B ; beam.bound(i).moment - (res.sect(j-1).eM(pos) - res.sect(j).eM(pos))];
    
    temp = zeros(1,n_uk);
    
    % - Coefficient of M1
    temp(1,4*(i-1)-3 : 4*(i-1)) = res.sect(j-1).uM(pos,:);
    
    % - Coeffcient of M2
    temp(1,4*i-3 : 4*i) = -res.sect(j).uM(pos,:);
    
    A = [A ; temp];
    
    disp('M1 - M2 = M_applied');
    
    
    % F1 - F2 = F_applied

    B = [B ; beam.bound(i).load - (res.sect(j-1).eF(pos) - res.sect(j).eF(pos))];
    
    temp = zeros(1,n_uk);
    
    % - Coefficient of F1
    temp(1,4*(i-1)-3 : 4*(i-1)) = res.sect(j-1).uF(pos,:);
    
    % - Coeffcient of F2
    temp(1,4*i-3 : 4*i) = -res.sect(j).uF(pos,:);
    
    A = [A ; temp];
    
    disp ('F1 - F2 = F_applied');
    
    
    % v1 = v2
    
    B = [B ; res.sect(j).edisp(pos) - res.sect(j-1).edisp(pos)];
    
    temp = zeros(1,n_uk);
    
    % - Coefficient of v1
    temp(1,4*(i-1)-3 : 4*(i-1)) = res.sect(j-1).udisp(pos,:);
    
    % - Coefficient of v2
    temp(1,4*i-3 : 4*i) = -res.sect(j).udisp(pos,:);

    A = [A ; temp];
    
    disp ('v1 = v2');
    
    
    % v'1 = v'2
    
    B = [B ; res.sect(j).egrad(pos) - res.sect(j-1).egrad(pos)];

    temp = zeros(1,n_uk);
    
    % - Coefficient of v'1
    temp(1,4*(i-1)-3 : 4*(i-1)) = res.sect(j-1).ugrad(pos,:);
    
    % - Coefficient of v'2
    temp(1, 4*i-3 : 4*i ) = -res.sect(j).ugrad(pos,:);

    A = [A ; temp];  
    
    disp ('v1_prime = v2_prime');
    
    disp (' ');
    
end

% -------------------------------------------------------------------------