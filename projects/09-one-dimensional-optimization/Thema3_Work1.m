clear;
clc;
a0=-1;
b0=3;
functions={@(x)5^x+(2-cos(x))^2,@(x)(x-1)^2+exp(x-5)*sin(x+3),@(x)exp(-3*x)-(sin(x-2)-2)^2};
fnames={'f1','f2','f3'};

%a)
l_values=[0.5 0.2 0.1 0.05 0.02 0.01];
for i=1:3
    f=functions{i};
    counters_l=zeros(size(l_values));
    for j=1:length(l_values)
        l=l_values(j);
        L0=b0-a0;
        F=[1 1];
        n=2;
        while F(n)<L0/l
            F(end+1)=F(end)+F(end-1);
            n=n+1;
        end
        a=a0;
        b=b0;
        x1=a+F(n-2)/F(n)*(b-a);
        x2=a+F(n-1)/F(n)*(b-a);
        f1=f(x1);
        f2=f(x2);
        counter=2;
        k=1;
        while k<(n-2)
            if f1>f2
                a=x1;
                x1=x2;
                f1=f2;
                x2=a+F(n-k-1)/F(n-k)*(b-a);
                f2=f(x2);
                counter=counter+1;
            else
                b=x2;
                x2=x1;
                f2=f1;
                x1=a+F(n-k-2)/F(n-k)*(b-a);
                f1=f(x1);
                counter=counter+1;
            end
            k=k+1;
        end
        if f1>f2
            a=x1;
        else
            b=x2;
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
    figure;
    hold on;
    for j=1:length(l_values_plot)
        l=l_values_plot(j);
        L0=b0-a0;
        F=[1 1];
        n=2;
        while F(n)<L0/l
            F(end+1)=F(end)+F(end-1);
            n=n+1;
        end
        a=a0;
        b=b0;
        x1=a+F(n-2)/F(n)*(b-a);
        x2=a+F(n-1)/F(n)*(b-a);
        f1=f(x1);
        f2=f(x2);
        a_vals=zeros(1,n-1);
        b_vals=zeros(1,n-1);
        k=1;
        idx=0;
        while k<(n-2)
            if f1>f2
                a=x1;
                x1=x2;
                f1=f2;
                x2=a+F(n-k-1)/F(n-k)*(b-a);
                f2=f(x2);
            else
                b=x2;
                x2=x1;
                f2=f1;
                x1=a+F(n-k-2)/F(n-k)*(b-a);
                f1=f(x1);
            end
            idx=idx+1;
            a_vals(idx)=a;
            b_vals(idx)=b;
            k=k+1;
        end
        if f1>f2
            a=x1;
        else
            b=x2;
        end
        idx=idx+1;
        a_vals(idx)=a;
        b_vals(idx)=b;
        k_vec=1:idx;
        plot(k_vec,a_vals(1:idx),'-o');
        plot(k_vec,b_vals(1:idx),'--o');
    end
    grid on;
    hold off;
end
