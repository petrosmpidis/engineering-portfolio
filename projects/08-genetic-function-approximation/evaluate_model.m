function y = evaluate_model(genes, X, N) % genes: διάνυσμα παραμέτρων, X: πίνακας εισόδων, N: αριθμός Gaussians
    
    u1 = X(:, 1);
    u2 = X(:, 2);
    y = zeros(size(u1));
    
    for k = 1:N
        idx = (k-1)*5 + 1;
        w  = genes(idx);
        c1 = genes(idx+1);
        c2 = genes(idx+2);
        s1 = genes(idx+3);
        s2 = genes(idx+4);
        % Τύπος Gaussian 
        term = exp( - ( ((u1 - c1).^2)./(2*s1^2) + ((u2 - c2).^2)./(2*s2^2) ) );
        y = y + w * term;
    end
    
end