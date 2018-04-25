@echo off

IF "%SFALIAS%"=="" SET /P SFALIAS="Your Salesforce DX Alias?  "

:UPDATE-DATA
REM Change the package ID for install newer version of Amazon Connect
echo Installing Amazon Connect Opent CTI Adapter...
sfdx force:package:install -u %SFALIAS% -i 04t46000000lYuyAAE
echo DONE
echo Checking installation status...
sfdx force:package:install:get -i 04t46000000lYuyAAE -u %SFALIAS%
echo DONE

:END
echo Installation completed