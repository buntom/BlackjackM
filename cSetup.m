classdef cSetup
   
    properties (Constant = true)
        
        AssemblyFolder = 'B:\_misc\BlackjackSim\_myScripts\C#\bin';
        
    end
    
    methods (Static = true)
        
        function [] = Print()
                        
            fprintf('BlackJackSim configuration\n');
            fprintf('Assembly folder      : %s\n', cSetup.AssemblyFolder);            
            
        end
        
    end
    
end