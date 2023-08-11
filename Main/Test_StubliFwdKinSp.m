clear
addpath("StuabliRobot\")
thetalist =[0; 0; 0; 0; 0; 0];
%{
期望值 T:
        1	0	0	0
        0	1	0	0.02
        0	0	1	0.92
        0	0	0	1
%}
T = StubliForwardKinSpace(thetalist);
