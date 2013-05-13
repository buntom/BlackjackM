classdef IStrategy < handle
    % Represents Blackjack strategy interface
    
    methods (Abstract)
        
        insuranceDecision = GetInsuranceDecision(this, handPlayer, trueCount)
        % Generates decision whether to take insurance
        % - insuranceDecision:
        % 0 = do not take
        % 1 = take
        
        finalDecision = GetDecision(this, handPlayer, ...
            handDealer, trueCount, permit)
        % Generates strategy decision
        % - finalDecision:
        % 0 = stand
        % 1 = hit
        % 2 = double
        % 3 = split
        % 4 = surrender
        
    end
    
end