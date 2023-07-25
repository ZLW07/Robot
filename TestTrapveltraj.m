clc
clear
addpath('APF\','Model\','AStar\','DJ\','PRM\','RRT\','urdf\')
StubiRobot = LoadRobotModel('urdf\urdf\robot_model.urdf');
startConfig = [3.8906 1.1924 0.0000 0.0000 0.0001 1.9454]';
endConfig = [-0.9240 1.2703 1.9865 1.2394 1.7457 -2.0500]';
[q,qd,qdd,tvec,pp] = trapveltraj([homeConfiguration(StubiRobot),startConfig,endConfig],200);
figure(1);
show(StubiRobot,startConfig);
axis equal;

figure(2);
for ii = 1:1:6
    subplot(2,3,ii);
    plot(tvec,qd(1,:));
    xlabel('t');
    ylabel(strcat({'Joint_'},{num2str(ii)},{'velocities'}),'Interpreter','none');
end



