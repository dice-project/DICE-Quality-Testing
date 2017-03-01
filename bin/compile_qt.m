%cd ..
mcc -m qt_gen_main.m -a ./lib/jsonlab-1.5/* -a ./lib/m3a/*
%cd bin/
if ispc
movefile readme.txt readme-win.txt
delete requiredMCRProducts.txt  
end
if isunix
movefile readme.txt readme-x86_64.txt
end