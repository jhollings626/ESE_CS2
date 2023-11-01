%model for the whole time range, so SIRD values are hard to tune. 
%this script is a useful baseline though, as it provides a solid framework
%of how to implement SIRD in future scripts that model spread over a much
%smaller time period.

%part 2 script for A = 6x6
%x0 stores the initail state: normal, vulnerable, Normalinfected, vulnerableInfected, 
% Dead, and cumulative cases

load("COVID_STL.mat");

n = 6; %variable for dimensionality of A

A = [
    0.990 0.000 0.055 0.005 0.000 0.000;  % Normal
    0.000 0.998 0.000 0.020 0.000 0.000;  % Vulnerable
    0.009 0.001 0.935 0.005 0.000 0.000;  % Normalinfected
    0.001 0.001 0.005 0.960 0.000 0.000;  % VulnerableInfected
    0.000 0.000 0.005 0.010 1.000 0.000;  % Dead
    0.010 0.005 0.000 0.000 0.000 1.000;  % Cumulative cases
];


B = zeros(n,1);

%initial state vector needs to be built with real data about St. Loius'
%vulnerable population
percentAtRisk = 0.14;
percentNormal = 1 - percentAtRisk;
x0 = [(POP_STL * percentNormal); 
      (POP_STL * percentAtRisk);
      6;
      1;
      0;
      0];


sys_sir_base = ss(A,B,eye(n) ,zeros(n,1),1);
Y = lsim(sys_sir_base,zeros(158*7,1),linspace(0,158*7 - 1,158*7),x0); %simulate for all 158 weeks of spread
origY = Y;
Y = Y/POP_STL; %convert SIRD values to a fraction of the whole STL population
% plot the output trajectory
figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Y(1:100,1:n));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Croaked','Cum');
title('St. Louis COVID Model for First 100 Days of Spread')
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;


%casesFraction = cases_STL / POP_STL; %create new case vector storing cases as fraction of whole population
%plot(casesFraction(1:100));

dailyDates = linspace(dates(1),dates(end),length(dates)*7); %create 158*7 daily dates spanning the range in question
figure;
hold on;
plot(dailyDates,origY(1:end,n));
plot(dates,cases_STL);
legend('model','actual');
ylim auto;