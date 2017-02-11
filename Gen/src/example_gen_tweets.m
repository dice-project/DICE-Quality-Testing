%% This files illustrates the use of qt_gen on the example json file 
jsonFileName = 'wc2014-100.json'; % 100 messages
nMessages = 100;

%% Example 1: generate 10 messages drawn from 2 classes (tweets or retweets)
newJSONFileName = 'wc2014-gen-2.json';
tsField = 'publicationTime'; % timestamp field
clField = 'original'; % class field
isNumeric = 1; % is the class field numeric?
qt_gen(jsonFileName,newJSONFileName,nMessages,tsField,clField,isNumeric);

%% Example 2: generate 10 messages  from 83 classes (class = user id)
newJSONFileName = 'wc2014-gen-83.json';
tsField = 'publicationTime'; % timestamp field
clField = 'uid'; % class field
isNumeric = 0; % is the class field numeric? 
speedUp = 1.0; % rate speedup factor
qt_gen(jsonFileName,newJSONFileName,nMessages,tsField,clField,isNumeric,speedUp);
