@echo off

@echo off

cd %INSTALLATION_DIR%

rem Start AudioFor VATSIM
cd AudioForVATSIM\
START /B AudioForVATSIM.exe
cd ..

rem Start Euroscope
START /B EuroScope.exe
