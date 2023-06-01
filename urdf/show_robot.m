clear
clc
robot = importrobot('E:\Project\MatlabProject\urdf\urdf\robot_model.urdf');
robot.DataFormat = 'column'
q = robot.homeConfiguration;
% q(6) = 3.14;
% q(1) = 0;
% [r1,r2,r3] = robot.checkCollision(q,'SkippedSelfCollisions','parent');

startConfig = [3.8906 1.1924 0.0000 0.0000 0.0001 1.9454];
trans = getTransform(robot,q,"link_6","base_link");
show(robot,q);
 axis equal;

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
weights = [0.1 0.1 0 1 1 1]; %

%%
for i = 1:size(points,2)
% Solve for the configuration satisfying the desired end effector
tform = rpy2tr(3.0,-3.14, 3.14);%
tform = trvec2tform(points(:,i)')*tform ;%
qSol(i,:) = ik('link_6',tform,weights,qInitial);%
% Start from prior solution
qInitial = qSol(i,:);
end

title('robot move follow the trajectory')
hold on
axis([-0.8 0.8 -0.8 0.85 0 1.3]);
for i = 1:size(points,2)
show(robot,qSol(i,:)','PreservePlot',false);%
pause(0.1)
plot3(points(1,i),points(2,i),points(3,i),'.','LineWidth',1);
end
hold off
