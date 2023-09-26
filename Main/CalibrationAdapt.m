clc
clear
addpath("Main\","Data\CalibrationData\Adaptor\",'StuabliRobot\')
fid = fopen('axis.txt');
%% Cylinder axis and point 
Cylinder_Point = [];
Cylinder_Axis = [];
ii = 1;
tmp = zeros(3,3);
while ~feof(fid)
    for ij = 1:1:3
        str = fgetl(fid);
        value = sscanf(str,'%f %f');
         Cylinder_Point(ii,ij) =value(1);
         Cylinder_Axis(ii,ij) =value(2);
    end
    ii = ii+1;
end
fclose(fid);

%% plane axis and point 
fid = fopen('plane_xy.txt');
Plane_Point_tmp = [];
Plane_Axis_tmp = [];
ii = 1;
while ~feof(fid)
    for ij = 1:1:3
        str = fgetl(fid);
        value = sscanf(str,'%f %f');
         Plane_Point_tmp(ii,ij) =value(1);
         Plane_Axis_tmp(ii,ij) =value(2);
    end
    ii = ii+1;
end
hold on
fclose(fid);

Plane_Point = [];
Plane_Axis = [];
for id = 1:6: length(Plane_Point_tmp)
    for di = 0:2
        Plane_Point= [Plane_Point;Plane_Point_tmp(id + di,:)];
        Plane_Axis= [Plane_Axis;Plane_Axis_tmp(id + di,:)];
    end
end


%% Point of intersection
Point = [];
index = 1;
for number = 0: length(Plane_Point)/3 -1
    for jii = 1:3
        for ji = 1:2
            vpt = Plane_Axis(jii +number*3,1)*Cylinder_Axis(ji +number*2,1) + Plane_Axis(jii +number*3,2)*Cylinder_Axis(ji+number*2,2) ...
                + Plane_Axis(jii +number*3,3)*Cylinder_Axis(ji+number*2,3);
            t = ((Plane_Point(jii +number*3,1) - Cylinder_Point(ji+number*2,1)*Plane_Axis(jii +number*3,1)) ...
            + (Plane_Point(jii +number*3,2) - Cylinder_Point(ji+number*2,2)*Plane_Axis(jii +number*3,2)) ...
            + (Plane_Point(jii +number*3,3) - Cylinder_Point(ji+number*2,3)*Plane_Axis(jii +number*3,3)))/vpt;
    
            Point(index,1) = Cylinder_Point(ji+number*2,1) + Cylinder_Axis(ji+number*2,1)*t;
            Point(index,2) = Cylinder_Point(ji+number*2,2) + Cylinder_Axis(ji+number*2,2)*t;
            Point(index,3) = Cylinder_Point(ji+number*2,3) + Cylinder_Axis(ji+number*2,3)*t;
            index = index+1;
        end
    end
end

joint_num = [];
num = 0;
points = [];
for iIndex = 1:6:length(Point)
    num = num +1;
    tmpPoint = [];
    sub1 = norm(Point(iIndex,:) - Point(iIndex+2,:),2);
    sub2 = norm(Point(iIndex,:) - Point(iIndex+4,:),2);
    sub3 = norm(Point(iIndex +2,:) - Point(iIndex+4,:),2);
    if((sub1 < 0.5))
          tmpPoint = [tmpPoint;Point(iIndex,:)];
          tmpPoint = [tmpPoint;Point(iIndex+1,:)];
          tmpPoint = [tmpPoint;Point(iIndex+2,:)];
          tmpPoint = [tmpPoint;Point(iIndex+3,:)];
          if((sub3 < 0.5))
            tmpPoint = [tmpPoint;Point(iIndex+4,:)];
            tmpPoint = [tmpPoint;Point(iIndex+5,:)];
          end
          joint_num = [joint_num;num];
    else
        if((sub2 < 0.5))
          tmpPoint = [tmpPoint;Point(iIndex,:)];
          tmpPoint = [tmpPoint;Point(iIndex+1,:)];
          tmpPoint = [tmpPoint;Point(iIndex+4,:)];
          tmpPoint = [tmpPoint;Point(iIndex+5,:)];
          joint_num = [joint_num;num];
        else
            if(sub3 <0.5)
                tmpPoint = [tmpPoint;Point(iIndex+2,:)];
                tmpPoint = [tmpPoint;Point(iIndex+3,:)];
                tmpPoint = [tmpPoint;Point(iIndex+4,:)];
                tmpPoint = [tmpPoint;Point(iIndex+5,:)];
                joint_num = [joint_num;num];
            end 
        end
    end
    [m,n] = size(tmpPoint);
    if(m>2)
        data = [0,0,0];
         for ii = 1: m
          data = data + tmpPoint(ii,:);
        end
        data =data/m;
        points = [points;data];
    end
end








