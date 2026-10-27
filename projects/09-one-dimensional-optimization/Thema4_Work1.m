clear;
clc;

a0=-1;
b0=3;

functions={@(x)5^x+(2-cos(x))^2,@(x)(x-1)^2+exp(x-5)*sin(x+3),@(x)exp(-3*x)-(sin(x-2)-2)^2};
dfunctions={@(x)5^x*log(5)+2*(2-cos(x))*sin(x),@(x)2*(x-1)+exp(x-5)*sin(x+3)+exp(x-5)*cos(x+3),@(x)-3*exp(-3*x)-2*(sin(x-2)-2)*cos(x-2)};

fnames={'f1','f2','f3'};

%a)

l_values=[0.5 0.2 0.1 0.05 0.02 0.01];

for i=1:3
    f=functions{i};
    df=dfunctions{i};
    counters_l=zeros(size(l_values));

    for j=1:length(l_values)
        l=l_values(j);

        a=a0;
        b=b0;
        counter=0;

        while (b-a)>l
            x=(a+b)/2;
            dfx=df(x);
            counter=counter+1;

            if dfx>0
                b=x;
            else
                a=x;
            end
        end

        counters_l(j)=counter;
    end

    figure;
    plot(l_values,counters_l,'-o');
    grid on;
end

%b)

l_values_plot=[0.1 0.05 0.01];

for i=1:3
    f=functions{i};
    df=dfunctions{i};

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

            x=(a+b)/2;
            dfx=df(x);

            if dfx>0
                b=x;
            else
                a=x;
            end

            a_vals(k)=a;
            b_vals(k)=b;
        end

        k_vec=1:length(a_vals);
        plot(k_vec,a_vals,'-o');
        plot(k_vec,b_vals,'--o');
    end

    grid on;
    hold off;
end
