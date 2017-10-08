curdir=pwd;
cd ../qt-gen/
mcc -m qt_gen_main.m -a ./lib/jsonlab/* -a ./lib/m3a/* -a ./lib/kpc-toolbox/*  -a ./lib/map/*  -a ./lib/map/*  -a ./lib/mmpp/*  -a ./lib/mtrace/*  -a ./lib/DERIVESTsuite/*
if ispc
    movefile qt_gen_main.exe qtgen.exe
    movefile readme.txt readme-win.txt
    delete requiredMCRProducts.txt
    cd(curdir);
    movefile ../qt-gen/qtgen.exe .
    movefile ../qt-gen/readme-win.txt .
end
if isunix
    movefile readme.txt readme-x86_64.txt
end
