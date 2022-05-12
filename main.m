%% ========= Prepare the environment =========
clc;
clf;
clear;
close all;
format long;

% If there is no chart folder, create one
if ~exist("./charts", 'dir')
       mkdir("./charts");
       fprintf("A folder for charts has been created!")
end

%% ========= Preparation of weights and items values =========
% Call up random w and p values ​​of items with
% of the script included in the task statement
seed = 2142;
rng(seed);
N = 32;
items(:,1) = round(0.1+0.9*rand(N,1),1);
items(:,2) = round(1+99*rand(N,1));

%% ========= Selection of a given selection method and algorithm parameters =========
% choose a method by entering a number from 1 to 4 for choice, where:
% 1 - means the default settings of the ga () function
% 2 - a busy population of individuals
% 3 - classic solution
% 4 - fine tuning

choice = 2; % selecting a value outside the range 1-3 will invoke the tune method

switch choice
    case 1
        options = optimoptions('ga',...
            'PopulationType', 'bitstring',...
            'PlotFcn', @drawChart);

    case 2
        options = optimoptions('ga',...
            'PopulationType', 'bitstring',...
            'PlotFcn', @drawChart,...
            'MaxGenerations', 2500,...
            'MaxStallGenerations', 2500,...
            'PopulationSize', 100,...
            'EliteCount', 1,...
            'SelectionFcn', {@selectionroulette},...
            'CrossoverFraction', 0,...
            'MigrationInterval', 1,...
            'CrossoverFcn', 'crossoverscattered',...
            'MigrationFraction', 0.1,...
            'FitnessScalingFcn', 'fitscalingrank');

    case 3
        options = optimoptions('ga',...
            'PopulationType', 'bitstring',...
            'PlotFcn', @drawChart,...
            'MaxGenerations', 100,...
            'MaxStallGenerations', 100,...
            'PopulationSize', 30000,...
            'EliteCount', 0,...
            'SelectionFcn', {@selectionroulette},...
            'MigrationFraction', 0.0,...
            'CrossoverFraction', 1,...
            'CrossoverFcn', 'crossoversinglepoint',...
            'FitnessScalingFcn', 'fitscalingrank');

    otherwise
        options = optimoptions('ga',...
            'PopulationType', 'bitstring',...
            'PlotFcn', @drawChart,...
            'MaxGenerations', 13,...
            'MaxStallGenerations', 13,...
            'PopulationSize', 3000,...
            'EliteCount', 1,...
            'SelectionFcn', {@selectiontournament,6},...
            'CrossoverFraction', 1,...
            'MigrationFraction', 0.0,...
            'CrossoverFcn', 'crossoverscattered',...
            'FitnessScalingFcn', 'fitscalingprop');
end

%% ========= Algorithm invocation =========

maxWeight = 0.3 * sum(items(:,1)); % calculation of the maximum load capacity of a backpack equal to 30% of the total weights of all drawn items
penalty = 1 + max(items(:,2)./items(:,1)); % setting the penalty factor (related to the maximum value-to-weight ratio of items)

rng('shuffle'); % we use a pseudo-random number generator based on the current time, resulting in a sequence of random numbers on each invocation of rng
[vector, maxValue] = ga(@(model)fun(model, penalty, maxWeight, items),32,[],[],[],[],[],[],[],[], options); % invoking the solver with the appropriate settings (using the genetic algorithm)

%% ========= View a summary of the results of a method's solution =========
fprintf("\nbinary vector (sollution the problem) = " + num2str(vector));
fprintf("\ntotal weight = " + sum(vector*items(:,1)));
fprintf("\ntotal weight in relation to the maximum weight = " + sum(vector*items(:,1)) + '/' + maxWeight);
fprintf("\ntotal value of items in the backpack = " + -maxValue + '\n');

%% ========= Declaration and definition of the necessary functions =========

% the function responsible for the appropriate drawing of charts and their saving to the PNG format
function state = drawChart(~, state, flag)
    if isequal(flag,'iter') % support for subsequent iterations
        figure(1)
        plot(state.Generation, min(state.Score), 'r.')
        plot(state.Generation, max(state.Score), 'g.')
        plot(state.Generation, mean(state.Score), 'b.')
                
        figure(2)
        plot(state.Generation, var(state.Score), 'k.')

    elseif isequal(flag,'init') % support for chart initialization
        figure(1)
        ylabel("the value of the objective function")
        xlabel("generation")
        title("Maximum, minimum and average value of the objective function as a function of iteration (generations)")
        hold on;
        plot(state.Generation, min(state.Score), 'r.')
        plot(state.Generation, max(state.Score), 'g.')
        plot(state.Generation, mean(state.Score), 'b.')
        legend('minimum value','maximum value','average value','AutoUpdate','off')

        figure(2)
        title("Variance of the value of the objective function as a function of iteration (generations)")
        ylabel("the value of the objective function")
        xlabel("generation")
        hold on;

    elseif isequal(flag,'done') % obsługa zakończenia solvera (zapisanie wykresów) 
        figure(1)
        path = "./charts/min_max_avg.png";
        saveas(gcf,path);
        figure(2)
        path = "./charts/std.png";
        saveas(gcf,path);

    end
end

function value = fun(model, penalty, maxWeight, items)

    if model * items(:,1) > maxWeight % if the limit is exceeded, we call the external penalty function
        %, we use a minus because we are interested in the maximum
        %, we set limits related to the maximum weight and the adopted value of the penalty
        value = (-1) * model * items(:,2) + penalty*(model * items(:,1) - maxWeight); 

    else
        value = (-1) * model * items(:,2); % here we also return the value multiplied by the constant -1

    end  
end