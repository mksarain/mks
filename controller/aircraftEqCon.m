function ceq = aircraftEqCon(X, U, data)
    eta_c = 0.93;
    eta_g = 0.9;
    eta_r = 0.93;
    eta_bus = 0.99;
    eta_m = 0.9;
    eta_i = 0.93;


    p = data.PredictionHorizon;

    u1 = U(1:p, data.MVIndex(1));
    u2 = U(1:p, data.MVIndex(2));
    md = U(1:p, data.MDIndex(2));

    ceq = eta_g * eta_r * u2 + eta_c * u1 - (md/(eta_bus * eta_m * eta_i));
