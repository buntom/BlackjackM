classdef cBlackjackSim < handle
    % Represents Blackjack game simulator
    
    properties
        
        params
        rules
        strategy
        
    end
    
    methods
        
        function this = cBlackjackSim(params, rules)
            % Class constructor
            
            if nargin < 1
                params = [];
            end
            if nargin < 2
                rules = [];
            end
            
            % parameters' defaults:
            if ~isfield(params, 'nbrSimulations')
                params.nbrSimulations = 10^5;
            end
            if ~isfield(params, 'nbrPacksTotal')
                params.nbrPacksTotal = 6;
            end
            if ~isfield(params, 'penetrationThres')
                params.penetrationThres = 0.75;
            end
            if ~isfield(params, 'betSize')
                params.betSize = 1;
            end
            if ~isfield(params, 'betSizeMin')
                params.betSizeMin = 1;
            end
            if ~isfield(params, 'betSizeMax')
                params.betSizeMax = 1;
            end
            if ~isfield(params, 'betSizeType')
                params.betSizeType = 'fixed';
            end
            if ~isfield(params, 'betSizeTcScale')
                params.betSizeTcScale = [];
            end
            if ~isfield(params, 'initialWealth')
                params.initialWealth = 10000;
            end
            if ~isfield(params, 'riskAversionCoeff')
                params.riskAversionCoeff = 1;
            end
            if ~isfield(params, 'strategyType')
                params.strategyType = 'basic';
            end
            if ~isfield(params, 'randType')
                params.randType = 'matlab';
            end
            if ~isfield(params, 'customRandSeed')
                params.customRandSeed = 10;
            end
            
            % rules' defaults:
            if ~isfield(rules, 'doubleAfterSplit')
                rules.doubleAfterSplit = true;
            end
            if ~isfield(rules, 'maxNbrSplits')
                rules.maxNbrSplits = 1;
            end
            if ~isfield(rules, 'surrenderAllowed')
                rules.surrenderAllowed = false;
            end
            if ~isfield(rules, 'dealerStandsS17')
                rules.dealerStandsS17 = true;
            end
            if ~isfield(rules, 'insuranceAllowed')
                rules.insuranceAllowed = true;
            end
            
            this.params = params;
            this.rules = rules;
            
            switch params.strategyType
                
                case 'basic'
                    this.strategy = cStrategyBasic(rules);
                    
                case 'index'
                    this.strategy = cStrategyIndex(rules);
                    
                otherwise
                    error('Unknown strategy type given!')
                    
            end
            
        end
        
        function simData = Simulate(this, nbrSimulations)
            % Simulates blackjack hands
            
            if nargin < 2
                nbrSimulations = this.params.nbrSimulations;
            end
            
            switch this.params.randType
                
                case 'matlab'
                    random = [];
                    if ~isempty(this.params.customRandSeed)
                        rng(this.params.customRandSeed);
                    end
                    
                case 'csharp'
                    LoadAssembly();
                    if ~isempty(this.params.customRandSeed)
                        random = System.Random(this.params.customRandSeed);
                    else
                        random = System.Random();
                    end
                    
                otherwise
                    error('Unknown random type!')
                    
            end
            
            shoe = cCardShoe(this.params.nbrPacksTotal, random);
            % simData columns: payoff, nbrSplits, trueCount, betSize,
            %   betTotal
            simData = NaN(nbrSimulations, 5);
            indexFinished = 0;
            idTic = tic;
            wealth = this.params.initialWealth;
            
            for i = 1:nbrSimulations
                
                betSize = this.GetBetSize(wealth, shoe);
                
                if ~isempty(shoe.count)
                    simData(i,3) = shoe.count.trueCount;
                end
                betHandResult = this.BetHand(betSize, shoe);
                simData(i,1) = betHandResult.payoff;
                simData(i,2) = betHandResult.nbrSplits;
                simData(i,4) = betSize;
                simData(i,5) = betHandResult.betTotal;
                
                if shoe.penetration > this.params.penetrationThres
                    shoe.Reinitiate();
                end
                
                ratioFinished = i/nbrSimulations * 100;
                if fix(ratioFinished / 5) > indexFinished
                    indexFinished = indexFinished + 1;
                    elapsedTime = toc(idTic);
                    display(['Finished ' num2str(ratioFinished) '% in '...
                        num2str(elapsedTime/60) ' minutes.'])
                end
                
                wealth = wealth + betHandResult.payoff;
                
            end
            elapsedTime = toc(idTic);
            display(['FINISHED in ' num2str(elapsedTime/60) ' minutes.'])
            
        end
        
        function betSize = GetBetSize(this, wealth, shoe)
            % Returns bet size
            
            switch this.params.betSizeType
                
                case 'fixed'
                    betSize = this.params.betSize;
                    
                case 'tcVariable'
                    if ~isempty(shoe.count)
                        
                        trueCount = shoe.count.trueCount;
                        indexAux = find(this.params.betSizeTcScale(:,1) == ...
                            trueCount);
                        if ~isempty(indexAux)
                            betSize = 1/this.params.riskAversionCoeff * wealth  * ...
                                this.params.betSizeTcScale(indexAux,2);
                        elseif trueCount < this.params.betSizeTcScale(1,1)
                            betSize = 1/this.params.riskAversionCoeff * wealth  * ...
                                this.params.betSizeTcScale(1,2);
                        elseif trueCount > this.params.betSizeTcScale(end,1)
                            betSize = 1/this.params.riskAversionCoeff * ...
                                wealth  * this.params.betSizeTcScale(end,2);
                        end
                        betSize = round(betSize);
                        betSize = min(max(betSize, this.params.betSizeMin), ...
                            this.params.betSizeMax);
                        
                    else
                        
                        betSize = this.params.betSize;
                        
                    end
                    
                otherwise
                    error('Unknown bet size type given!')
                    
            end
            
        end
        
        function betHandResult = BetHand(this, betSize, shoe)
            % Bets a hand and calculates the result
            
            % initial deal
            handPlayer = cHand();
            handPlayer.InitDealPlayer(shoe);
            handDealer = cHand();
            handDealer.InitDealDealer(shoe);
            nbrSplits = 0;
            
            [playHandOutcome, nbrSplits] = this.PlayHand(handPlayer, ...
                handDealer, betSize, shoe, nbrSplits);
            
            payoff = this.Payoff(playHandOutcome, handDealer, shoe);
            
            betHandResult.payoff = payoff;
            betHandResult.nbrSplits = nbrSplits;
            betHandResult.betTotal = playHandOutcome.betTotal;
            
            % update count with the hole card revealed
            shoe.count.UpdateCounts(handDealer.cards(2), shoe.nbrPacksLeft);
            
        end
        
        function [playHandOutcome, nbrSplits] = ...
                PlayHand(this, handPlayer, handDealer, betSize, shoe, nbrSplits)
            % Plays hand of a player (after initial deal)
            
            surrenderDone = false;
            splitDone = (nbrSplits > 0);
            handPlayer.betSize = betSize;
            
            playHandOutcome.handsPlayed = [];
            playHandOutcome.betTotal = 0;
            playHandOutcome.insuranceBet = 0;
            playHandOutcome.surrenderDone = false;
            
            % consider insurance bet
            insuranceBet = 0;
            if handDealer.Value(1) == 11 && this.rules.insuranceAllowed && ...
                    ~splitDone
                
                insuranceDecision = this.strategy.GetInsuranceDecision(handPlayer, ...
                    shoe.count.trueCount);
                if insuranceDecision
                    insuranceBet = 0.5 * betSize;
                end
                
            end
            
            % player's play
            while handPlayer.Value() < 21 && ~surrenderDone && ...
                    ~handDealer.IsBlackjack()
                
                if splitDone
                    permit.double = this.rules.doubleAfterSplit && ...
                        handPlayer.NbrCards() == 2;
                else
                    permit.double = handPlayer.NbrCards() == 2;
                end
                permit.split = nbrSplits < this.rules.maxNbrSplits && ...
                    handPlayer.NbrCards() == 2 && handPlayer.IsPair();
                permit.surrender = this.rules.surrenderAllowed && ...
                    handPlayer.NbrCards() == 2 && ~splitDone;
                
                trueCount = shoe.count.trueCount;
                decision = this.strategy.GetDecision(handPlayer, ...
                    handDealer, trueCount, permit);
                
                switch decision
                    
                    case 0 % stand
                        break;
                        
                    case 1 % hit
                        handPlayer.Hit(shoe);
                        
                    case 2 % double down
                        handPlayer.doubleDone = true;
                        betSize = betSize * 2;
                        handPlayer.Hit(shoe);
                        break;
                        
                    case 3 % split
                        [handPlayer, handPlayerSplit] = handPlayer.Split(shoe);
                        nbrSplits = nbrSplits + 1;
                        
                        [playHandOutcomeSplit1, nbrSplits] = ...
                            this.PlayHand(handPlayerSplit, handDealer, betSize, shoe, nbrSplits);
                        
                        [playHandOutcomeSplit2, nbrSplits] = ...
                            this.PlayHand(handPlayer, handDealer, betSize, shoe, nbrSplits);
                        
                        playHandOutcome.handsPlayed = [...
                            playHandOutcomeSplit1.handsPlayed, ...
                            playHandOutcomeSplit2.handsPlayed];
                        playHandOutcome.betTotal = playHandOutcomeSplit1.betTotal + ...
                            playHandOutcomeSplit2.betTotal + insuranceBet;
                        playHandOutcome.insuranceBet = insuranceBet;
                        
                        return;
                        
                    case 4 % surrender
                        surrenderDone = true;
                        break;
                        
                    otherwise
                        warning(['Unknown decision code: ' num2str(decision) '!'])
                        break;
                        
                end
                
            end
            
            % return outcome info
            playHandOutcome.handsPlayed = [playHandOutcome.handsPlayed handPlayer];
            playHandOutcome.betTotal = betSize + insuranceBet;
            playHandOutcome.insuranceBet = insuranceBet;
            playHandOutcome.surrenderDone = surrenderDone;
            
        end
        
        function payoff = Payoff(this, playHandOutcome, handDealer, shoe)
            % Calculates payoff of a played hand
            
            insurancePayoff = cBlackjackSim.PayoffInsurance(handDealer, ...
                playHandOutcome.insuranceBet);
            handsTotal = length(playHandOutcome.handsPlayed);
            if handsTotal == 0
                error('Empty played hands list!')
            end
            split = handsTotal > 1;
            
            if playHandOutcome.surrenderDone
                if handsTotal > 1
                    error('Surrender done while hand has been split - should not happen!');
                end
                betSize = playHandOutcome.handsPlayed(1).betSize;
                payoff = -0.5 * betSize + insurancePayoff;
                return;
            end
            
            allBust = true;
            for i = 1:handsTotal
                allBust = allBust && playHandOutcome.handsPlayed(i).IsBust();
            end
            
            % dealer's play
            while ~allBust && (handDealer.Value() <= 16 || ...
                    (handDealer.Value() == 17 && handDealer.IsSoft() && ...
                    ~this.rules.dealerStandsS17))
                
                handDealer.Hit(shoe);
                
            end
            dealerTotal = handDealer.Value();
            
            payoff = 0;
            for i = 1:handsTotal
                
                handPlayer = playHandOutcome.handsPlayed(i);
                betSize = handPlayer.betSize;
                if handPlayer.doubleDone
                    betSize = 2* betSize;
                end
                playerTotal = handPlayer.Value();
                                
                if handPlayer.IsBlackjack() && ~handDealer.IsBlackjack() && ...
                        ~split
                    % blackjack won by player
                    payoff  = payoff + 1.5 * betSize;
                elseif playerTotal > 21
                    % player bust
                    payoff  = payoff - betSize;
                elseif dealerTotal > 21
                    % dealer bust
                    payoff = payoff + betSize;
                elseif playerTotal > dealerTotal
                    % player won
                    payoff = payoff + betSize;
                elseif playerTotal < dealerTotal
                    % dealer won
                    payoff = payoff - betSize;
                else
                    % push
                    payoff = payoff + 0;
                end
                
            end
            payoff = payoff + insurancePayoff;
            
        end
        
    end
    
    methods (Static = true)
        
        function payoff = PayoffInsurance(handDealer, insuranceBet)
            % Calculates insurance bet payoff
            
            if handDealer.IsBlackjack()
                payoff = insuranceBet * 2;
            else
                payoff = -insuranceBet;
            end
            
        end
        
    end
    
end
