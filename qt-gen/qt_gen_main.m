config_parameters = configfileread('qt_config.xml');

JSONFileName = config_parameters{1};
nSamples = str2double(config_parameters{2});
newJSONFileName = config_parameters{3};
timeStampField = config_parameters{4};
classField = config_parameters{5};
isClassFieldNumeric = str2double(config_parameters{6});
speedUpFactor = str2double(config_parameters{7});

qt_gen(JSONFileName,newJSONFileName,nSamples,timeStampField,classField,isClassFieldNumeric,speedUpFactor)