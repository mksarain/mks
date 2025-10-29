ADR-0002 Linear controller linear plants takeoff, cruise,landing separately



Date

Status: Completed



Context:

To run three separte linearized plants in a single Simulation with MPC. Options for different mpcs block were checked but because of application mismatch did not use any other. Enabled susbystem was used in Simulink to run three models in single simulations on the Basis of time of takeoff, cruise and landing



Decision:

First functionality of enabled susbsytem was checked on single plant and single MPC



Consequences:

Enabled Subsystem worked but merging of results of These three Systems was not practical as optimization Status could not added due to These reasons.

Takeoff (Stable)
Sampling Time: 60 S
Prediction Horizon: 10
Control Horizon: 5

As Simulation starts from Zero time after passing of enable subsytem time optimization Status remains same as last optimization Status for total Simulation time. 

Cruise (Stable)
Sampling Time: 20 S
Prediction Horizon: 20
Control Horizon: 8

Optimization in cruise case as enable substem starts after some delay initial optimization of delay part is shown as Zero and after passing of enable subsytem time optimization Status remains same as last optimization Status for total Simulation time.

Landing (Stable)
Sampling Time: 60 S
Prediction Horizon: 12
Control Horizon: 5

Optimization in landing case as enable substem starts after some delay initial optimization of delay part is shown as Zero and after passing of enable subsytem time optimization Status remains same as last optimization Status for total Simulation time.

&nbsp; 

Implementation notes:

Only changes in Simulink was made.

MPC was added inside enabled susbsystem to work for only fraction of time.

