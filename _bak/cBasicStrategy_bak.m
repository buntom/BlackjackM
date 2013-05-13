classdef cBasicStrategy < handle
    % Represents the 'Basic strategy' of Blackjack play
    
    properties
        
        pairStratTable
        softStratTable
        hardStratTable
        
    end
    
    methods
        
        function this = cBasicStrategy()
            % Class constructor
            
            n = NaN; % Not possible
            
            % Dealer shows:
            %      2 3 4 5 6 7 8 9 T A
            this.pairStratTable = [ ...
                1   n n n n n n n n n n
                2   1 1 1 1 1 1 0 0 0 0
                3   1 1 1 1 1 1 0 0 0 0
                4   0 0 0 1 0 0 0 0 0 0
                5   0 0 0 0 0 0 0 0 0 0
                6   1 1 1 1 1 1 0 0 0 0
                7   1 1 1 1 1 1 1 0 0 0
                8   1 1 1 1 1 1 1 1 1 1
                9   1 1 1 1 1 0 1 1 0 0
                10   0 0 0 0 0 0 0 0 0 0
                11   1 1 1 1 1 1 1 1 1 1];
            
            % Dealer shows:
            %      2 3 4 5 6 7 8 9 T A
            this.softStratTable = [ ...
                1   n n n n n n n n n n
                2   1 1 2 2 2 1 1 1 1 1
                3   1 1 2 2 2 1 1 1 1 1
                4   1 1 2 2 2 1 1 1 1 1
                5   1 1 2 2 2 1 1 1 1 1
                6   2 2 2 2 2 1 1 1 1 1
                7   0 2 2 2 2 0 0 1 1 0
                8   0 0 0 0 0 0 0 0 0 0
                9   0 0 0 0 0 0 0 0 0 0];
            
            % Dealer shows:
            %      2 3 4 5 6 7 8 9 T A
            this.hardStratTable = [ ...
                1   n n n n n n n n n n
                2   1 1 1 1 1 1 1 1 1 1
                3   1 1 1 1 1 1 1 1 1 1
                4   1 1 1 1 1 1 1 1 1 1
                5   1 1 1 1 1 1 1 1 1 1
                6   1 1 1 1 1 1 1 1 1 1
                7   1 1 1 1 1 1 1 1 1 1
                8   1 1 1 1 1 1 1 1 1 1
                9   2 2 2 2 2 1 1 1 1 1
                10   2 2 2 2 2 2 2 2 1 1
                11   2 2 2 2 2 2 2 2 2 2
                12   1 1 0 0 0 1 1 1 1 1
                13   0 0 0 0 0 1 1 1 1 1
                14   0 0 0 0 0 1 1 1 1 1
                15   0 0 0 0 0 1 1 1 1 1
                16   0 0 0 0 0 1 1 1 1 1
                17   0 0 0 0 0 0 0 0 0 0
                18   0 0 0 0 0 0 0 0 0 0
                19   0 0 0 0 0 0 0 0 0 0
                20   0 0 0 0 0 0 0 0 0 0];
            
        end
        
        function [strategy, split] = GetDecision(this, handPlayer, handDealer, trueCount)            
            % Generates 'Basic strategy' decision:
            % 0 = stand
            % 1 = hit
            % 2 = double down
                        
            split = 0;
            upcardDealer = cBlackjackSim.HandValue(handDealer(1));
            
            if (length(handPlayer) == 2) && (handPlayer(1) == handPlayer(2))
                % consider a split
                
                aux = cBlackjackSim.HandValue(handPlayer(1));
                split = this.pairStratTable(aux, upcardDealer);
                
            end
            
            softHand = (any(handPlayer == 1) && ...
                cBlackjackSim.HandValueHard(handPlayer) <= 10);
            playerTotal = cBlackjackSim.HandValue(handPlayer);
            
            if playerTotal >= 21
                strategy = 0;
                return;
            end
            
            if softHand                
                strategy = this.softStratTable(playerTotal - 11, upcardDealer);                
            else                
                strategy = this.hardStratTable(playerTotal, upcardDealer);                
            end
            
        end
        
    end
    
end