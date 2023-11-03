% Before Vaccinations
load('mockdata2023.mat')

n = 5; %variable for dimensionality of A
d = 100; %number of days to simulate for

B = zeros(n,1);
x0 = [1-newInfections(1)-cumulativeDeaths(1), 0, newInfections(1), 0, cumulativeDeaths(1)];


infectionRate = 0.0010;
healRate = .1;
deathRate = .12;

APreVax = [1-infectionRate, 0, healRate, 0, 0;
           0, 0, 0, 0, 0; 
           infectionRate, 0, 1-healRate-deathRate, 0, 0;
           0, 0, 0, 0, 0;
           0, 0, deathRate, 0, 1];


sys_sir_base = ss(APreVax,B,eye(n) ,zeros(n,1),1);
PreVax = lsim(sys_sir_base,zeros(d,1),linspace(0,d - 1,d),x0); %simulate for d days of spread


% After Vaccinations
uvInfectionRate = 0.0010;
uvHealRate = .1;
uvDeathRate = .12;

vInfectionRate = .00025;
vHealRate = .4;
vDeathRate = 0.001;

vaxRate = 0.026;

AWithVax = [1-uvInfectionRate-vaxRate, 0               , uvHealRate              , 0                     , 0;
            vaxRate                  , 1-vInfectionRate, 0                       , vHealRate             , 0;
            uvInfectionRate          , 0               , 1-uvHealRate-uvDeathRate, 0                     , 0;
            0                        , vInfectionRate  , 0                       , 1-vHealRate-vDeathRate, 0;
            0                        , 0               , uvDeathRate              ,vDeathRate            , 1];


sys_sir_base = ss(AWithVax,B,eye(n) ,zeros(n,1),1);
% fix numbers, bounds of simulation, then concatenate PreVax and WithVax
WithVax = lsim(sys_sir_base,zeros(400-d,1),linspace(d,399,400-d),PreVax(d, :)); %simulate for d days of spread



model = cat(1, PreVax, WithVax);
% plot the output trajectory
figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(model(1:400,1:n));
title("Model");
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;
legend("Unvaccinated healthy", "Vaccinated healthy", "Unvaccinated infected", "Vaccinated infected", "Deaths");


% Compare model with actual data
figure;
hold on;
plot(model(1:400, 3)+model(1:400, 4));
plot(model(1:400, 5));
plot(newInfections);
plot(cumulativeDeaths);
title("Model vs Actual Data");
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;
legend("Model Infected", "Model deaths", "Actual infected", "Actual deaths");

vaxpop = model(:,2) + model(:,4); %add vaccinated and vaccinated infected populations on every day
vaxbreak = model(:,4);
