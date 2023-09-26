clc
clear
addpath("Main\","Data\CalibrationData\Adaptor\")
fid = fopen('axis.txt');
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





