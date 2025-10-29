ADR-0004 Linear controller non linear plants



Date

Status: Completed



Context:



Non linear plant and MPC uses 13 nodes so changes in Simulink is required.




Decision:


Only landing linearization is used in linera MPC


Consequences:

Optimization was stable for takeoff and landing part only 


Implementation notes:
Sampling Time: 20 S
Prediction Horizon: 10
Control Horizon: 8

for viewing changes in Simulink open Simulink file



