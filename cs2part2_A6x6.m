%part 2 script for A = 6x6
%x0 stores the initail state: normal, vulnerable, Normalinfected, vulnerableInfected, 
% Dead, and cumulative cases

load("COVID_STL.mat");


A =[
    0.990 0.000 0.059 0.000 0.000 0.000;
    0.000 0.995 0.000 0.030 0.000 0.000;
    0.010 0.000 0.940 0.000 0.000 0.000;
    0.000 0.005 0.000 0.967 0.000 0.000;
    0.000 0.000 0.001 0.003 1.000 0.000;
    0.010 0.005 0.000 0.000 0.000 1.000;

];

B = zeros(6,1);

%initial state vector needs to be built with real data about St. Loius'
%vulnerable population
percentAtRisk = 0.14;
percentNormal = 1 - percentAtRisk;
x0 = [(POP_STL * percentNormal); (POP_STL * percentAtRisk); 6; 1; 0;0];


sys_sir_base = ss(A,B,eye(6) ,zeros(6,1),1);
Y = lsim(sys_sir_base,zeros(1000,1),linspace(0,999,1000),x0);
origY = Y;
Y = Y/POP_STL; %convert SIRD values to a fraction of the whole STL population
% plot the output trajectory
figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Y(1:100,1:6));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Croaked','Cum');
title('St. Louis COVID Model for First 100 Days of Spread')
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;

%994 days in 142 weeks, so let's take the first 142 weeks of the cases
%casesFraction = cases_STL / POP_STL; %create new case vector storing cases as fraction of whole population
%plot(casesFraction(1:100));

dailyDates = linspace(dates(1),dates(142),142*7); %create 994 daily dates spanning the range in question
figure;
hold on;
plot(dailyDates,origY(1:994,6));
plot(dates(1:142),cases_STL(1:142));
legend('model','actual');
ylim auto;