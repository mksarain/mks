function cineq = aircraftInEqCon(X, U, e, data)
    A_c = 0.1;
    dot_m_fan = 5;

    p = data.PredictionHorizon;

    U4 = U(1:p, data.MVIndex(4));
    X1 = X(2:p+1, 1);
    X2 = X(2:p+1, 2);
    X3 = X(2:p+1, 3);
    X4 = X(2:p+1, 4);
    X5 = X(2:p+1, 5);
    X6 = X(2:p+1, 6);
    X7 = X(2:p+1, 7);
    X8 = X(2:p+1, 8);
    X9 = X(2:p+1, 9);
    X10 = X(2:p+1, 10);
    X11 = X(2:p+1, 11);
    X12 = X(2:p+1, 12);

    V = U(1:p, data.MDIndex(3));
    rho = U(1:p, data.MDIndex(4));

    U4_Lb = rho .* V * A_c;
    U4_Ub = rho .* V * A_c + dot_m_fan;

    cineq = [U4_Lb - U4;
             U4 - U4_Ub;
             (10 - e) - X1;
             X1 - (50 + e);
             (10 - e) - X2;
             X2 - (70 + e);
%              0.1 - X3;
%              X3 - 1;
             (10 - e) - X4;
             X4 - (90 + e);
             (10 - e) - X5;
             X5 - (80 + e);
             (10 - e) - X6;
             X6 - (90 + e);
             (10 - e) - X7;
             X7 - (80 + e)
             (10 - e) - X8;
             X8 - (80 + e);
             (10 - e) - X9;
             X9 - (90 + e);
             (10 - e) - X10;
             X10 - (80 + e);
             (10 - e) - X11;
             X11 - (80 + e);
             (10 - e) - X12;
             X12 - (90 + e);
             ];

end