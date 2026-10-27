clear;
clc;

a0=-1;
b0=3;


functions={@(x) 5^x+(2-cos(x))^2, @(x)(x-1)^2+exp(x-5)*sin(x+3), @(x) exp(-3*x)-(sin(x-2)-2)^2};

fnames={'f1', 'f2', 'f3'};


%a)

l=0.01;
e_values=[0.0001 0.0005 0.001 0.002 0.004];

for i=1:3
    f=functions{i};
    counter_e=zeros(size(e_values));

    for j=1:length(e_values)
        e=e_values(j);

        a=a0;
        b=b0;
        counter=0;

        while (b-a)>l

            x1=(a+b)/2-e;
            x2=(a+b)/2+e;

            f1=f(x1);
            counter=counter+1;

            f2=f(x2);
            counter=counter+1;

            if f1>f2
                a=x1;
            else
                b=x2;
            end
        end
     counter_e(j)=counter;
    end

    figure;
    plot(e_values, counter_e, '-o');
end


%b)

e=0.001;
l_values=[0.5 0.2 0.1 0.05 0.02 0.01];

for i=1:3
    f=functions{i};
    counters_l=zeros(size(l_values));

    for j=1:length(l_values)
        l=l_values(j);

        a=a0;
        b=b0;
        counter=0;

        while (b-a)>l
            x1=(a+b)/2-e;
            x2=(a+b)/2+e;

            f1=f(x1);
            counter=counter+1;

            f2=f(x2);
            counter=counter+1;

            if f1>f2
                a=x1;
            else
                b=x2;
            end
        end
        counters_l(j)=counter;
    end

    figure;
    plot(l_values, counters_l, '-o');
end


%c)

eps=0.001;
l_values_plot=[0.1 0.05 0.01];

for i=1:3
    f=functions{i};

    figure;
    hold on;

    for j=1:length(l_values_plot)
        l=l_values_plot(j);
        a=a0;
        b=b0;
        k=0;
        a_vals=[];
        b_vals=[];

        while (b-a)>l
            k=k+1;

            x1=(a+b)/2-eps;
            x2=(a+b)/2+eps;
            f1=f(x1);
            f2=f(x2);

            if f1>f2
                a=x1;
            else
                b=x2;
            end

            a_vals(k)=a;
            b_vals(k)=b;
        end

        k_vec=1:length(a_vals);
        plot(k_vec, a_vals, '-o');
        plot(k_vec, b_vals, '--o');
        
    end
end
