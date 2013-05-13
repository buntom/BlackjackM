function [ ] = LoadAssembly( )
%% Load .NET assembly

% Define folder where to look for assemblies
assemblyFolder = cSetup.AssemblyFolder;

% Define assemblies to load (only those accessed directly from MATLAB)
assemblyList = {'BlackjackSim.dll'};

% Load assemblies
for i = 1:length(assemblyList)
    NET.addAssembly(fullfile(assemblyFolder, assemblyList{i}));
end

SetPrintCallbacks();

end

function [] = SetPrintCallbacks()
% Set print callback function (so that C# can write to MATLAB console)

callbackSetterId = 'MATLAB';
if ~BlackjackSim.External.LogCallbackSupport.IsCallbackSet(callbackSetterId);
    BlackjackSim.External.LogCallbackSupport.SetInformationCallback(@cPrintCallback.Information);
    BlackjackSim.External.LogCallbackSupport.SetInformationWithoutNewlineCallback(@cPrintCallback.InformationWithoutNewline);
    BlackjackSim.External.LogCallbackSupport.SetVerboseCallback(@cPrintCallback.Verbose);
    BlackjackSim.External.LogCallbackSupport.SetWarningCallback(@cPrintCallback.Warning);
    BlackjackSim.External.LogCallbackSupport.SetErrorCallback(@cPrintCallback.Error);
    BlackjackSim.External.LogCallbackSupport.CallbackSet(callbackSetterId);
end

end