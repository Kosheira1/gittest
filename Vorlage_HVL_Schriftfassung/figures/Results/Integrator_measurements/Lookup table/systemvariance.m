%systemvariance of capacitance measurement

figure(1)
load('systemvariance.mat');

hold on
plot(1e+12*test_C);
plot([1,25],[test_Cmag+error_margin,test_Cmag+error_margin]);
plot([1,25],[test_Cmag-error_margin,test_Cmag-error_margin]);



figure(2)
load('systemvariance2.mat');
hold on
plot(1e+12*test_C);
plot([1,25],[test_Cmag+error_margin,test_Cmag+error_margin]);
plot([1,25],[test_Cmag-error_margin,test_Cmag-error_margin]);

