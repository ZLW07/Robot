clc
clear
addpath('Model\','urdf\','Data\')
StubiRobot = LoadRobotModel('urdf\urdf\robot_model.urdf');

filename = 'RRTTraj.txt';
data = readmatrix(filename);
figure(1);
axis equal;
clf;
show(StubiRobot,homeConfiguration(StubiRobot));
title('机器人运动轨迹')
hold on
for i = 1:2:length(data)
    show(StubiRobot,data(i,:)',"PreservePlot",false);%false 不留下重影
    poseNow = getTransform(StubiRobot,data(i,:)',"link_6");%正运动学
    plot3(poseNow(1,4), poseNow(2,4), poseNow(3,4),'b.','MarkerSize',5);
    hold on
    drawnow
end

figure(2)
x =1:length(data);
y = data(:,1);
for ii = 1:1:6
    subplot(2,3,ii)
    plot(x, data(:,1))
    xlabel('t');
    ylabel(strcat({'Joint_'},{num2str(ii)},{'velocities'}),'Interpreter','none');
end