%model of spread over first 100 days for n = 6
load("COVID_STL.mat");

n = 6; %variable for dimensionality of A
d = 100; %number of days to simulate for

A = [
    0.999922 0.000000 0.040 0.005 0.000 0.000;
    0.000000 0.999980 0.000 0.020 0.000 0.000;
    0.000078 0.000000 0.956 0.005 0.000 0.000; 
    0.000000 0.000020 0.000 0.960 0.000 0.000; 
    0.000000 0.000000 0.004 0.010 1.000 0.000; 
    0.000078 0.000020 0.000 0.000 0.000 1.000;  
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

plot(dates(1:15),deaths_STL(1:15)/POP_STL);
plot(dailyDates(1:d),origY(1:d,5) / POP_STL);
xlim([startDate endDate]);
legend('model','actual','actual deaths','modeled deaths');
title('Daily Cases As Fraction of Population From 3/18/20 - 6/24/20');
ylabel('Fraction of Population');
xlabel('Date');

error = 0;
samples = 0;
for i = 1:7:d %below is used for calculating error between model and actual
    samples = samples + 1; %increment samples used to track number of tests, important bc working w/ multiples of 7
    %we can also use the above count variable to access weekly entries in
    %cases_STL
    modeledCases = origY(i,6); %access a point from each week, reported on the same day as the actual data
    actualCases = cases_STL(samples); %cases STL contains weekly data
    tempError = ((modeledCases - actualCases) / actualCases) * 100; %calculate weekly error
    error = error + tempError;
end

error = error/samples;
fprintf('Average Percent Error: %.2f%%\n', error);