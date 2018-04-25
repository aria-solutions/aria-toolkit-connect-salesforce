@echo off

IF "%SFALIAS%"=="" SET /P SFALIAS="Your Salesforce DX Alias?  "

:ASSIGN_PERMISSIONS
sfdx force:user:permset:assign -n Amazon_Connect_Toolkit_Agent -u %SFALIAS%
sfdx force:user:permset:assign -n Amazon_Connect_Toolkit_Manager -u %SFALIAS%

:END
echo DONE