function qt_gen(JSONFileName,newJSONFileName,nSamples,timeStampField,classField,isClassFieldNumeric,speedUpFactor)
fout = 1;
fprintf(fout,'QT-GEN: loading JSON file... ')
messages = loadjson(JSONFileName);
fprintf(fout,'done. %d messages loaded.\n',length(messages))
%%
fprintf(fout,'QT-GEN: parsing messages...')
for i=1:length(messages)
    ts(i)=messages{i}.(timeStampField); % timestamps
    if isClassFieldNumeric
        classLabels(i)=messages{i}.(classField); % class
    else
        classLabels{i}=messages{i}.(classField); % class
    end
end
fprintf(fout,'done.\n')

fprintf(fout,'QT-GEN: listing message classes... ')
if isClassFieldNumeric
    classes = unique(classLabels);
    for i=1:length(messages)
        class(i)=find(classes==classLabels(i));
    end
else
    classes = unique(classLabels);
    for i=1:length(messages)
        class(i)=find(cellfun(@(x) strcmpi(x,classLabels{i}),classes));
    end
end
fprintf(fout,'done.\n')

fprintf(fout,'QT-GEN: fitting class timestamps...\n')
T = [ts(:),class(:)];
T = sortrows(T,1); % sort by timestamp
mtrace = m3afit_init([0;diff(T(:,1))],T(:,2)); % determine inter-event times
try
    M = m3afit_auto(mtrace,'NumStates',2,'Method',1); % fit the marked MAP
    fprintf(fout,'QT-GEN: %d class timestamps fitted.\n',length(unique(class)))
catch me
    fprintf(fout,'QT-GEN: %d class timestamps fitted failed. Aborting.\n')
    return
end

fprintf(fout,'QT-GEN: scaling trace rates (speedup=%d)',speedUpFactor)
Mscaled{1} = M{1} / speedUpFactor;
Mscaled{2} = M{2} / speedUpFactor;
for c = 1:(length(M)-2)
    Mscaled{2+c} = M{2+c} / speedUpFactor;
end
Mscale = mmap_normalize(Mscaled);
fprintf(fout,'done.\n')

fprintf(fout,'QT-GEN: generating new trace (%d samples)... ',nSamples)
[T,C] = mmap_sample(Mscaled,nSamples);
fprintf(fout,'done.\n')
%%
basets = min(ts);
timelag = round(T);
for i=1:nSamples
    pos = datasample(find(class==C(i)),1);
    newtrace{i} = messages{pos};
    newtrace{i}.(timeStampField) = basets + timelag(i);
end
fprintf(fout,'QT-GEN: saving new trace to disk... ')
savejson('',newtrace,'Filename',newJSONFileName,'SingletArray',0,'SingletCell',1);
fprintf(fout,'done.\n')
end