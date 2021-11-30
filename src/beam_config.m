% Beam Configurations

clc
clear


% -------------------------------------------------------------------------
% GENERAL BEAM PROPERTIES

% -- ENTER name of beam
beam.beam_config = 'test_beam.mat';

% -- ENTER length of the beam, m
beam.prop.len = 1;

% -- ENTER Young Modulus of the beam, Pa
beam.prop.modulus = 1;

% -- ENTER beam Yield Stress, Pa
beam.prop.yieldstress = 1;

% -- ENTER Length of Steps, m
beam.dz = 0.01;
% More steps improves accuracy, but increases computation time

beam.n_step = round(beam.prop.len / beam.dz);

% -- ENTER beam distribution of second moment of area, m^4
for i = 1 : beam.n_step + 1
    beam.prop.secmoment(i,1) = 1;
end

% -- ENTER beam distribution of maximum vertical distance from centre of mass, y = 0
for i = 1 : beam.n_step + 1
    beam.prop.max_y(i,1) = 1;
end

% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% SUPPORT AND LOAD INPUT

% -- ENTER Load Distribution

load_dist = zeros(beam.n_step + 1,1);
for i = 1 : beam.n_step + 1
   
    x = beam.dz * (i - 1);
    
    load_dist(i,1) = 1;
        
end

beam.load_dist = load_dist;


% -- DEFINE bound matrix (bound is Support/Point Load/Point Moment)
% Array Format :
% [Position (m) , Boundary Type , Force Applied (N) , Moment Applied (N m)]
%
% Boundary Type : Simple Support(1),Cantilever(2),Applied Force/Moment(3)
bound = [];
bound = [bound ; 0 2 0 0];

% Sorting Rows by Position
bound = sortrows(bound,1);


% Add Additional Boundary if Ends of Beams Are Free

% - At z = 0
if bound(1,1) ~= 0
    bound = [0 0 0 0; bound];
end

% - At z = L
if bound(size(bound,1),1) ~= beam.prop.len
    bound = [bound ; beam.prop.len , 0 , 0 , 0];
end


% No. of Boundaries
beam.n_bound = size(bound,1);

% No. of Sections - Sections are the region between two boundary
beam.n_sect = beam.n_bound - 1;



% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% ASSIGN MATRIX TO STRUCT-BEAM

for i = 1 : size(bound,1)
    
    % Beam position is stored as n steps + 1, from z = 0
    % where, z = (pos - 1) * dz
    beam.bound(i).pos = floor(bound(i,1)/beam.dz) + 1;
    beam.bound(i).type = bound(i,2);
    beam.bound(i).load = bound(i,3);
    beam.bound(i).moment = bound(i,4);
end



% -------------------------------------------------------------------------


% Save Workspace
save (beam.beam_config,'beam');