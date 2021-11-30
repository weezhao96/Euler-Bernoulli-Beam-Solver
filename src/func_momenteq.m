function [beam,A,B] = func_momenteq(beam,A,B,res)


% Forming Boundary Equations from Moment Equilibrium at z = 0

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

n_step = beam.n_step;
dz = beam.dz;

n_bound = beam.n_bound;
n_sect = beam.n_sect;

% No. of Unknowns
n_uk = 4 * n_sect;

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% COMPUTE TOTAL MOMENT APPLIED AT z = 0

% Initialise total_moment
total_moment = 0;


% Creating Moment Distribution
moment_dist = zeros(n_step + 1,1);

for i = 1 : n_step + 1 % i-th step from z = 0
    moment_dist(i,1) = -beam.load_dist(i) * dz * (i-1);
end


% Moment from Load Distribution
x = 0 : dz : beam.prop.len;

total_moment = total_moment + trapz(x,moment_dist);


% Moment from Point Force and Moment
for i = 1 : n_bound % i = i-th support
    
    if beam.bound(i).type == 3
        total_moment = total_moment - beam.bound(i).load * (beam.bound(i).pos - 1) * dz;
        total_moment = total_moment + beam.bound(i).moment;
    end
    
end


% Assign total_moment to struct-beam
beam.total_moment = total_moment;

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% FORMING EQUATION BASED ON SUPPORT TYPE

temp_B = -total_moment;
temp_A = zeros(1,n_uk);

for i = 1 : n_bound % n-th bound
    
    % j, n-th section
    if i < n_bound
    
        j = i;
    
    elseif i == n_bound
    
        j = i-1; 
    
    end
    
    
    pos = beam.bound(i).pos;
    
    
    % Reaction Moment at z = 0
    if (i == 1) && (beam.bound(i).type == 2)

        temp_B = temp_B + res.sect(1).eM(pos);
        
        temp_A(1,1 : 4) = temp_A(1,1 : 4) - res.sect(j).uM(pos,:);
    
    end

    
    % Reaction Moment at z = L
    if (i == n_bound) && (beam.bound(i).type == 2)

        temp_B = temp_B - res.sect(j).eM(pos);

        temp_A(1, 4*j-3 : 4*j) = temp_A(1,4*j-3 : 4*j) + res.sect(j).uM(pos,:);
        
    end
    
    
    % Moment due to Reaction Force from Simple Support between Two Ends
    if (i < n_bound) && (i > 1)

        % Involves Unknowns of Two Sections, hence from 4(j-1) : 4j
        
        z = (pos-1) * dz;
        
        temp_B = temp_B + ( res.sect(j-1).eF(pos) - res.sect(j).eF(pos) ) .* z;
        
        temp_A(1, 4*(j-1)-3 : 4*j) = temp_A(1 , 4*(j-1)-3 : 4*j) - [ z * res.sect(j-1).uF(pos,:) , -z * res.sect(j).uF(pos,:) ];
        
    end
      
    
    % Moment due to Reaction Force at z = L
    if (i == n_bound) && ( (beam.bound(n_bound).type == 2) || (beam.bound(n_bound).type == 1) )

        z = (pos-1) * dz;
        
        temp_B = temp_B + res.sect(j).eF(pos) * z;
        
        temp_A(1, 4*j-3 : 4*j) = temp_A(1 , 4*j-3 : 4*j) - z .* res.sect(j).uF(pos,:);
        
    end
            
end

disp ('Applying Bound Cond. for Moment Equilibrium');

A = [A ; temp_A];
B = [B ; temp_B];

end




