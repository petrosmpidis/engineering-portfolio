function structural_models = project2_func2()
    structural_models = struct([]);
    
    structural_models(1).uid = 1;
    structural_models(1).description = 'Γραμμικό Μοντέλο';
    structural_models(1).features = {'1', 'x', 'u'};
    structural_models(1).num_params = 3;
    
    structural_models(2).uid = 2;
    structural_models(2).description = 'Μικρό Μη-Γραμμικό';
    structural_models(2).features = {'x', 'sin(x)', 'exp(-x)', 'u'};
    structural_models(2).num_params = 4;
    
    structural_models(3).uid = 3;
    structural_models(3).description = 'Πραγματική Φυσική Δομή';
    structural_models(3).features = {'x^3*exp(x)', 'x', 'sin(x)', 'exp(-x)', 'u'};
    structural_models(3).num_params = 5;
    
    structural_models(4).uid = 4;
    structural_models(4).description = 'Πολυωνυμικό-Τριγωνομετρικό';
    structural_models(4).features = {'1', 'x', 'x^2', 'x^3', 'sin(x)', 'cos(x)', 'exp(-x)', 'u', 'x*u'};
    structural_models(4).num_params = 9;
    
    structural_models(5).uid = 5;
    structural_models(5).description = 'Υπερπαραμετροποιημένο (Μεγάλο)';
    structural_models(5).features = {'1', 'x', 'x^2', 'x^3', 'x^4', 'x^5', 'sin(x)', 'cos(x)', 'exp(-x)', 'exp(x)', 'x^3*exp(x)', 'u', 'x*u', 'u^2'};
    structural_models(5).num_params = 14;
end