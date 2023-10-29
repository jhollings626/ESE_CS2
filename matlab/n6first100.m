%model of spread over first 100 days for n = 6
load("COVID_STL.mat");

n = 6; %variable for dimensionality of A
d = 100; %number of days to simulate for

A = [
    0.990 0.000 0.055 0.005 0.000 0.000;
    0.000 0.998 0.000 0.020 0.000 0.000;
    0.009 0.001 0.935 0.005 0.000 0.000; 
    0.001 0.001 0.005 0.960 0.000 0.000; 
    0.000 0.000 0.005 0.010 1.000 0.000; 
    0.010 0.005 0.000 0.000 0.000 1.000;  
];


B = zeros(n,1);

%initial state vector needs to be built with real data about St. Loius'
%vulnerable population
percentAtRisk = 0.14;
percentNormal = 1 - percentAtRisk;
x0 = [
    (POP_STL * percentNormal);
    (POP_STL * percentAtRisk); 
    6; 
    1;
    0;
    0
 ];


sys_sir_base = ss(A,B,eye(n) ,zeros(n,1),1);
Y = lsim(sys_sir_base,zeros(d,1),linspace(0,d - 1,d),x0); %simulate for d days of spread
origY = Y;
Y = Y/POP_STL; %convert SIRD values to a fraction of the whole STL population
% plot the output trajectory
figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Y(1:d,1:n));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Croaked','Cum');
title('St. Louis COVID Model For First 100 Days of Spread')
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;


%casesFraction = cases_STL / POP_STL; %create new case vector storing cases as fraction of whole population
%plot(casesFraction(1:100));

dailyDates = linspace(dates(1),dates(end),length(dates)*7); %create 158*7 daily dates spanning the range of virus propagation
startDate = dailyDates(1);
endDate = dailyDates(d); %get the datetime formatted last date
figure;
hold on;
plot(dailyDates(1:d),origY(1:d,n) / POP_STL); %could also just plot against Y, but this makes more sense to somebody reading through code
plot(dates(1:15),cases_STL(1:15) / POP_STL); %need to build this such taht it is same length as number of days that we want to store so we can plot them together
xlim([startDate endDate]);
legend('model','actual');
title('Daily Cases As Fraction of Population From 3/18/20 - 6/24/20');
ylabel('Fraction of Population');
xlabel('Date');