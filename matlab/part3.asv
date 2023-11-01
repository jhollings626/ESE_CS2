%Part 3 - Modeling Interactions of Distinct Populations
%-----------------------------------------------------
%Equations
%Ax + Bu format, where Bu term is used to compute the number of individuals
%of each category traveling between the two regions. Will need to simulate
%for each region separately...
%------------------------------------------------------
%% Initial Setup
%------------------------------------------------------
load("COVID_STL.mat");

n = 6; %variable for dimensionality of A

M = zeros(n,1); %change name of this zeros vector to M for readability

percentAtRisk = 0.14;
percentNormal = 1 - percentAtRisk; %for now, same distribution for both metros

metro1POP = 650000;
metro2POP = 300000;

A = [
    0.999750 0.000000 0.037000 0.000000 0.000 0.000;
    0.000000 0.999938 0.000000 0.020000 0.000 0.000;
    0.000250 0.000000 0.962900 0.005015 0.000 0.000; 
    0.000000 0.000062 0.000000 0.974700 0.000 0.000; 
    0.000000 0.000000 0.000100 0.000300 1.000 0.000; %death 
    0.000250 0.000062 0.000000 0.000000 0.000 1.000;  
];

%B only needs to exist along the diagonals because when people move they
%are joining the same group in the other city that they already belong to
%Thus, B just stores the percent of the population that is moving to the
%other metro on a given day

B = [
    0.0500 0.0000 0.0000 0.0000 0.0000 0.0000; %on any day 5% of normal pop moves
    0.0000 0.0500 0.0000 0.0000 0.0000 0.0000; %on any day 5% of vulnerable pop moves
    0.0000 0.0000 0.0100 0.0000 0.0000 0.0000; %on any day 1% of normal infected will move
    0.0000 0.0000 0.0000 0.0010 0.0000 0.0000; %0.1% of vulnerable infected moving every day
    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000; %no dead people traveling,so 5,5, 0
    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000; %no movement in cumulative cases either

    ];
