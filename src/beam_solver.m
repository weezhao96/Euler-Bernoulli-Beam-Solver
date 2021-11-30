% Beam Solver
clear
clc

% Force and Moment Convention
%
% - Force, defined as positive when acting upwards
% - Moment, defined as positive when acting clockwise
% - z = 0 is at left (start of beam), z = L, is at right of beam (end of
%   beam)


% -------------------------------------------------------------------------
% LOAD BEAM DATA

% ENTER BEAM MAT FILE HERE
load ('test_beam.mat');

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% SOLVE FOR BEAM

[beam,res,x,A,B] = func_main(beam);

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% PLOTTING DISPLACEMENT

% Creating Length Array
len = zeros(beam.n_step + 1,1);

for i = 2 : beam.n_step + 1
    len(i,1) = (i-1) * beam.dz;
end


% Plotting Displacement
hold on
title ('Displacement');

for i = 1 : beam.n_sect
    
    plot (len,res.sect(i).totdisp,'b');
    
end

% -------------------------------------------------------------------------
