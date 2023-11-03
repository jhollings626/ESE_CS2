%Part 3 - Modeling Interactions of Distinct Populations
%-----------------------------------------------------
%Equations
% When independent of each other, Population 1 is described by xt+1 = Axt, Population 2 is described by
% yt+1 = Byt. To describe travel between them, we stack x and y into column
% vector z = (x; y), and zt+1 = Czt, where C is the matrix [A, (pop2/pop1)C; (pop1/pop2)D; B],
% where C and D are matrices of the same dimensions of A and B, where all
% entries are 0 except for the diagonal, where the entries of the diagonal
% describe the proportions of the different groups in each population traveling to each other.
% C describes people from Population 2 moving into Population 1, and D
% describes people from Population 1 moving into Population 2. C is
% multiplied by the scalar (pop2/pop1) and D by (pop1/pop2) since the
% entries of x and y are proportions of populations 1 and 2, respectively,
% so when looking at the people moving from population 2 to 1, we need to
% convert them to a fraction of population 1, and vice versa when moving
% from population 1 to 2. 
%------------------------------------------------------
%% Initial Setup
%------------------------------------------------------
load("COVID_STL.mat");

n = 6; %variable for dimensionality of A

M = zeros(n,1); %change name of this zeros vector to M for readability
d=2500;

metro1POP = POP_STL;
metro2POP = 300000;
percentAtRiskPop1 = 0.14;
percentNormalPop1 = 1 - percentAtRiskPop1; 
percentAtRiskPop2 = 0.4;
percentNormalPop2 = 1 - percentAtRiskPop2; 

x0 = [
    (percentNormalPop1)-6/POP_STL;
    (percentAtRiskPop1)-1/POP_STL; 
    6/POP_STL; 
    1/POP_STL;
    0;
    0
 ];
y0 = [
     (percentNormalPop2);
    (percentAtRiskPop2); 
    0; 
    0;
    0;
    0
    
];
z0 = [x0; y0];

pop1NormalInfectionRate = .008;
pop1VulnerableInfectionRate = .004;
pop1NormalHealRate = .04;
pop1VulnerableHealRate = .025;
pop1NormalDeathRate = .004;
pop1VulnerableDeathRate = .01;

pop2NormalInfectionRate = .008;
pop2VulnerableInfectionRate = .004;
pop2NormalHealRate = .04;
pop2VulnerableHealRate = .025;
pop2NormalDeathRate = .004;
pop2VulnerableDeathRate = .01;

Aorig = [
    1-pop1NormalInfectionRate 0.000000                      pop1NormalHealRate                       0.000                                        0.000 0.000;
    0.000000                  1-pop1VulnerableInfectionRate 0.000                                    pop1VulnerableHealRate                          0.000 0.000;
    pop1NormalInfectionRate   0.000000                      1-pop1NormalDeathRate-pop1NormalHealRate  0.000 0.000 0.0000; 
    0.000000                  pop1VulnerableInfectionRate   0.000                                    1-pop1VulnerableDeathRate-pop1VulnerableHealRate 0.000 0.000; 
    0.000000                  0.000000                      pop1NormalDeathRate                      pop1VulnerableDeathRate                     1.000 0.000; 
    pop1NormalInfectionRate   pop1VulnerableInfectionRate   0.000                                    0.000                                  0.000 1.000;   
];

% Right now B same as A, should change a lil bit
Borig = [    
   1-pop2NormalInfectionRate 0.000000                      pop2NormalHealRate                       0.000                                        0.000 0.000;
    0.000000                  1-pop2VulnerableInfectionRate 0.000                                    pop2VulnerableHealRate                          0.000 0.000;
    pop2NormalInfectionRate   0.000000                      1-pop2NormalDeathRate-pop2NormalHealRate  0.000 0.000 0.000; 
    0.000000                  pop2VulnerableInfectionRate   0.000                                    1-pop2VulnerableDeathRate-pop2VulnerableHealRate 0.000 0.000; 
    0.000000                  0.000000                      pop2NormalDeathRate                      pop2VulnerableDeathRate                     1.000 0.000; 
    pop2NormalInfectionRate   pop2VulnerableInfectionRate   0.000                                    0.000                                  0.000 1.000;    
    ];



Corig = [
    0.0500 0.0000 0.0000 0.0000 0.0000 0.0000; %on any day 5% of normal pop 2 moves to pop 1
    0.0000 0.0500 0.0000 0.0000 0.0000 0.0000; %on any day 5% of vulnerable pop 2 moves to pop 1
    0.0000 0.0000 0.0100 0.0000 0.0000 0.0000; %on any day 1% of normal infected pop 2 will move to pop 1
    0.0000 0.0000 0.0000 0.0010 0.0000 0.0000; %0.1% of vulnerable infected moving every day
    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000; %no dead people traveling,so 5,5, 0
    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000; %no movement in cumulative cases either
    ]; % convert to fraction of population 1

% D same as C right now, change?
Dorig = [    
    0.0500 0.0000 0.0000 0.0000 0.0000 0.0000; %on any day 5% of normal pop 1 moves to pop 2
    0.0000 0.0500 0.0000 0.0000 0.0000 0.0000; %on any day 5% of vulnerable pop 1 moves to pop 2
    0.0000 0.0000 0.0100 0.0000 0.0000 0.0000; %on any day 1% of normal infected pop 1 will move to pop 2
    0.0000 0.0000 0.0000 0.0010 0.0000 0.0000; %0.1% of vulnerable infected moving every day
    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000; %no dead people traveling,so 5,5, 0
    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000; %no movement in cumulative cases either
    ];

% update A and B to account of traveling populations

A = Aorig;
B = Borig;
C = Corig;
D = Dorig;

F = [A-A*D C; D B-B*C];




% Simulating
sys_sir_base = ss(F, zeros(2*n,1),eye(2*n) ,zeros(2*n,1),1);
Z = lsim(sys_sir_base,zeros(d,1),linspace(0,d - 1,d),z0); %simulate for d days of spread


figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Z(1:d,1:5));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Dead');
title('Population 1 with travel rate from pop 1->pop 2 = D')
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;

figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Z(1:d,7:11));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Dead');
title('Population 2 with travel rate from pop 1->pop 2 = D')
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;
disp("Test 1: ");
day=2300;
test = Z(day, 1) + Z(day, 2) + Z(day, 3)+ Z(day, 4)+ Z(day, 5)+ Z(day, 7)+ Z(day, 8)+ Z(day, 9)+ Z(day, 10)+ Z(day, 11)
disp("With travel ratefrom pop 1-> 2 = D");
disp("Pop 1 Deaths at day 1000: ");
Z(1000, 5)
disp("Pop 2 Deaths at day 1000: ")
Z(1000, 11)

D=1.5*D;
A = Aorig;
B = Borig;
A = A -A*(D);
B = B - B*(C);
F = [A C; D B];
d=2500;
sys_sir_base = ss(F, zeros(2*n,1),eye(2*n) ,zeros(2*n,1),1);
Z = lsim(sys_sir_base,zeros(d,1),linspace(0,d - 1,d),z0); %simulate for d days of spread


figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Z(1:d,1:5));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Dead');
title('Population 1 with travel rate from pop 1->pop 2 = 1.5*D');

xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;

figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Z(1:d,7:11));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Dead');
title('Population 2 with travel rate from pop 1->pop 2 = 1.5*D');
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;
day = 2400;
disp("Test 2: increased rate 2->1");
test = Z(day, 1) + Z(day, 2) + Z(day, 3)+ Z(day, 4)+ Z(day, 5)+ Z(day, 7)+ Z(day, 8)+ Z(day, 9)+ Z(day, 10)+ Z(day, 11)

disp("With travel ratefrom pop 1-> 2 = 1.5*D");
disp("Pop 1 Deaths at day 1000: ");
Z(1000, 5)
disp("Pop 2 Deaths at day 1000: ")
Z(1000, 11)


% Action Item 2: Implementing Travel Policy

% Delta Wave: Days 473-592

z0 = Z(473, :);
d=592-473+1;
A = Aorig;
B = Borig;
C = Corig;
D = Dorig;
F = [A-A*D C; D B-B*C];
sys_sir_base = ss(F, zeros(2*n,1),eye(2*n) ,zeros(2*n,1),1);
Z = lsim(sys_sir_base,zeros(d,1),linspace(473,592,d),z0); %simulate for d days of spread


figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Z(1:d,1:5));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Dead');
title('Delta Wave: Pop 1 without policy');
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;

figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Z(1:d,7:11));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Dead');
title('Delta Wave: Pop 2 without policy');
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;

% Now gradually implementing policy:

startDay = 473;
endDay = 592;
d=10;
for j = 12:1
for i = 1:6
    C(i, i) = Corig(i, i)*(j/12);
    D(i, i) = Dorig(i, i)*(j/12);
end
A = Aorig;
B = Borig;
F = [A-A*D C; D B-B*C];
sys_sir_base = ss(F, zeros(2*n,1),eye(2*n) ,zeros(2*n,1),1);
Z = lsim(sys_sir_base,zeros(d,1),linspace(startDay,startDay+d-1,d),z0); %simulate for d days of spread

startDay=startDay+d;
z0 = Z(10, :);
end


figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Z(:,1:5));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Dead');
title('Delta Wave: Pop 1 woth gradually implemented policy');
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;

figure;
hold on; %toggle hold, plotting multiple curves on the same graph
plot(Z(:,7:11));
legend('Normal', 'Vulnerable','Normal Infected','Vulnerable Infected','Dead');
title('Delta Wave: Pop 2 with gradually implemented policy');
xlabel('Time')
ylabel('Fraction of Population');
ylim auto; hold off;







 