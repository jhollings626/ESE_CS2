% Before Vaccinations

infectionRate = .02;
healRate = .1;
deathRate = .1;

APreVax = [1-infectionRate, 0, healRate, 0, 0;
           0, 0, 0, 0, 0; 
           infectionRate, 0, 1-healRate-deathRate, 0, 0;
           0, 0, 0, 0, 0;
           0, 0, deathRate, 0, 0];



% After Vaccinations
uvInfectionRate = 
uvHealRate = 
uvDeathRate = 

vInfectionRate = 
vHealRate = 
vDeathRate = 

vaxRate

AWithVax = [1-uvInfectionRate, 0, uvHealRate, 0, 0;
            vaxRate, 1-vInfectionRate, 0, vHealRate, 0;
            uvInfectionRate, 0, 1-uvHealRate-uvDeathRate, 0, 0;
            0, vInfectionRate, 0, 1-vhealRate-vDeathRate, 0;
            0, 0, uvDeathRate, vDeathRate, 1];

