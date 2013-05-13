simDataC = csvread('b:\bjSimData.csv', 1, 0);
idxNeq = simData ~= simDataC;

idxRowNeq = false(size(simData, 1), 1);
for i = 1:size(simData, 2)
    idxRowNeq = idxRowNeq | idxNeq(:,i);
end

indexRowNeq = find(idxRowNeq)
