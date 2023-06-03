clc
clear
addpath('APF\','Model\','AStar\','DJ\','PRM\','RRT\','urdf\')
StubiRobot = LoadRobotModel('urdf\urdf\robot_model.urdf');
startConfig = [3.8906 1.1924 0.0000 0.0000 0.0001 1.9454]';
endConfig = [-0.9240 1.2703 1.9865 1.2394 1.7457 -2.0500]';
[q,qd,qdd,tvec,pp] = trapveltraj([homeConfiguration(StubiRobot),startConfig,endConfig],200);
% show(StubiRobot,startConfig);
axis equal;

for ii = 1:1:6
    subplot(2,3,ii)
    plot(tvec,qd(1,:))
    xlabel('t');
    ylabel(strcat({'Joint_'},{num2str(ii)},{'velocities'}),'Interpreter','none');
end


figure(2);
clf;
show(StubiRobot,homeConfiguration(StubiRobot));
title('机器人根据Home位姿、起点和终点位姿直接梯形速度的运动')
hold on
for i = 1:2:length(q)
    show(StubiRobot,q(:,i),"PreservePlot",false);%false 不留下重影
    poseNow = getTransform(StubiRobot, q(:,i),"link_6");%正运动学
    plot3(poseNow(1,4), poseNow(2,4), poseNow(3,4),'b.','MarkerSize',5);
    hold on
    drawnow
end



