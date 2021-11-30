function beam = func_reaction(beam,res)

n_bound = beam.n_bound;


for i = 1 : n_bound
    
    if (beam.bound(i).type == 1) || (beam.bound(i).type == 2)
        
        pos = beam.bound(i).pos;
        
        if i == 1
            beam.bound(i).load = -res.sect(1).totF(pos);
        end
        
        if i == n_bound
            beam.bound(i).load = res.sect(i-1).totF(pos);
        end
        
        if (n_bound > 2) && (i ~= 1) && (i ~= n_bound)
            beam.bound(i).load = res.sect(i-1).totF(pos) - res.sect(i).totF(pos);
        end
        
        if beam.bound(i).type == 2
            if i == 1
                beam.bound(i).moment = -res.sect(i).totM(pos);
            end
            
            if i == n_bound
                beam.bound(i).moment = res.sect(i-1).totM(pos);
            end
        end
        
    end
    
end
                
        
            
            
            
            