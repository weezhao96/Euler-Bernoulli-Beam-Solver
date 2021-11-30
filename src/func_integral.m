function integral = func_integral(differential,n_step,dz,initial)

% Performs Integration and Evaluates for Every Step

% Input
% differential : vector, containing numerical form of function
% n_step       : int, the no. of steps
% dz           : int, the size of each step
% initial      : int, the constant of the integration

% Output
% integral     : vector, containing numerical results of each step


integral = zeros(n_step,1);

integral(1,1) = initial; % Boundary Condition from Continuity

for i = 2 : n_step % i = i-th step
    integral(i,1) = integral(i-1,1) + differential(i,1) * dz;
end