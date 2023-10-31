%model of spread over first 100 days for n = 6
load("COVID_STL.mat");

n = 6; %variable for dimensionality of A

A = [
    0.999922 0.000000 0.040 0.005 0.000 0.000;
    0.000000 0.999980 0.000 0.020 0.000 0.000;
    0.000078 0.000000 0.953 0.005 0.000 0.000; 
    0.000000 0.000020 0.000 0.960 0.000 0.000; 
    0.000000 0.000000 0.001 0.003 1.000 0.000; 
    0.000078 0.000020 0.000 0.000 0.000 1.000;  
];

B = zeros(n,1);

percentAtRisk = 0.14;
percentNormal = 1 - percentAtRisk;


dailyDates = linspace(dates(1),dates(end),length(dates)*7); %create 158*7 daily dates spanning the range of virus propagation
startDateIndex = 473; %index of the first date of the rnage
endDateIndex = 592; %index of the last date of the range
weekIndexSTART = round(startDateIndex / 7); %for indexing into dates
weekIndexEND = round(endDateIndex /7 ); %for indexing into dates
startDate = dailyDates(startDateIndex); %get datetime formatted start date
endDate = dailyDates(endDateIndex); %get the datetime formatted last date
d = endDateIndex - startDateIndex; %number of days to simulate for, equal to the final index of the date range, or the date number
startingNormalInfected = cases_STL(weekIndexSTART) * 0.9533; %normal cases are the rest of the non-vulnerable cases
startingDeaths = deaths_STL(weekIndexSTART);
startingVulnerableInfected = cases_STL(weekIndexSTART) * 0.0467; %vulnerable cases should be 1/3 of 14% of the total population


x0 = [
    (POP_STL * percentNormal);
    (POP_STL * percentAtRisk); 
    startingNormalInfected; 
    startingVulnerableInfected;
    startingDeaths;
    startingVulnerableInfected + startingNormalInfected%total starting cases is the sum of 
    % starting normal infected and starting vulnerable infected data
 ];

sys_sir_base = ss(A,B,eye(n) ,zeros(n,1),1);
Y = lsim(sys_sir_base,zeros(d,1),linspace(0,d - 1,d),x0); %simulate for d days of spread
origY = Y; %leave the original Y values in here
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

figure;
hold on;
plot(dailyDates(startDateIndex:endDateIndex - 1),origY(1:d,5) / POP_STL);
plot(dates(firstWeek:lastWeek),deaths_STL(firstWeek:lastWeek)/POP_STL);
xlim([startDate endDate]);
title('Total Deaths As Fraction of Population From 6/30/21 - 10/26/21');
legend('Modeled Deaths','Actual Deaths');
ylabel('Fraction of Population');
xlabel('Date');

figure;
hold on;
plot(dailyDates(startDateIndex:endDateIndex -1),origY(1:d,n) / POP_STL); %trust me it works
plot(dates(weekIndexSTART:weekIndexEND),cases_STL(weekIndexSTART:weekIndexEND) / POP_STL); %need to build this such taht it is same length as number of days that we want to store so we can plot them together
legend('Modeled Cases', 'Actual Cases');
xlim([startDate endDate]);
title('Total Cases As Fraction of Population From 6/30/21 - 10/26/21');ylabel('Fraction of Population');
ylabel('Fraction of Population');
xlabel('Date');
hold off;



error = 0;
samples = 0;
for i = 1:7:d %below is used for calculating error between model and actual
    samples = samples + 1; %increment samples used to track number of tests, important bc working w/ multiples of 7
    %we can also use the above count variable to access weekly entries in
    %cases_STL
    modeledCases = origY(i,6); %access a point from each week, reported on the same day as the actual data
    actualCases = cases_STL(weekIndexSTART); %cases STL contains weekly data
    tempError = ((modeledCases - actualCases) / actualCases) * 100; %calculate weekly error
    error = error + tempError;
    weekIndexSTART = weekIndexSTART + 1; %for indexing into weekly data
end

error = error/samples;
fprintf('Average Percent Error: %.2f%%\n', error);