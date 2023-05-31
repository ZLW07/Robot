function RobotModel = LoadRobotModel(UrdfFilePath)
%LOADROBOTMODEL 此处显示有关此函数的摘要
%   此处显示详细说明
RobotModel = importrobot(UrdfFilePath);
RobotModel.DataFormat = 'column';
showdetails(RobotModel);
end

