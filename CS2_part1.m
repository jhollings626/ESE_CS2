% Part 1


% Question 1: implementing model in textbook
X = zeros(4, 210);

% Setting initial condition xsub1
X(:, 1) = [1; 0; 0; 0];

A = [.95, .04, 0, 0;
     .05, .85, 0, 0;
       0,  .1, 1, 0;
       0, .01, 0, 1];


for t = 2:210
    X(:, t) = A*X(:, t-1);
end

figure;
hold on;
plot(X(1, :));
plot(X(2, :));
plot(X(3, :));
plot(X(4, :));
title("SIRD model described in textbook");
legend("Susceptible", "Infected", "Recovered", "Deceased");
% This model converges to 10% of the population dying, and the other 90%
% being immune. The model converges a little after 100 days. 


% Question 2: modyifing model, so reinfections possible for everyone
XReinfectionsPossible = zeros(3, 1600);
XReinfectionsPossible(:, 1) = [1; 0; 0];

AReinfectionsPossible = [.95, .14, 0;
                         .05, .85, 0;
                          0,   .01,  1];

for t = 2:1600
    XReinfectionsPossible(:, t) = AReinfectionsPossible*XReinfectionsPossible(:, t-1);
end

figure;
hold on;
plot(XReinfectionsPossible(1, :));
plot(XReinfectionsPossible(2, :));
plot(XReinfectionsPossible(3, :));
title("Modified Model: Reinfections Possible");
legend("Susceptible", "Infected", "Deceased");
% This model converges to a state where everyone dies, since when someone
% gets sick, they either die or become susceptible again, so everyone will
% either die or keep getting sick and eventually die. This model takes a
% lot longer to converge, a little over 1400 days. 



% When comparing our from scratch model, versus the ss and lsim functions,
% they worked the same, but the ss and lsim model converged much quicker,
% because in that model's initial condition, it started with 10% infected
% at t = 0, whereas in our model, we started with 0% infected. 