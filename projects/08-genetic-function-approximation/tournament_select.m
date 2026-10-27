function parent = tournament_select(pop, fitness, k)
    
    pop_size = size(pop, 1);
    candidates_idx = randi(pop_size, k, 1);
    [~, best_candidate_loc] = min(fitness(candidates_idx));
    parent_idx = candidates_idx(best_candidate_loc);
    parent = pop(parent_idx, :);
    
end

% Επιλέγει τυχαία k άτομα και επιστρέφει το καλύτερο
