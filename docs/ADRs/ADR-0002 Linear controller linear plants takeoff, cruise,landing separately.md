ADR-0002 Linear controller linear plants takeoff, cruise,landing separately



Date

Status: Completed



Context:

To run three separte linearized plants in a single Simulation with MPC. Options for different mpcs block were checked but because of application mismatch did not use any other. Enabled susbystem was used in Simulink to run three models in single simulations on the Basis of time of takeoff, cruise and landing



Decision:

First functionality of enabled susbsytem was checked on single plant and single MPC



Consequences:

Enabled Subsystem worked but merging of results of These three Systems was not practical as optimization Status could not added due to These reasons.

Takeoff 

As Simulation starts from Zero time after passing of enable subsytem time optimization Status remains same as last optimization Status for total Simulation time. 

Cruise

Optimization in cruise case as enable substem starts after some delay initial optimization of delay part is shown as Zero and after passing of enable subsytem time optimization Status remains same as last optimization Status for total Simulation time.

Landing

Optimization in landing case as enable substem starts after some delay initial optimization of delay part is shown as Zero and after passing of enable subsytem time optimization Status remains same as last optimization Status for total Simulation time.

&nbsp; 

Implementation notes:

Only changes in Simulink was made.

MPC was added inside enabled susbsystem to work for only fraction of time.

