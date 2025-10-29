%% Custom stage cost function for Model Predictive Control (MPC)
% The same cost function used in the thesis exculding the masses of
% components term and the slack variable term.
function obj = aircraftCostFcn(X, U, e, data)
    % Initialize the objective function
    obj = 0;
    u = U(:,data.MVIndex(1:4));
    T_batt = X(:,1);

    d.p.R = zeros(4,4);
    d.p.Q = zeros(4,4);

    d.p.R(3,3) = 1;
    d.p.R(4,4) = 1;

    d.p.Q(3,3) = 1e2;
    d.p.Q(4,4) = 1e3;

    P_gen = U(:, data.MVIndex(2));
    P_ref = 300e3;
    
    alpha = 1e-4; 
    beta = 1e1; 
    T_ref = 20;

    g = 1e4;    % Slack variable weight
    % Iterate over the prediction horizon
    for k = 1:data.PredictionHorizon
        % Extract the control input at time k
        Uk = u(k, :);
        dUk = u(k+1,:) - u(k,:);

        % Compute the stage cost
        Ji = Uk * d.p.R * Uk';
        Ju = dUk * d.p.Q * dUk';
        Jp = alpha * (P_gen(k,:)-P_ref).^2;
        Jt = beta * (T_batt(k+1,:) - T_ref).^2;

        % Add the stage cost to the total objective function
         obj = obj + Ji + Ju + Jp  + Jt + g * e;
%         obj = obj + Ji + Ju + Jp+ g * e;
    end
end