%% setting
params.nbrSimulations = 10^6;
params.nbrPacksTotal = 6;
params.penetrationThres = 0.9;
params.betSize = 1;
params.betSizeMax = 1000;
params.betSizeMin = 1;
params.betSizeType = 'fixed';
params.betSizeTcScale = ...
    [0 0.001
     1 0.00352629530690198;
     2 0.00671896747434498;
     3 0.0131054552046950;
     4 0.0142286250150918;
     5 0.0220189808905742;
     6 0.0258072842968387;
     7 0.0286263345540557;
     8 0.0325921584309242;
     9 0.0378999263235207;
     10 0.0435119157558899];
params.initialWealth = 10000;
params.riskAversionCoeff = 2;
params.strategyType = 'basic';
params.randType = 'csharp';
params.customRandSeed = 10;

rules.doubleAfterSplit = true;
rules.maxNbrSplits = 1;
rules.surrenderAllowed = false;
rules.dealerStandsS17 = true;
rules.insuranceAllowed = true;

%% simulation
nbrSimulations = 10000;
bjSim = cBlackjackSim(params, rules);
simData = bjSim.Simulate(nbrSimulations);

%% some analysis
figure('Name', 'Payoff dist.')
hist(simData(:,1), 200)
title(['E = ' num2str(mean(simData(:,1))) ', STD = ' ...
    num2str(std(simData(:,1)))])

figure('Name', 'IBA dist.')
IBAs = simData(:,1) ./ simData(:,4);
hist(IBAs, 200)
title(['E = ' num2str(mean(IBAs)) ', STD = ' ...
    num2str(std(IBAs))])

figure('Name', 'TBA dist.')
TBAs = simData(:,1) ./ simData(:,5);
hist(TBAs, 200)
title(['E = ' num2str(mean(TBAs)) ', STD = ' ...
    num2str(std(TBAs))])

figure('Name', 'Wealth process')
subplot(2, 1, 1)
wealth = cumsum(simData(:,1)) + params.initialWealth;
stairs(wealth)
hold on
hline(params.initialWealth, 'r:', 'InitialWealth')
hold off
title('Wealth')
subplot(2, 1, 2)
stairs(simData(:,1))
title('Payoffs')

stats.payoffMean = mean(simData(:,1));
stats.payoffStd = std(simData(:,1));
payoffSum = sum(simData(:,1));
stats.IBA = payoffSum / sum(simData(:,4));
stats.IBAstd = std(IBAs);
stats.TBA = payoffSum / sum(simData(:,5));
stats.TBAstd = std(TBAs);
stats.wealthMin = min(wealth);
stats.wealthMax = max(wealth);
stats.wealthEnd = wealth(end);
stats

tcBins.trueCounts = unique(simData(:,3));
nTrueCounts = length(tcBins.trueCounts);
tcBins.meanVals = NaN(nTrueCounts, 1);
tcBins.stdVals = NaN(nTrueCounts, 1);
tcBins.optiBets = NaN(nTrueCounts, 1);
tcBins.betCounts = NaN(nTrueCounts, 1);
tcBins.IBAs =  NaN(nTrueCounts, 2);
tcBins.TBAs =  NaN(nTrueCounts, 2);
for i = 1:nTrueCounts
    
    idxAux = simData(:,3) == tcBins.trueCounts(i);
    tcBins.IBAs(i,1) = mean(IBAs(idxAux));
    tcBins.IBAs(i,2) = std(IBAs(idxAux));
    tcBins.TBAs(i,1) = mean(TBAs(idxAux));
    tcBins.TBAs(i,2) = std(TBAs(idxAux));
    tcBins.meanVals(i) = mean(simData(idxAux,1));
    tcBins.stdVals(i) = std(simData(idxAux,1));
    tcBins.optiBets(i) = tcBins.IBAs(i,1) / tcBins.IBAs(i,2)^2;
    tcBins.betCounts(i) = sum(idxAux);
    
end

figure('Name', 'IBA/TBA cond. by TrueCount')
subplot(2, 1, 1)
plotyy(tcBins.trueCounts, tcBins.IBAs(:,1), tcBins.trueCounts, tcBins.IBAs(:,2), 'stairs')
hold on
hline(0)
hold off
title('IBA; Left: E, Right: STD')
xlabel('TrueCount')
subplot(2, 1, 2)
plotyy(tcBins.trueCounts, tcBins.TBAs(:,1), tcBins.trueCounts, tcBins.TBAs(:,2), 'stairs')
hold on
hline(0)
hold off
title('TBA; Left: E, Right: STD')
xlabel('TrueCount')

figure('Name', 'Stats cond. by TrueCount')
subplot(2, 2, 1)
plotyy(tcBins.trueCounts, tcBins.meanVals, tcBins.trueCounts, tcBins.stdVals, 'stairs')
hold on
hline(0)
hold off
xlabel('TrueCount')
title('Left: E; Right: STD')
subplot(2, 2, 2)
stairs(tcBins.trueCounts, tcBins.optiBets)
hold on
hline(0)
hold off
xlabel('TrueCount')
ylabel('OptiBetFrac')
subplot(2, 2, 3)
stairs(tcBins.trueCounts, tcBins.betCounts)
xlabel('TrueCount')
ylabel('BetCount')
subplot(2, 2, 4)
tcBins.betCounts(:,2) = tcBins.betCounts(:,1) ./ size(simData, 1);
stairs(tcBins.trueCounts, tcBins.betCounts(:,2))
xlabel('TrueCount')
ylabel('BetCountFrac')

