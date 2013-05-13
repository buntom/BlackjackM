classdef cPrintCallback
    
    methods (Static = true)
        
        function [] = Information(message)
            
            fprintf('%s\n', char(message));
            
        end
        
        function [] = InformationWithoutNewline(message)
            
            fprintf(char(message));
            
        end
        
        function [] = Verbose(message)
            
            cprintf('Keywords', [cPrintCallback.ProcessMessage(message) '\n']);
            
        end
        
        function [] = Warning(message)
            
            cprintf('SystemCommands', [cPrintCallback.ProcessMessage(message) '\n']);
            
        end
        
        function [] = Error(message)
            
            cprintf('Errors', [cPrintCallback.ProcessMessage(message) '\n']);
            
        end
        
    end
    
    methods (Static = true, Access = private)
        
        function message = ProcessMessage(externalMessage)
            
            message = strrep(char(externalMessage), '\', '\\');
            message = strrep(message, '%', '%%');
            
        end
        
    end
    
end