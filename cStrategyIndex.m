classdef cStrategyIndex < IStrategy
    % Represents the 'Index numbers strategy' of Blackjack play
    
    properties
        
        pairDecisionTable
        softDoubleDecisionTable
        hardDoubleDecisionTable
        softStandDecisionTable
        hardStandDecisionTable
        
    end
    
    methods
        
        function this = cStrategyIndex(rules)
            % Class constructor
            
            n = NaN; % Not possible
            
            if rules.dealerStandsS17
                
                if rules.doubleAfterSplit
                    
                    % Dealer shows:
                    %      2 3 4 5 6 7 8 9 T A
                    this.pairDecisionTable = [ ...
                        1   n n n n n n n n n n
                        2   -3 -5 -7 -9 -Inf -Inf 5 Inf Inf Inf
                        3   0 -4 -7 -9 -Inf -Inf 4 Inf Inf Inf
                        4   Inf 6 1 -1 -4 repmat(Inf, 1, 5)
                        5   repmat(Inf, 1, 10)
                        6   -1 -4 -6 -8 -10 repmat(Inf, 1, 5)
                        7   -9 repmat(-Inf, 1, 5) 5 Inf Inf Inf
                        8   repmat(-Inf, 1, 8) 8i -Inf
                        9   -2 -3 -5 -6 -6 3 -8 -9 Inf 3
                        10   Inf 8 6 5 4 Inf Inf Inf Inf Inf
                        11   -Inf -Inf -Inf -Inf -Inf -9 -8 -7 -8 -3];
                    
                else
                    % no double after split
                    
                    % Dealer shows:
                    %      2 3 4 5 6 7 8 9 T A
                    this.pairDecisionTable = [ ...
                        1   n n n n n n n n n n
                        2   7 3 0 -4 -9 -Inf Inf Inf Inf Inf
                        3   8 3 0 -2 -9 -Inf Inf Inf Inf Inf
                        4   repmat(Inf, 1, 10)
                        5   repmat(Inf, 1, 10)
                        6   2 0 -3 -5 -7 repmat(Inf, 1, 5)
                        7   -9 repmat(-Inf, 1, 5) Inf Inf Inf Inf
                        8   repmat(-Inf, 1, 8) 6i -Inf
                        9   0 -2 -3 -4 -4 6 -8 -9 Inf 3
                        10   Inf 8 6 5 4 Inf Inf Inf Inf Inf
                        11   -Inf -Inf -Inf -Inf -Inf -9 -8 -7 -8 -3];
                    
                end
                
                % Dealer shows:
                %       2 3 4 5 6 7 8 9 T A
                this.softDoubleDecisionTable = [...
                    1   Inf 7 3 0 -1 repmat(Inf, 1, 5)
                    2   Inf 7 3 0 -1 repmat(Inf, 1, 5)
                    3   Inf 7 1 -1 -4 repmat(Inf, 1, 5)
                    4   Inf 7 0 -4 -9 repmat(Inf, 1, 5)
                    5   Inf 4 -2 -6 -Inf repmat(Inf, 1, 5)
                    6   1 -3 -7 -10 -Inf repmat(Inf, 1, 5)
                    7   0 -2 -6 -8 -10 repmat(Inf, 1, 5)
                    8   8 5 3 1 1 repmat(Inf, 1, 5)
                    9   10 8 6 5 4 repmat(Inf, 1, 5)];
                
                % Dealer shows:
                %       2 3 4 5 6 7 8 9 T A
                this.hardDoubleDecisionTable = [...
                    1   n n n n n n n n n n
                    2   repmat(Inf, 1, 10)
                    3   repmat(Inf, 1, 10)
                    4   repmat(Inf, 1, 10)
                    5   repmat(Inf, 1, 10)
                    6   repmat(Inf, 1, 10)
                    7   Inf Inf Inf 9 9 repmat(Inf, 1, 5)
                    8   Inf 9 5 3 1 repmat(Inf, 1, 5)
                    9   1 0 -2 -4 -6 3 7 Inf Inf Inf
                    10  -8 -9 -10 -Inf -Inf -6 -4 -1 4 4
                    11  repmat(-Inf, 1, 5) -9 -6 -4 -4 1
                    12  repmat(Inf, 1, 10)
                    13  repmat(Inf, 1, 10)
                    14  repmat(Inf, 1, 10)
                    15  repmat(Inf, 1, 10)
                    16  repmat(Inf, 1, 10)
                    17  repmat(Inf, 1, 10)
                    18  repmat(Inf, 1, 10)
                    19  repmat(Inf, 1, 10)
                    20  repmat(Inf, 1, 10)];
                
                % Dealer shows:
                %       2 3 4 5 6 7 8 9 T A
                this.softStandDecisionTable = [...
                    1   repmat(Inf, 1, 10)
                    2   repmat(Inf, 1, 10)
                    3   repmat(Inf, 1, 10)
                    4   repmat(Inf, 1, 10)
                    5   repmat(Inf, 1, 10)
                    6   repmat(Inf, 1, 10)
                    7   repmat(-Inf, 1, 7) Inf Inf 1
                    8   repmat(-Inf, 1, 10)
                    9   repmat(-Inf, 1, 10)];
                
                % Dealer shows:
                %       2 3 4 5 6 7 8 9 T A
                this.hardStandDecisionTable = [...
                    1   n n n n n n n n n n
                    2   repmat(Inf, 1, 10)
                    3   repmat(Inf, 1, 10)
                    4   repmat(Inf, 1, 10)
                    5   repmat(Inf, 1, 10)
                    6   repmat(Inf, 1, 10)
                    7   repmat(Inf, 1, 10)
                    8   repmat(Inf, 1, 10)
                    9   repmat(Inf, 1, 10)
                    10  repmat(Inf, 1, 10)
                    11  repmat(Inf, 1, 10)
                    12  3 2 0 -1 0 repmat(Inf, 1, 5)
                    13  0 -1 -3 -4 -4 repmat(Inf, 1, 5)
                    14  -3 -4 -6 -7 -7 repmat(Inf, 1, 5)
                    15  -5 -6 -7 -9 -9 10 10 8 4 10
                    16  -8 -10 repmat(-Inf, 1, 3)  9 7 5 0 8
                    17  repmat(-Inf, 1, 9) -6
                    18  repmat(-Inf, 1, 10)
                    19  repmat(-Inf, 1, 10)
                    20  repmat(-Inf, 1, 10)];
                
            else
                % dealer hits on soft 17
                
                if rules.doubleAfterSplit
                    
                    % Dealer shows:
                    %      2 3 4 5 6 7 8 9 T A
                    this.pairDecisionTable = [ ...
                        1   n n n n n n n n n n
                        2   -2 -5 -7 -9 -Inf -Inf 5 Inf Inf Inf
                        3   0 -3 -7 -9 -Inf -Inf 4 Inf Inf Inf
                        4   Inf 6 1 -1 -6 repmat(Inf, 1, 5)
                        5   repmat(Inf, 1, 10)
                        6   -2 -4 -6 -8 -10 repmat(Inf, 1, 5)
                        7   -10 repmat(-Inf, 1, 5) 5 Inf Inf Inf
                        8   repmat(-Inf, 1, 8) 8i -1
                        9   -2 -3 -5 -6 -6 3 -8 -9 Inf 3
                        10   Inf 8 6 5 4 Inf Inf Inf Inf Inf
                        11   -Inf -Inf -Inf -Inf -Inf -9 -8 -7 -8 -3];
                    
                else
                    % no double after split
                    
                    % Dealer shows:
                    %      2 3 4 5 6 7 8 9 T A
                    this.pairDecisionTable = [ ...
                        1   n n n n n n n n n n
                        2   7 3 0 -4 -7 -Inf Inf Inf Inf Inf
                        3   8 3 0 -2 -5 -Inf Inf Inf Inf Inf
                        4   repmat(Inf, 1, 10)
                        5   repmat(Inf, 1, 10)
                        6   1 -1 -3 -5 -7 repmat(Inf, 1, 5)
                        7   -9 -10 repmat(-Inf, 1, 4) Inf Inf Inf Inf
                        8   repmat(-Inf, 1, 8) 6i -1
                        9   -1 -2 -3 -4 -6 6 -8 -9 Inf 2
                        10   Inf 8 6 5 4 Inf Inf Inf Inf Inf
                        11   -Inf -Inf -Inf -Inf -Inf -9 -8 -7 -8 -4];
                    
                end
                
                % Dealer shows:
                %       2 3 4 5 6 7 8 9 T A
                this.softDoubleDecisionTable = [...
                    1   repmat(Inf, 1, 10)
                    2   Inf 7 3 0 -1 repmat(Inf, 1, 5)
                    3   Inf 7 1 -1 -4 repmat(Inf, 1, 5)
                    4   Inf 7 0 -4 -9 repmat(Inf, 1, 5)
                    5   Inf 4 -2 -6 -Inf repmat(Inf, 1, 5)
                    6   1 -3 -7 -10 -Inf repmat(Inf, 1, 5)
                    7   0 -2 -6 -8 -10 repmat(Inf, 1, 5)
                    8   8 5 3 1 1 repmat(Inf, 1, 5)
                    9   10 8 6 5 4 repmat(Inf, 1, 5)];
                
                % Dealer shows:
                %       2 3 4 5 6 7 8 9 T A
                this.hardDoubleDecisionTable = [...
                    1   n n n n n n n n n n
                    2   repmat(Inf, 1, 10)
                    3   repmat(Inf, 1, 10)
                    4   repmat(Inf, 1, 10)
                    5   repmat(Inf, 1, 10)
                    6   repmat(Inf, 1, 10)
                    7   Inf Inf Inf 9 9 repmat(Inf, 1, 5)
                    8   Inf 9 5 3 1 repmat(Inf, 1, 5)
                    9   1 0 -2 -4 -6 3 7 Inf Inf Inf
                    10  -8 -9 -10 -Inf -Inf -6 -4 -1 4 4
                    11  repmat(-Inf, 1, 5) -9 -6 -4 -4 1
                    12  repmat(Inf, 1, 10)
                    13  repmat(Inf, 1, 10)
                    14  repmat(Inf, 1, 10)
                    15  repmat(Inf, 1, 10)
                    16  repmat(Inf, 1, 10)
                    17  repmat(Inf, 1, 10)
                    18  repmat(Inf, 1, 10)
                    19  repmat(Inf, 1, 10)
                    20  repmat(Inf, 1, 10)];
                
                % Dealer shows:
                %       2 3 4 5 6 7 8 9 T A
                this.softStandDecisionTable = [...
                    1   repmat(Inf, 1, 10)
                    2   repmat(Inf, 1, 10)
                    3   repmat(Inf, 1, 10)
                    4   repmat(Inf, 1, 10)
                    5   repmat(Inf, 1, 10)
                    6   repmat(Inf, 1, 10)
                    7   repmat(-Inf, 1, 7) Inf Inf Inf
                    8   repmat(-Inf, 1, 10)
                    9   repmat(-Inf, 1, 10)];
                
                % Dealer shows:
                %       2 3 4 5 6 7 8 9 T A
                this.hardStandDecisionTable = [...
                    1   n n n n n n n n n n
                    2   repmat(Inf, 1, 10)
                    3   repmat(Inf, 1, 10)
                    4   repmat(Inf, 1, 10)
                    5   repmat(Inf, 1, 10)
                    6   repmat(Inf, 1, 10)
                    7   repmat(Inf, 1, 10)
                    8   repmat(Inf, 1, 10)
                    9   repmat(Inf, 1, 10)
                    10  repmat(Inf, 1, 10)
                    11  repmat(Inf, 1, 10)
                    12  3 2 0 -1 -3 repmat(Inf, 1, 5)
                    13  0 -1 -3 -4 -4 repmat(Inf, 1, 5)
                    14  -3 -4 -6 -7 -7 repmat(Inf, 1, 5)
                    15  -5 -6 -7 -9 -9 10 10 8 4 5
                    16  -8 -10 repmat(-Inf, 1, 3)  9 7 5 0 3
                    17  repmat(-Inf, 1, 9) -6
                    18  repmat(-Inf, 1, 10)
                    19  repmat(-Inf, 1, 10)
                    20  repmat(-Inf, 1, 10)];
                
            end
            
        end
        
        function split = GetSplitDecision(this, handPlayer, handDealer, ...
                trueCount)
            % Returns split decision:
            % - split:
            % 0 = do not split
            % 1 = split
            
            if ~handPlayer.IsPair()
                split = 0;
                return;
            end
            
            upcardDealer = handDealer.Value(1);
            aux = handPlayer.Value(1);
            indexNumber = this.pairDecisionTable(aux, upcardDealer);
            
            if isreal(indexNumber)
                split = trueCount >= indexNumber;
            else
                split = trueCount < abs(indexNumber);
            end
            
        end
        
        function double = GetDoubleDecision(this, handPlayer, handDealer, ...
                trueCount)
            % Returns double down decision:
            % - double:
            % 0 = do not double
            % 1 = double
            
            upcardDealer = handDealer.Value(1);
            playerTotal = handPlayer.Value();
            
            if handPlayer.IsSoft()
                
                indexNumber = this.softDoubleDecisionTable(playerTotal - 11, ...
                    upcardDealer);
                
            else
                
                indexNumber = this.hardDoubleDecisionTable(playerTotal, ...
                    upcardDealer);
                
            end
            
            double = trueCount >= indexNumber;
            
        end
        
        function stand = GetStandDecision(this, handPlayer, handDealer, ...
                trueCount)
            % Returns stand decision:
            % - stand:
            % 0 = do not stand (hit)
            % 1 = stand
            
            upcardDealer = handDealer.Value(1);
            playerTotal = handPlayer.Value();
            
            if handPlayer.IsSoft()
                
                indexNumber = this.softStandDecisionTable(playerTotal - 11, ...
                    upcardDealer);
                if trueCount == indexNumber
                    stand = round(rand);
                else
                    stand = trueCount > indexNumber;
                end
                
            else
                
                indexNumber = this.hardStandDecisionTable(playerTotal, ...
                    upcardDealer);
                stand = trueCount >= indexNumber;
                
            end
            
        end
        
        function finalDecision = GetDecision(this, handPlayer, handDealer, ...
                trueCount, permit)
            % Generates 'Index strategy' decision:
            % - finalDecision:
            % 0 = stand
            % 1 = hit
            % 2 = double
            % 3 = split
            % 4 = surrender     
            
            if handPlayer.Value() >= 21
                finalDecision = 0;
                return;
            end
            
            split = this.GetSplitDecision(handPlayer, handDealer, ...
                trueCount);
            if split && permit.split
                finalDecision = 3;
                return;
            end
            
            double = this.GetDoubleDecision(handPlayer, handDealer, ...
                trueCount);
            if double && permit.double
                finalDecision = 2;
                return;
            end
            
            stand = this.GetStandDecision(handPlayer, handDealer, ...
                trueCount);
            if stand
                finalDecision = 0;
            else
                finalDecision = 1;
            end
            
        end
        
        function insuranceDecision = GetInsuranceDecision(this, handPlayer, ...
                trueCount)
            % Generates decision whether to take insurance
            % - insuranceDecision:
            % 0 = do not take
            % 1 = take
            
            insuranceDecision =  trueCount >= 3;                
            
        end
        
    end
    
end