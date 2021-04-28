let project = new Project('Obligatorio1');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');


//project.addDefine('DEBUGDRAW');
project.addDefine('debugInfo');



await project.addProject('khawy');

resolve(project);
