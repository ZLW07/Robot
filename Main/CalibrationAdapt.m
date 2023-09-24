clc
clear
addpath("Main\","Data\CalibrationData\Adaptor\")
fid = fopen('Cyl.txt');
Cylinder_Point = zeros(75,3);
Cylinder_Axis = zeros(75,3);
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
scatter3(Cylinder_Point(1:6,1),Cylinder_Point(1:6,2), Cylinder_Point(1:6,3));
fclose(fid);

fid = fopen('plane.txt');
Plane_Point = zeros(75,3);
Plane_Axis = zeros(75,3);
ii = 1;
while ~feof(fid)
    for ij = 1:1:3
        str = fgetl(fid);
        value = sscanf(str,'%f %f');
         Plane_Point(ii,ij) =value(1);
         Plane_Axis(ii,ij) =value(2);
    end
    ii = ii+1;
end
hold on
scatter3(Plane_Point(1:6,1),Plane_Point(1:6,2), Plane_Point(1:6,3));
fclose(fid);

Point = zeros(75,3);
for ji = 1:75
    vpt = Plane_Axis(ji,1)*Cylinder_Axis(ji,1) + Plane_Axis(ji,2)*Cylinder_Axis(ji,2) + Plane_Axis(ji,3)*Cylinder_Axis(ji,3);
    t = ((Plane_Point(ji,1) - Cylinder_Point(ji,1)*Plane_Axis(ji,1)) ...
    + (Plane_Point(ji,2) - Cylinder_Point(ji,2)*Plane_Axis(ji,2)) ...
    + (Plane_Point(ji,3) - Cylinder_Point(ji,3)*Plane_Axis(ji,3)))/vpt;
    Point(ji,1) = Cylinder_Point(ji,1) + Cylinder_Axis(ji,1)*t;
    Point(ji,2) = Cylinder_Point(ji,2) + Cylinder_Axis(ji,2)*t;
    Point(ji,3) = Cylinder_Point(ji,3) + Cylinder_Axis(ji,3)*t;
end




