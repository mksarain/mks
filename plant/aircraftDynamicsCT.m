function dxdt = aircraftDynamicsCT(x,u)
%% These quadratic function's coefficients were obtained from fitting quadratic
% set of data of charge efficiency vs temperature

alpha = -0.0001;  % decreasing it beyond -0.0001 generates errors
beta = 0.01;    % decreasing it beyond 0.01 generates errors
gamma = 0.8807;

eta_b = alpha * x(1).^2 + beta .* x(1) + gamma;

%% Efficiencies
% eta_b = 0.9;
eta_c = 0.93;
eta_g = 0.9;
eta_r = 0.93;
eta_bus = 0.99;
eta_m = 0.9;
eta_i = 0.93;

%% Obtained from case 1 in the thesis
% opt_masses = [70, 290, 530, 50, 210, 0, 80, 330, 0, 200, 90, 500, 0, 130, 150, 70]; 

%% Orignal masses of components in the thesis
opt_masses = [16; 70; 530; 16; 70; 0; 16; 70; 0; 65; 25; 137; 0; 31; 35; 20];


%% Assumed reduction in mass of components
% opt_masses = [2; 8; 200; 2; 8; 0; 2; 8; 0; 8; 3; 14; 0; 4; 3; 2];

C_batt = 300* opt_masses(3) * 3600; % Case 1
%  C_batt = 150e3 * 3600;  % Case 2
%     C_batt = 100e3 * 3600; % Case 3

%% dimensions of CPs and HX obtained from the thesis, but remained unchanged 
% after assuming mass reduction
A_s = 2.262; % m^2
A_MD = 3.534;
A_hx = 60;
A_ram = 103;

h_cp = 8500; % W/(m^2.K)
h_hx = 10500;
h_ram = 17500;

% Thermal coolant and air properties were obtained from engineering toolbox
% website
cp_water = 4200;                % J/(kg.K) at 20C
cp_fl = 2800;                   % J/(kg.K) at 20C
cp = 0.5*cp_fl + 0.5* cp_water; % J/(kg.K)

cp_air = 1006; % J/(kg.K)

capacitance = cp * opt_masses;

capacitance(3) = C_batt;
capacitance(16) = cp_air * opt_masses(16);
C = diag(capacitance);



M_bar = [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 1 0 -1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
         -1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 1 1 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 1 0 0 -1 -1 0 0 0 0 1 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 1 1 0 0 0 0 -1 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 -1 -1 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 1 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 -1 0 0 0 0 0;
         0 0 0 0 0 0 1 0 0 0 0 0 -1 0 0 0 0 0 0 0 -1;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 -1 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0];

P = [u(1)*(1-eta_b*eta_c)/(eta_b*eta_c); 
    h_cp*A_s*(x(1)-x(2)); 
    u(1); 
    u(2)*cp*x(2); 
    h_cp*A_s*(x(4)-x(5));
    u(6)*(1-eta_bus)/(eta_m*eta_i);
    u(6)/(eta_m*eta_i);
    u(2)*cp*x(10); 
    u(2)*cp*x(5); 
    h_cp*A_s*(x(7)-x(8));
    (1-eta_g*eta_r)*u(5);
    eta_g*eta_r*u(5);
    u(6)*(1-eta_m*eta_i)/(eta_m*eta_i);
    h_cp*A_MD*(x(11)-x(12)); 
    u(2)*cp*x(8); 
    u(2)*cp*x(12); 
    u(2)*cp*x(14); 
    h_hx*A_hx*(x(14)-x(15)); 
    h_ram*A_ram*(x(15)-x(16)); 
    u(3)*cp_air*x(16);
    u(6)];

D = [0 0;
     0 0;
     0 0;
     0 0;
     0 0;
     0 0;
     0 0;
     0 0;
     0 1;
     0 0;
     0 0;
     0 0;
     0 0;
     0 0;
     0 0;
     1 0];

P_in = [u(3)*cp_air*u(4);
        u(5)];


dxdt = pinv(C)*M_bar * P + pinv(C)*D * P_in;