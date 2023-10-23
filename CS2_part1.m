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


hold on;
plot(X(1, :));
plot(X(2, :));
plot(X(3, :));
plot(X(4, :));
legend("Susceptible", "Infected", "Recovered", "Deceased");

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
legend("Susceptible", "Infected", "Deceased");