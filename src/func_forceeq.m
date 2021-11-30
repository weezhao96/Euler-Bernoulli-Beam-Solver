function [beam,A,B] = func_forceeq(beam,A,B,res)

% Forming Boundary Equations from Vertical Force Equilibrium

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

dz = beam.dz;

n_bound = beam.n_bound;
n_sect = beam.n_sect;

% No. of Unknowns
n_uk = 4 * n_sect;

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% COMPUTE TOTAL LOAD ON BEAM

total_load = 0;

% Point Force
for i = 1 : n_bound % i = i-th support
    
    if beam.bound(i).type == 3
        total_load = total_load + beam.bound(i).load;
    end
    
end


% Distributed Force
x = 0 : dz : beam.prop.len;
total_load = total_load + trapz(x,beam.load_dist);


% Assign total_load to struct-beam
beam.total_load = total_load;


% Solving for Equilibrium : Total Reaction Force + Total Load = 0
temp_B = -total_load;
temp_A = zeros(1,n_uk);

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% FORMING EQUATION BASED ON SUPPORT TYPE

% First bound : i = 1
if (beam.bound(1).type == 1) || (beam.bound(1).type == 2)

    pos = beam.bound(1).pos;
    
    temp_B = temp_B + res.sect(1).eF(pos);
    
    temp_A(1,1:4) = temp_A(1,1:4) - res.sect(1).uF(pos,:);
     
end

% Last bound : i = n_bound
if (beam.bound(n_bound).type == 1) || (beam.bound(n_bound).type == 2)

    pos = beam.bound(n_bound).pos;
    
    temp_B = temp_B - res.sect(n_bound - 1).eF(pos);
    
    temp_A(1,4*n_sect-3 : 4*n_sect) = temp_A(1,4*n_sect-3 : 4*n_sect) + res.sect(n_bound - 1).uF(pos,:);
    
end

% Mid Bound
if n_bound > 2
    
    for i = 2 : (n_bound - 1) % i = n-th bound
        if (beam.bound(i).type == 1)
            pos = beam.bound(i).pos;

            temp_B = temp_B - (res.sect(i-1).eF(pos) - res.sect(i).eF(pos));

            temp_A(1, 4*(i-1)-3 : 4*i) = temp_A(1, 4*(i-1)-3 : 4*i) + [res.sect(i-1).uF(pos,:) , -res.sect(i).uF(pos,:)];
        end
    end
    
end

disp ('Applying Bound Cond. for Force Equilibrium');

A = [A ; temp_A];
B = [B ; temp_B];

% -------------------------------------------------------------------------


        
        
