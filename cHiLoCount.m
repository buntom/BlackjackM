classdef cHiLoCount < handle
    % Represents Hi-Lo counting system
    
    properties
        
        runningCount
        trueCount
        
    end
    
    methods
        
        function this = cHiLoCount()
            % Class constructor
           
            this.runningCount = 0;
            this.trueCount = 0;
            
        end
        
        function ResetCounts(this)
            % Resets counts
            
            this.runningCount = 0;
            this.trueCount = 0;
            
        end
        
        function UpdateCounts(this, cards, nbrPacksLeft)
            % Update counts
            
            for i = 1:length(cards)
                
                if cards(i) >= 10 || cards(i) == 1
                    this.runningCount = this.runningCount - 1;
                elseif cards(i) <= 6
                    this.runningCount = this.runningCount + 1;
                end
                
            end
            
            this.trueCount = fix(this.runningCount / nbrPacksLeft);
            
        end        
        
    end    
    
end