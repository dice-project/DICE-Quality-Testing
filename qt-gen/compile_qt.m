%cd ..
mcc -m qt_gen_main.m -a ./lib/jsonlab-1.5/* -a ./lib/m3a/* -a ./lib/kpc-toolbox/*  -a ./lib/map/*  -a ./lib/map/*  -a ./lib/mmpp/*  -a ./lib/mtrace/*  -a ./lib/DERIVESTsuite/*
%cd bin/
if ispc
movefile readme.txt readme-win.txt
delete requiredMCRProducts.txt  
end
if isunix
movefile readme.txt readme-x86_64.txt
end