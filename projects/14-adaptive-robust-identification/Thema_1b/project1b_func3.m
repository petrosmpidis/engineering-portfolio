function disturbance_vector = project1b_func3(time_instant, magnitude_bound)
    raw_signal = [sin(2.3 * time_instant) + 0.4; 
                  0.7 * cos(1.7 * time_instant) - 0.2];
    
    if magnitude_bound == 0
        disturbance_vector = [0; 0];
    else
        % Κανονικοποίηση και επιβολή του άνω ορίου σφάλματος
        disturbance_vector = magnitude_bound * raw_signal / norm(raw_signal);
    end
end