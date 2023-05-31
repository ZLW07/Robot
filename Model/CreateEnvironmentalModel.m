function ModelTree = CreateEnvironmentalModel(ModelDataPath,ModelName) 
% MYFUNCTION Build environmental model
%   INPUT:  ModelDataPath: The environmental model path(.stl)
%   INPUT:  ModelName: The environmental model name
%   OUTPUT: The rigidBodyTree
ModelTree = rigidBodyTree;
body1 = rigidBody(ModelName);
addVisual(body1,'Mesh',ModelDataPath);
jnt1 = rigidBodyJoint('jnt1','fixed');
body1.Joint = jnt1;
basename = ModelTree.BaseName;
addBody(ModelTree,body1,basename);
showdetails(ModelTree);
end