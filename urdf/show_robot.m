clear
clc
robot = importrobot('C:\Users\wei.zhang07\Desktop\urdf\urdf\robot_model.urdf');
q   = [6.0513-pi  -1.2767+pi/2    0.1328   -3.2572+pi/2   -0.0698    0.7795];
show(robot);
axes.CameraPositionMode = 'auto';
%% Define the trajectory as a circle with a radius of 0.15
t = (0:0.2:20)';
count = length(t);
center = [-0.25 0.6 0.46];
radius = 0.1;
theta = t*(2*pi/t(end));
points =(center + radius*[cos(theta) sin(theta) zeros(size(theta))])';
%% Draw the defined trajectory and inverse kinematics solution
hold on
plot3(points(1,:),points(2,:),points(3,:),'r')
ik = robotics.InverseKinematics('RigidBodyTree',robot);
weights = [0.1 0.1 0 1 1 1]; %Ȩ��
qInitial = robot.homeConfiguration;
%%
%ͨ����Ĺ켣ѭ��������Բ������ÿ�����ik����������ʵ��ĩ��λ�õĹؽ����ã��洢Ҫ�Ժ�ʹ�õ��������
for i = 1:size(points,2)
% Solve for the configuration satisfying the desired end effector
tform = rpy2tr(3.0,-3.14, 3.14);%��̬��ξ���
tform = trvec2tform(points(:,i)')*tform ;%ĩ��λ����ξ���
qSol(i,:) = ik('link_6',tform,weights,qInitial);%�����ؽڽǶ�
% Start from prior solution
qInitial = qSol(i,:);
end
%% ������ʾ
title('robot move follow the trajectory')
hold on
axis([-0.8 0.8 -0.8 0.85 0 1.3]);
for i = 1:size(points,2)
show(robot,qSol(i,:)','PreservePlot',false);%false��Ϊtrueʱ��������Ӱ��
pause(0.1)
plot3(points(1,i),points(2,i),points(3,i),'.','LineWidth',1);
end
hold off
