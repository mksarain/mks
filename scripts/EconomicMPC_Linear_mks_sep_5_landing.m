%% Economic MPC Control of Energy Management System of Hybrid Electric Aircraft
clear
clc
close all
%% Nonlinear MPC Design
% Economic MPC can be implemented with a nonlinear MPC controller. The
% prediction model has thirteen states and six inputs (two MV and four MDs).
% In this example, since we do not need an output function, assuming y = x.
nlobj = nlmpc(13,13,'MV',[1 2 3 4],'MD',[5 6 7 8]);
nlobj.States(1).Name = 'Tw_batt';
nlobj.States(2).Name = 'Tfl_batt';
nlobj.States(3).Name = 'SOC';
nlobj.States(4).Name = 'Tw_bus';
nlobj.States(5).Name = 'Tfl_bus';
nlobj.States(6).Name = 'Tw_gen';
nlobj.States(7).Name = 'Tfl_gen';
nlobj.States(8).Name = 'Ttank';
nlobj.States(9).Name = 'Tw_MD';
nlobj.States(10).Name = 'Tfl_MD';
nlobj.States(11).Name = 'Tfl1_HX';
nlobj.States(12).Name = 'Tw_HX';
nlobj.States(13).Name = 'Tfl2_HX';
nlobj.MV(1).Name = 'P_batt';
nlobj.MV(2).Name = 'P_gen';
nlobj.MV(3).Name = 'dot_m';
nlobj.MV(4).Name = 'dot_m_air';
nlobj.MD(1).Name = 'T_ram';
nlobj.MD(2).Name = 'P_prop';
nlobj.MD(3).Name = 'Speed';
nlobj.MD(4).Name = 'rho';

%%
% The nonlinear plant model is defined in |oxidationPlantDT|. It is a
% discrete-time model where a multistep explicit Euler method is used for
% integration. While this example uses a nonlinear plant model, you can
% also implement economic MPC using linear plant models.

 Ts = 60;
 nlobj.Ts = Ts;                                  % Sample time
 nlobj.Model.StateFcn = 'aircraft_dynamics_linear_landing';
 nlobj.Model.IsContinuousTime = true;

u0 = [69980, 178835, 4.135, 8.552];
x0 = [93988057444394599308387229/4422589792359066198000000; 14175896344014406900981/690059259222822000000; 0.95; 642296550198010131218710603/30958128546513463386000000; 99794188918686328306867/4830414814559754000000; 748871653711516104483208603/30958128546513463386000000; 109523475430206270118867/4830414814559754000000; 114489338227757388521/5840888530302000000; 1232797079008717771442215271/48366943538186816802000000; 118698981952749594118867/4830414814559754000000; 114489338227757388521/5840888530302000000; 1053909433374709813/54082301206500000; 8752431102689/450060759000];
%%
% In general, to improve computational efficiency, it is best practice to
% provide an analytical Jacobian function for the prediction model. In this
% example, you do not provide one because the simulation is fast enough.
%
% The relatively large sample time of |25| seconds used here is appropriate
% when the plant is stable and the primary objective is economic
% optimization. Prediction horizon is |2|, which gives a prediction time is
% 50 seconds.

nlobj.PredictionHorizon = 12;                    % Prediction horizon
nlobj.ControlHorizon = 5;                       % Control horizon

%%
% All the states in the prediction model must be positive based on first
% principles. Therefore, specify a minimum bound of zero for all states.
% nlobj.States(1).Min = 0;
% nlobj.States(1).Max = 60;
% nlobj.States(2).Min = 0;
% nlobj.States(2).Max = 80;
nlobj.States(3).Min = 0.2;
nlobj.States(3).Max = 1;
% nlobj.States(4).Min = 0;
% nlobj.States(4).Max = 90;
% nlobj.States(5).Min = 0;
% nlobj.States(5).Max = 80;
% nlobj.States(7).Min = 0;
% nlobj.States(7).Max = 90;
% nlobj.States(8).Min = 0;
% nlobj.States(8).Max = 80;
% nlobj.States(10).Min = 0;
% nlobj.States(10).Max = 80;
% nlobj.States(11).Min = 0;
% nlobj.States(11).Max = 90;
% nlobj.States(12).Min = 0;
% nlobj.States(12).Max = 80;
% nlobj.States(14).Min = 0;
% nlobj.States(14).Max = 80;
% nlobj.States(15).Min = 0;
% nlobj.States(15).Max = 90;
% nlobj.States(16).Min = 0;

%% 
P_ref = 300e3;
nlobj.MV(1).Min = 0;
% % nlobj.MV(1).Max = 800e3;
% % nlobj.MV(1).RateMax = 10e3;
% % nlobj.MV(1).RateMaxECR = 0.2;
% % nlobj.MV(1).RateMin = -25e3;
% % nlobj.MV(1).RateMinECR = 0.2;

nlobj.MV(2).Min = 0;
% nlobj.MV(2).Max = 1.4 * P_ref;
% % nlobj.MV(2).RateMin = -20e3;
% % nlobj.MV(2).RateMinECR = 0.05;

nlobj.MV(3).Min = 0;
nlobj.MV(3).Max = 8;
% % nlobj.MV(3).MaxECR = 0.2;

nlobj.MV(3).RateMin = -0.2;
% % % nlobj.MV(3).RateMax = 0.5;
nlobj.MV(3).RateMinECR = 0.05;
% % % nlobj.MV(3).RateMaxECR = 0.05;

% nlobj.MV(4).RateMin = -0.5;
% nlobj.MV(4).RateMax = 0.25;
% nlobj.MV(4).RateMinECR = 0.05;
% nlobj.MV(4).RateMaxECR = 0.05;
%% Custom Cost Function for Economic MPC
% Instead of using the standard quadratic objective function, a custom cost
% function is used as the replacement. 

nlobj.Optimization.CustomCostFcn = 'aircraftCostFcn';
nlobj.Optimization.ReplaceStandardCost = true;
nlobj.Optimization.CustomEqConFcn = 'aircraftEqCon'; 
nlobj.Optimization.CustomIneqConFcn = 'aircraftInEqCon';

%% Simulink Model with Economic MPC Controller
% Open the Simulink model.
mdl = 'EconomicMPC_Simulink_Linear_mks_sep_5_landing';
open_system(mdl)

%% Scope figure changes

% Simulate the model
open_system([mdl '/Status']);
sim(mdl);

%% SoC
% Access time and signal data from the logged scope data
time = ans.scopeData_SoC.time;          % Extract time vector
signal = squeeze(ans.scopeData_SoC.signals.values); % Extract signal values
% Create a MATLAB figure with custom font and title
% Create the figure
figure (1) ;
plot(time, signal, 'LineWidth', 1.5); % Plot the signal
grid on;

% Set axis font properties
ax = gca; % Get current axis handle
set(ax, 'FontName', 'Times', 'FontSize', 30); % Set font for axis labels and ticks
ax.XAxis.FontSize = 30; % Explicitly set X-axis font size
ax.YAxis.FontSize = 30; % Explicitly set Y-axis font size

% Customize plot labels and title
xlabel('Time (s)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
ylabel('State of charge (SoC)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
title('Constraint Satisfaction (SoC)', 'FontSize', 60, 'FontWeight', 'bold', 'Interpreter', 'latex');

% Add a legend
legend({'SoC'}, 'FontSize', 30, 'Interpreter', 'latex', 'Location', 'best');

% Adjust x-axis limits
xlim([0 4500]);
ylim([0.2 1]);

%% Status
time = ans.scopeData_Status.time;
signal = squeeze(ans.scopeData_Status.signals.values);
figure(2);
plot(time, signal, 'LineWidth', 1.5); % Plot the signal
grid on;

% Set axis font properties
ax = gca; % Get current axis handle
set(ax, 'FontName', 'Times', 'FontSize', 30); % Set font for axis labels and ticks
ax.XAxis.FontSize = 30; % Explicitly set X-axis font size
ax.YAxis.FontSize = 30; % Explicitly set Y-axis font size

% Customize plot labels and title
xlabel('Time (s)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
ylabel('Optimization status', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
title('Optimization Status', 'FontSize', 60, 'FontWeight', 'bold', 'Interpreter', 'latex');

% Add a legend
legend({'nlp.status'}, 'FontSize', 30, 'Interpreter', 'latex', 'Location', 'northeast');

% Adjust x-axis limits
xlim([0 4500]);
ylim([-2 3]);

%% Fluids
% Access the time vector
time = ans.scopeData_Fl.time; % Extract the time vector

% Access the signal values from the structure
signals = ans.scopeData_Fl.signals; % Extract the signals structure

% Initialize a figure
figure(3);
hold on; % Enable multiple plots on the same axes

% Loop through each signal and plot it
for i = 1:length(signals)
    signalValues = squeeze(signals(i).values); % Extract and reshape signal values
    
    % Use valid LaTeX syntax for signal labels
    labelText = strrep(signals(i).label, '_', '\_'); % Escape underscores for LaTeX interpreter
    
    plot(time, signalValues, 'LineWidth', 1.5, 'DisplayName', labelText); % Use the updated label
end

% Customize the plot
grid on;

% Customize axis properties
ax = gca;
ax.FontName = 'Times';
ax.XAxis.FontSize = 30; % Set x-axis font size
ax.YAxis.FontSize = 30; % Set y-axis font size

% Customize labels and title
xlabel('Time (s)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
ylabel('Temperature (C)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
title('Fluid Temperatures', 'FontSize', 60, 'FontWeight', 'bold', 'Interpreter', 'latex');

% Add a legend with custom font size
legend('FontSize', 30, 'Interpreter', 'latex', 'Location', 'northeast');

hold off; % Stop adding to the plot
ylim([20 40]);

%% Walls
% Access the time vector
time = ans.scopeData_W.time; % Extract the time vector

% Access the signal values from the structure
signals = ans.scopeData_W.signals; % Extract the signals structure

% Initialize a figure
figure(4);
hold on; % Enable multiple plots on the same axes

% Loop through each signal and plot it
for i = 1:length(signals)
    signalValues = squeeze(signals(i).values); % Extract and reshape signal values
    
    % Use valid LaTeX syntax for signal labels
    labelText = strrep(signals(i).label, '_', '\_'); % Escape underscores for LaTeX interpreter
    
    plot(time, signalValues, 'LineWidth', 1.5, 'DisplayName', labelText); % Use the updated label
end

% Customize the plot
grid on;

% Customize axis properties
ax = gca;
ax.FontName = 'Times';
ax.XAxis.FontSize = 30; % Set x-axis font size
ax.YAxis.FontSize = 30; % Set y-axis font size

% Customize labels and title
xlabel('Time (s)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
ylabel('Temperature (C)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
title('Wall Temperatures', 'FontSize', 60, 'FontWeight', 'bold', 'Interpreter', 'latex');

% Add a legend with custom font size
legend('FontSize', 30, 'Location', 'northeast');

hold off; % Stop adding to the plot
ylim([20 40]);

%% Power 
% Access the time vector
time = ans.scopeData_Power.time; % Extract the time vector

% Access the signal values from the structure
signals = ans.scopeData_Power.signals; % Extract the signals structure

% Initialize a figure
figure(5);
hold on; % Enable multiple plots on the same axes

% Loop through each signal and plot it
for i = 1:length(signals)
    signalValues = squeeze(signals(i).values); % Extract and reshape signal values
    
    % Clean and escape underscores for valid LaTeX syntax
    labelText = signals(i).label;
%     labelText = strrep(labelText, '_', '\_'); % Escape underscores
%     labelText = regexprep(labelText, '[^\x20-\x7E]', ''); % Remove non-printable characters
    
    stairs(time, signalValues, 'LineWidth', 1.5, 'DisplayName', labelText); % Use the updated label
end

% Customize the plot
grid on;

% Customize axis properties
ax = gca;
ax.FontName = 'Times';
ax.XAxis.FontSize = 30; % Set x-axis font size
ax.YAxis.FontSize = 30; % Set y-axis font size

% Customize labels and title
xlabel('Time (s)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
ylabel('Power (W)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
title('Power Distribution', 'FontSize', 60, 'FontWeight', 'bold', 'Interpreter', 'latex');

% Add a legend with custom font size
legend('FontSize', 30, 'Interpreter', 'latex', 'Location', 'northeast');

hold off; % Stop adding to the plot


%% Mass flow rates
% Access the time vector
time = ans.scopeData_flow.time; % Extract the time vector

% Access the signal values from the structure
signals = ans.scopeData_flow.signals; % Extract the signals structure

% Initialize a figure
figure(6);
hold on; % Enable multiple plots on the same axes

% Loop through each signal and plot it
for i = 1:length(signals)
    signalValues = squeeze(signals(i).values); % Extract and reshape signal values
    
    % Use valid LaTeX syntax for signal labels
    labelText = strrep(signals(i).label, '_', '\_'); % Escape underscores for LaTeX interpreter
    
    stairs(time, signalValues, 'LineWidth', 1.5, 'DisplayName', labelText); % Use the updated label
end

% Customize the plot
grid on;

% Customize axis properties
ax = gca;
ax.FontName = 'Times';
ax.XAxis.FontSize = 30; % Set x-axis font size
ax.YAxis.FontSize = 30; % Set y-axis font size

% Customize labels and title
xlabel('Time (s)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
ylabel('Mass flow rate (kg/s)', 'FontSize', 30, 'FontWeight', 'bold', 'Interpreter', 'latex');
title('Mass Flow Rates', 'FontSize', 60, 'FontWeight', 'bold', 'Interpreter', 'latex');

% Add a legend with custom font size
legend('FontSize', 30, 'Interpreter', 'latex', 'Location', 'northeast');

hold off; % Stop adding to the plot
 ylim([0 10]);


%% Simulate Model and Analyze Results
% % Run the simulation.
% open_system([mdl '/SoC']);
% open_system([mdl '/Power']);
% open_system([mdl '/Mass flow']);
% open_system([mdl '/States']);
% open_system([mdl '/Status']);
% open_system([mdl '/Slack']);
% sim(mdl)







