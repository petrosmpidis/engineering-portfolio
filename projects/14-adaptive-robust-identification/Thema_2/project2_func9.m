function phi_vector = project2_func9(struct_model, state_input, control_input)
    state_input = max(min(state_input, 5), -5);
    
    if struct_model.uid == 1
        phi_vector = [1; state_input; control_input];
    elseif struct_model.uid == 2
        phi_vector = [state_input; sin(state_input); project2_func10(-state_input); control_input];
    elseif struct_model.uid == 3
        phi_vector = [state_input^3 * project2_func10(state_input); state_input; sin(state_input); project2_func10(-state_input); control_input];
    elseif struct_model.uid == 4
        phi_vector = [1; state_input; state_input^2; state_input^3; sin(state_input); cos(state_input); project2_func10(-state_input); control_input; state_input * control_input];
    else
        phi_vector = [1; state_input; state_input^2; state_input^3; state_input^4; state_input^5; ...
                      sin(state_input); cos(state_input); project2_func10(-state_input); ...
                      project2_func10(state_input); state_input^3 * project2_func10(state_input); ...
                      control_input; state_input * control_input; control_input^2];
    end
end