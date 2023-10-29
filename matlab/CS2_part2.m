%original plot of base SIRD values against actual cases in STL.
%major disparity between the two cases plots shows that we have some work
%to do...

load("COVID_STL.mat");

date1 = '2021-06-30';
date2 = '2021-10-27';

lowerBound = find(dates == datetime(date1,'InputFormat','yyyy-MM-dd'));
outerBound = find(dates == datetime(date2,'InputFormat','yyyy-MM-dd'));

A = [0.95 0.04 0  0; 
    0.05 0.85  0  0; 
    0    0.1   1  0; 
    0    0.01  0  1];

B = zeros(4,1);

x0 = [POP_STL - cases_STL(1), cases_STL(1), 0, 0]; %build initial state vector, 
% assuming pop composed only of susceptible and recovered individuals


sys_sir_base = ss(A,B,eye(4) ,zeros(4,1),1);
Y = lsim(sys_sir_base,zeros(1000,1),linspace(0,999,1000),x0);
Y = Y/POP_STL; %convert SIRD values to a fraction of the whole STL population
% plot the output trajectory
figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(dates(lowerBound:outerBound), Y(lowerBound:outerBound,1:4));
legend('S','I','R','D');
title('St. Louis COVID Model for First 100 Days of Spread')
xlabel('Time')
ylabel('Fraction of Population');
ylim auto;

casesFraction = cases_STL / POP_STL; %create new case vector storing cases as fraction of whole population
plot(dates(lowerBound:outerBound), casesFraction(lowerBound:outerBound));

%june 30 - october 26 will be 68-85th entries 
