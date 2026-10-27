function dp = project1a_func3(p, dp, l, u)
    for i = 1:length(p)
        if (p(i) <= l(i) && dp(i) < 0)
            dp(i) = 0;
        end
        if (p(i) >= u(i) && dp(i) > 0)
            dp(i) = 0;
        end
    end
end