classdef cHand < handle
    % Represents a 'Blackjack hand'
    
    properties
        
        cards
        betSize
        doubleDone
                
    end
    
    methods
        
        function this = cHand(cards, betSize)
            % Class constructor
            
            if nargin < 1
                cards = [];
            end
            if nargin < 2
                betSize = 0;
            end
            
            this.cards = cards;
            this.betSize = betSize;
            this.doubleDone = false;
        
        end
                        
        function InitDealPlayer(this, shoe)
            % Resets the hand of a player, i.e. new initial deal of 2 cards
            
            this.cards = shoe.DealCard(2);
            
        end
        
        function InitDealDealer(this, shoe)
            % Resets the hand of a dealer, i.e. new initial deal of 2
            % cards, hole card does not update counts yet since it is not
            % seen
            
            this.cards = shoe.DealCard();
            this.cards = [this.cards shoe.DealCard(1, false)];
            
        end
        
        function nbrCards = NbrCards(this)
            % Returns nbr of held cards
            
            nbrCards = length(this.cards);
            
        end
        
        function Hit(this, shoe)
            % Hits (adds) a card to the hand
            
            this.cards = [this.cards shoe.DealCard()];
            
        end
        
        function value = Value(this, indexSelect)
            % Returns value of the hand (or particular cards)
            
            if nargin < 2                
                indexSelect = 1:length(this.cards);
            end                
            
            value = this.ValueHard(indexSelect);            
            % Use ace accordingly
            if any(this.cards(indexSelect) == 1) && value <= 11
                value = value + 10;
            end
            
        end
        
        function value = ValueHard(this, indexSelect)
            % Returns hard value of the hand (or particular cards)
            
            if nargin < 2                
                indexSelect = 1:length(this.cards);
            end
            
            value = sum(min(this.cards(indexSelect), 10));
            
        end
        
        function isBlackjack = IsBlackjack(this)
            % Checks whether the hand consists of a Blackjack (21)
            
            isBlackjack = false;
            if this.NbrCards() == 2 && this.Value() == 21
                isBlackjack = true;
            end
            
        end
        
        function isPair = IsPair(this)
            % Checks whether the hand consists of a pair or not
           
            isPair = false;
            if this.NbrCards() == 2 && this.Value(1) == this.Value(2)
                isPair = true;
            end               
            
        end
        
        function isBust = IsBust(this)
            % Checks whether the hand is bust
           
            isBust = this.Value() > 21;
            
        end
        
        function isSoft = IsSoft(this)
           % Checks whether the hand is soft or not 
            
           isSoft = false;
           if any(this.cards == 1) && this.ValueHard() <= 11
               isSoft = true;
           end
           
        end
        
        function [handPlayer, handPlayerSplit] = Split(this, shoe)
            % Splits the hand (with a pair)
            
            if ~this.IsPair()
                error('Cannot split the hand given - it is not a pair!')
            end
                        
            handPlayer = cHand(this.cards(1), this.betSize);
            handPlayer.Hit(shoe);
            
            handPlayerSplit = cHand(this.cards(2), this.betSize);
            handPlayerSplit.Hit(shoe);
            
        end
        
    end
    
end