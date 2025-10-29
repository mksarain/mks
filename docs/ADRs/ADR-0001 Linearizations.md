ADR-0001: Linearizations



Date 

Status: Completed



Context:

To develop linear Controller and linear plant linearizations were required.



Decision:

While finding equilibirium points through nonlinear controller and nonlinear plant. Different Response of input and states  was observed in Takeoff, Cruise and Landing because of which three linearizations for each section was planned. More than one equilibirium points were observed in Takeoff and Landing because of that average of all equilibirium points were considereded in that case.



Equilibirium points for linearizations



Take off					

&nbsp;		Mean	Highest	Lowest	Chosen Values

u1	Pbatt	295140	520300	69980	295140

u2	Pgen	319450	338900	300000	319450

u3	m\_dot	4,163	5,526	2,800	4163

u4    m\_dot\_ram 6,075	7,150	5	6075

x\_s	T\_ram	11,0335	14,94	7,127	110335

x\_t	P\_prop	449000	636000	262000	449000



Cruise						

&nbsp;			Mean	Highest	Lowest	Chosen Value

u1	Pbatt	69980				69980

u2	Pgen	300000				300000

u3	m\_dot	5,526	5,4805	5,526	5,435	5,4805

u4    m\_dot\_ram	7,150				7,150

x\_s	T\_ram	7,127				7,127

x\_t	P\_prop	262000				262000



Landing					

&nbsp;		Mean	Highest	Lowest	Chosen Values 

u1	Pbatt	34990	69980	0	69980

u2	Pgen	178835	300000	57670	178835

u3	m\_dot	4,135	5,435	2,835	4135

u4    m\_dot\_ram	8,552	9,954	7,150	8552

x\_s	T\_ram	11,0835	15,04	7,127	110835

x\_t	P\_prop	141165	262000	20330	141165



Consequences:

Three different A, B, E \& P0 Matrices were obtained for each case.

Matrices A, B, E \& P0 are derived as per Christopher T, Aksland, Andrew G, Alleyne

Matrix sizes 

A = 12\*12

B = 12\*4

E = 12\*2

P0 = 12\*1



Implementation notes:

SOC was not considered during linearizations, was embedded in plant after wards.



Graph based model Matrix sizes (C\*x = -M\*P + D\*Pin) for linearizations

C = Capacitance Matrix size 12\*12

X = Only states 1 to 13 were considered ommiting SOC which is third state, Matrix size 12\*1

M = Incidence Matrix size was 12\*20; - sign was included during equation calculation

P = Power flow 3 was ommited because of SOC ommision, Matrix size 20\*1 

D = Matrix size 12\*1, Because Pin is 1\*1

Pin = m\_dot\_ramU4\*cp\_air\*T\_ram, Matrix size 1\*1



