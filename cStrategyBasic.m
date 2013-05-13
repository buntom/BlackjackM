classdef cStrategyBasic < IStrategy
    % Represents the 'Basic strategy' of Blackjack play
    
    properties
        
        pairDecisionTable
        softDecisionTable
        hardDecisionTable
        
    end
    
    methods
        
        function this = cStrategyBasic(rules)
            % Class constructor
            
            n = NaN; % Not possible
            
            if rules.dealerStandsS17
                
                if rules.doubleAfterSplit
                    
                    % Dealer shows:
                    %      2 3 4 5 6 7 8 9 T A
                    this.pairDecisionTable = [ ...
                        1   n n n n n n n n n n
                        2   1 1 1 1 1 1 0 0 0 0
                        3   1 1 1 1 1 1 0 0 0 0
                        4   0 0 0 1 1 0 0 0 0 0
                        5   0 0 0 0 0 0 0 0 0 0
                        6   1 1 1 1 1 0 0 0 0 0
                        7   1 1 1 1 1 1 0 0 0 0
                        8   1 1 1 1 1 1 1 1 1 1
                        9   1 1 1 1 1 0 1 1 0 0
                        10   0 0 0 0 0 0 0 0 0 0
                        11   1 1 1 1 1 1 1 1 1 1];
                    
                else
                    % double after split NOT allowed
                    
                    % Dealer shows:
                    %      2 3 4 5 6 7 8 9 T A
                    this.pairDecisionTable = [ ...
                        1   n n n n n n n n n n
                        2   0 0 1 1 1 1 0 0 0 0
                        3   0 0 1 1 1 1 0 0 0 0
                        4   0 0 0 1 0 0 0 0 0 0
                        5   0 0 0 0 0 0 0 0 0 0
                        6   1 1 1 1 1 0 0 0 0 0
                        7   1 1 1 1 1 1 0 0 0 0
                        8   1 1 1 1 1 1 1 1 1 1
                        9   1 1 1 1 1 0 1 1 0 0
                        10   0 0 0 0 0 0 0 0 0 0
                        11   1 1 1 1 1 1 1 1 1 1];
                    
                end
                
                % Dealer shows:
                %      2 3 4 5 6 7 8 9 T A
                this.softDecisionTable = [ ...
                    1   1 1 0 0 0 1 1 1 1 1
                    2   1 1 1 1 2 1 1 1 1 1
                    3   1 1 1 2 2 1 1 1 1 1
                    4   1 1 2 2 2 1 1 1 1 1
                    5   1 1 2 2 2 1 1 1 1 1
                    6   1 2 2 2 2 1 1 1 1 1
                    7   0 3 3 3 3 0 0 1 1 1
                    8   0 0 0 0 0 0 0 0 0 0
                    9   0 0 0 0 0 0 0 0 0 0];
                
                % Dealer shows:
                %      2 3 4 5 6 7 8 9 T A
                this.hardDecisionTable = [ ...
                    1   n n n n n n n n n n
                    2   1 1 1 1 1 1 1 1 1 1
                    3   1 1 1 1 1 1 1 1 1 1
                    4   1 1 1 1 1 1 1 1 1 1
                    5   1 1 1 1 1 1 1 1 1 1
                    6   1 1 1 1 1 1 1 1 1 1
                    7   1 1 1 1 1 1 1 1 1 1
                    8   1 1 1 1 1 1 1 1 1 1
                    9   1 2 2 2 2 1 1 1 1 1
                    10   2 2 2 2 2 2 2 2 1 1
                    11   2 2 2 2 2 2 2 2 2 1
                    12   1 1 0 0 0 1 1 1 1 1
                    13   0 0 0 0 0 1 1 1 1 1
                    14   0 0 0 0 0 1 1 1 1 1
                    15   0 0 0 0 0 1 1 1 4 1
                    16   0 0 0 0 0 1 1 4 4 4
                    17   0 0 0 0 0 0 0 0 0 0
                    18   0 0 0 0 0 0 0 0 0 0
                    19   0 0 0 0 0 0 0 0 0 0
                    20   0 0 0 0 0 0 0 0 0 0];
                
            else
                % dealer hits on soft 17
                
                if rules.doubleAfterSplit
                    
                    % Dealer shows:
                    %      2 3 4 5 6 7 8 9 T A
                    this.pairDecisionTable = [ ...
                        1   n n n n n n n n n n
                        2   1 1 1 1 1 1 0 0 0 0
                        3   1 1 1 1 1 1 0 0 0 0
                        4   0 0 0 1 1 0 0 0 0 0
                        5   0 0 0 0 0 0 0 0 0 0
                        6   1 1 1 1 1 0 0 0 0 0
                        7   1 1 1 1 1 1 0 0 0 0
                        8   1 1 1 1 1 1 1 1 1 2
                        9   1 1 1 1 1 0 1 1 0 0
                        10   0 0 0 0 0 0 0 0 0 0
                        11   1 1 1 1 1 1 1 1 1 1];
                    
                else
                    % double after split NOT allowed
                    
                    % Dealer shows:
                    %      2 3 4 5 6 7 8 9 T A
                    this.pairDecisionTable = [ ...
                        1   n n n n n n n n n n
                        2   0 0 1 1 1 1 0 0 0 0
                        3   0 0 1 1 1 1 0 0 0 0
                        4   0 0 0 1 0 0 0 0 0 0
                        5   0 0 0 0 0 0 0 0 0 0
                        6   1 1 1 1 1 0 0 0 0 0
                        7   1 1 1 1 1 1 0 0 0 0
                        8   1 1 1 1 1 1 1 1 1 2
                        9   1 1 1 1 1 0 1 1 0 0
                        10   0 0 0 0 0 0 0 0 0 0
                        11   1 1 1 1 1 1 1 1 1 1];
                    
                end
                
                % Dealer shows:
                %      2 3 4 5 6 7 8 9 T A
                this.softDecisionTable = [ ...
                    1   1 1 0 0 0 1 1 1 1 1
                    2   1 1 1 1 2 1 1 1 1 1
                    3   1 1 1 2 2 1 1 1 1 1
                    4   1 1 2 2 2 1 1 1 1 1
                    5   1 1 2 2 2 1 1 1 1 1
                    6   1 2 2 2 2 1 1 1 1 1
                    7   3 3 3 3 3 0 0 1 1 1
                    8   0 0 0 0 3 0 0 0 0 0
                    9   0 0 0 0 0 0 0 0 0 0];
                
                % Dealer shows:
                %      2 3 4 5 6 7 8 9 T A
                this.hardDecisionTable = [ ...
                    1   n n n n n n n n n n
                    2   1 1 1 1 1 1 1 1 1 1
                    3   1 1 1 1 1 1 1 1 1 1
                    4   1 1 1 1 1 1 1 1 1 1
                    5   1 1 1 1 1 1 1 1 1 1
                    6   1 1 1 1 1 1 1 1 1 1
                    7   1 1 1 1 1 1 1 1 1 1
                    8   1 1 1 1 1 1 1 1 1 1
                    9   1 2 2 2 2 1 1 1 1 1
                    10   2 2 2 2 2 2 2 2 1 1
                    11   2 2 2 2 2 2 2 2 2 2
                    12   1 1 0 0 0 1 1 1 1 1
                    13   0 0 0 0 0 1 1 1 1 1
                    14   0 0 0 0 0 1 1 1 1 1
                    15   0 0 0 0 0 1 1 1 4 4
                    16   0 0 0 0 0 1 1 4 4 4
                    17   0 0 0 0 0 0 0 0 0 5
                    18   0 0 0 0 0 0 0 0 0 0
                    19   0 0 0 0 0 0 0 0 0 0
                    20   0 0 0 0 0 0 0 0 0 0];
                
            end
            
        end
        
        function insuranceDecision = GetInsuranceDecision(this, handPlayer, ...
                trueCount)
            % Generates decision whether to take insurance
            % - insuranceDecision:
            % 0 = do not take
            % 1 = take
            
            insuranceDecision = 0;
            
        end
        
        function finalDecision = GetDecision(this, handPlayer, ...
                handDealer, trueCount, permit)
            % Generates 'Basic strategy' decision:
            % - finalDecision:
            % 0 = stand
            % 1 = hit
            % 2 = double
            % 3 = split
            % 4 = surrender            
            %%%
            % - aux. decision:
            % 0 = stand
            % 1 = hit
            % 2 = double down, if NA, then hit
            % 3 = double down, if NA, then stand
            % 4 = surrender, if NA, then hit
            % 5 = surrender, if NA, then stand
            % - aux. split:
            % 0 = split (if possible)
            % 1 = do not split
            % 2 = surrender, if NA, then split
            
            split = 0;            
            upcardDealer = handDealer.Value(1);
            playerTotal = handPlayer.Value();
            
            if playerTotal >= 21
                finalDecision = 0;
                return;
            end
            
            if handPlayer.IsPair()
                % consider a split
                
                aux = handPlayer.Value(1);
                split = this.pairDecisionTable(aux, upcardDealer);
                
            end
            if split == 2 && permit.surrender
                finalDecision = 4;
                return;
            elseif split == 2 && ~permit.surrender
                split = 1;
            end
            if split == 1 && permit.split
                finalDecision = 3;
                return;
            end
                                    
            if handPlayer.IsSoft()
                decision = this.softDecisionTable(playerTotal - 11, upcardDealer);
            else
                decision = this.hardDecisionTable(playerTotal, upcardDealer);
            end
            
            if decision == 1
                finalDecision = 1;
                return;
            end
            if decision == 0
                finalDecision = 0;
                return;
            end            
            if decision == 2 && ~permit.double
                finalDecision = 1;
                return;
            elseif decision == 2 && permit.double
                finalDecision = 2;
                return;
            end
            if decision == 3 && ~permit.double
                finalDecision = 0;
                return;
            elseif decision == 3 && permit.double
                finalDecision = 2;
                return;
            end
            if decision == 4 && ~permit.surrender
                finalDecision = 1;
                return;
            elseif decision == 4 && permit.surrender
                finalDecision = 4;
                return;
            end
            if decision == 5 && ~permit.surrender
                finalDecision = 0;
                return;
            elseif decision == 5 && permit.surrender
                finalDecision = 4;
                return;
            end
                        
        end
        
    end
    
end