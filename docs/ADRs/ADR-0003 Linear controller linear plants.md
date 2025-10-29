ADR-0002 Linear controller linear plant



Date

Status: Completed



Context:

To run three separte linearized plants in a single Simulation with MPC. Options for different mpcs block were checked but because of application mismatch did not use any other. Mode approach was used to provide three plants to linearized mpc and linearized plant as a state function which switch based on runtime.



Decision:

Mode: 1=takeoff, 2=cruise, 3=Landing



Consequences:

Optimization was stable for takeoff and landing part only



Implementation notes:
Sampling Time: 20 S
Prediction Horizon: 20
Control Horizon: 8

Initial conditions: Landing initial conditions were used as they made whole model stable, no switchnig on initial conditions was done same as plant

Struct Array was used for mode switching



plant code Output wrapping

xdot12 = A \* x + B \* u + E \* \[x\_t; P\_s] + P0;   % 12x1

SoCdot = -1000/(837\*300\*630\*3600) \* u1;

Soc Addition in xdot

dxdt        = zeros(13,1);

dxdt(1:2)   = xdot12(1:2);

dxdt(3)     = SoCdot;

dxdt(4:13)  = xdot12(3:12);

