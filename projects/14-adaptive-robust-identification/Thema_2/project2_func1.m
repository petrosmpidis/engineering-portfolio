function output_rem = project2_func1(dividend, divisor)
    output_rem = dividend - divisor .* floor(dividend ./ divisor);
end