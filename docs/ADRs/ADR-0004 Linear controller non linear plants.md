ADR-0004 Linear controller non linear plants



Date

Status: Completed



Context:



Non linear plant and MPC uses 16 nodes so changes in Simulink is required.



To run three separte linearized plants in a single Simulation with MPC. Options for different mpcs block were checked but because of application mismatch did not use any other. Mode approach was used to provide three plants to linearized mpc and linearized plant as a state function which switch based on runtime.



Decision:

Mode: 1=takeoff, 2=cruise, 3=Landing for plant and initial conditions both for plant used in plant mat file and for initial conditions in main script with changes in simulink



Consequences:

Optimization was stable for takeoff and landing part only even with switching of initial conditions



Implementation notes:
Sampling Time: 20 S
Prediction Horizon: 10
Control Horizon: 8

In main script for initial conditions switching IC vectors were used which are picked by simulnik using from Workspace block.

Controller switches these initial conditions based on time 

for viewing changes in Simulink open Simulink file



