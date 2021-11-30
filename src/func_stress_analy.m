function [res,stress_state] = func_stress_analy(beam,res)

n_sect = beam.n_sect;
stress_state = 1;

for i = 1 : n_sect
    min = beam.bound(i).pos;
    max = beam.bound(i+1).pos;
    
    res.sect(i).stress = zeros ((max - min) + 1 , 1);
    res.sect(i).stress = res.sect(i).totM .* beam.prop.max_y ./ beam.prop.secmoment;
    
    for j = 1 : (max - min) + 1
        if abs(res.sect(i).stress(j)) > beam.prop.yieldstress
            stress_state = 0;
        end
    end
end