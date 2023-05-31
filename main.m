clc
clear
addpath('APF\','Model\','AStar\','DJ\','PRM\','RRT\','urdf\')
StubiRobot = LoadRobotModel('urdf\urdf\robot_model.urdf');
vertices =stlread('urdf\model\BallR100mm.stl');
box = collisionMesh(vertices.Points);
T = trvec2tform([0.3221,0.057,0.0]);
box.Pose = T;
worldCollisionArray = {box};
ax = exampleHelperVisualizeCollisionEnvironment(worldCollisionArray);
% checkCollision(box,StubiRobot);
% show(StubiRobot,homeConfiguration(StubiRobot),'Parent',ax);
axis([-2,2,-1,1,-0.2,2])

startConfig = [3.8906 1.1924 0.0000 0.0000 0.0001 1.9454]';
endConfig = [-0.9240 1.2703 1.9865 1.2394 1.7457 -2.0500]';
trans = getTransform(StubiRobot,endConfig,"base_link","link_6");
% show(StubiRobot,startConfig);
% show(StubiRobot,endConfig);
q = trapveltraj([homeConfiguration(StubiRobot),startConfig,endConfig],200,"EndTime",2);
hold on 
show(StubiRobot,startConfig);
title('机器人根据Home位姿、起点和终点位姿直接梯形速度的运动')
for i = 1:2:length(q)
    show(StubiRobot,q(:,i),"PreservePlot",false);%false 不留下重影
    poseNow = getTransform(StubiRobot, q(:,i),"base_link","link_6");%正运动学
    plot3(poseNow(1,4), poseNow(2,4), poseNow(3,4),'b.','MarkerSize',5)
    drawnow
end

% Initialize outputs
inCollision = false(length(q), 1); % Check whether each pose is in collision
worldCollisionPairIdx = cell(length(q),1); % Provide the bodies that are in collision
for i = 1:length(q)
    [inCollision(i),sepDist] = checkCollision(StubiRobot,q(:,i),worldCollisionArray,'IgnoreSelfCollision','on');
    [bodyIdx,worldCollisionObjIdx] = find(isnan(sepDist)); % Find collision pairs
    worldCollidingPairs = [bodyIdx,worldCollisionObjIdx];
    worldCollisionPairIdx{i} = worldCollidingPairs;
end
isTrajectoryInCollision = any(inCollision);
collidingIdx1 = find(inCollision,1);
collidingIdx2 = find(inCollision,1,"last");
% Identify the colliding rigid bodies.
collidingBodies1 = worldCollisionPairIdx{collidingIdx1}*[1 0]';
collidingBodies2 = worldCollisionPairIdx{collidingIdx2}*[1 0]';
% Visualize the environment.
ax = exampleHelperVisualizeCollisionEnvironment(worldCollisionArray);
% Add the robotconfigurations & highlight the colliding bodies.
show(StubiRobot,q(:,collidingIdx1),"Parent",ax,"PreservePlot",false);
exampleHelperHighlightCollisionBodies(StubiRobot,collidingBodies1 + 1,ax);
show(StubiRobot,q(:,collidingIdx2),"Parent"',ax);
exampleHelperHighlightCollisionBodies(StubiRobot,collidingBodies2 + 1,ax);
% checkCollision(box,q,worldCollisionArray)
