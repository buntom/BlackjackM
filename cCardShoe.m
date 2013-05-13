classdef cCardShoe < handle
    % Represents a card shoe
   
    properties
        
        cards        
        nbrPacksTotal
        nbrPacksLeft
        penetration
        random
        
        count
                
    end
    
    methods
        
        function this = cCardShoe(nbrPacksTotal, random)
            % Class constructor
            
            if nargin < 1
                nbrPacksTotal = 6;
            end
            if nargin < 2
                random = [];
            end
            
            if ~isinf(nbrPacksTotal)
                
                this.random = random;
                this.InitiateCards(nbrPacksTotal, this.random);
                this.nbrPacksTotal = nbrPacksTotal;
                this.nbrPacksLeft = nbrPacksTotal;
                this.penetration = 0;
                this.count = cHiLoCount();                
                
            else
                
                this.random = random;
                this.cards = Inf;
                this.nbrPacksTotal = Inf;
                this.nbrPacksLeft = Inf;
                this.penetration = 0;
                this.count = [];                
                
            end
                            
        end        
               
        function Reinitiate(this)
            % Reinitiates the shoe
            
            if ~isinf(this.nbrPacksTotal)
                
                this.InitiateCards(this.nbrPacksTotal, this.random);            
                this.nbrPacksLeft = this.nbrPacksTotal;
                this.penetration = 0;

                this.count.ResetCounts();
                
            end
            
        end
        
        function Shuffle(this)
            % Shuffles the shoe
            
            if isempty(this.cards)
                warning('No cards to shuffle!');
                return;
            end
            if isinf(this.nbrPacksTotal)
                warning('Infinite shoe cannot be shuffled!')
                return;
            end
                        
            if isempty(this.random)
                indexAux = randperm(length(this.cards));
            else
                indexAux = 1 + double(BlackjackSim.Simulation.CardShoe.RandomPermutation(length(this.cards), this.random));
            end
            this.cards = this.cards(indexAux);
            
        end
        
        function cardsDealt = DealCard(this, nbrCards, doUpdateCount)
            % Deals a card from the shoe
            
            if nargin < 2 || isempty(nbrCards)
                nbrCards = 1;
            end
            if nargin < 3
                doUpdateCount = true;
            end
            
            if ~isinf(this.nbrPacksTotal)
                
                if length(this.cards) < nbrCards
                    error('Shoe is too empty or not initialized!');
                end
                cardsDealt = this.cards(end:-1:(end - nbrCards + 1));                
                this.cards((end - nbrCards + 1):end) = [];
                this.nbrPacksLeft = length(this.cards) / 52;
                this.penetration = 1 - length(this.cards) / ...
                    (this.nbrPacksTotal * 52);
                
                if doUpdateCount
                    this.count.UpdateCounts(cardsDealt, this.nbrPacksLeft);
                end
                
            else
                
                if isempty(this.random)
                    cards = ceil(rand(1, nbrCards) * 13);
                else
                    cards = NaN(1, nbrCards);
                    for i = 1:nbrCards
                        cards(i) = ceil(double(this.random.NextDouble()) * 13);
                    end
                end
                
            end
            
        end
        
        function InitiateCards(this, nbrPacks, random)
            % Initiates set of cards to fill a shoe
            
            if nargin < 3
                random = [];
            end            
            package = repmat(1:13, 1, 4);
            this.cards = repmat(package, 1, nbrPacks);
            if isempty(random)
                indexAux = randperm(length(this.cards));
            else
                indexAux = 1 + double(BlackjackSim.Simulation.CardShoe.RandomPermutation(length(this.cards), random));
            end
            this.cards = this.cards(indexAux);
            
        end
        
    end
    
end