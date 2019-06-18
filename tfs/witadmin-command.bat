@echo on

SET WITADMIN_PATH="C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\"
SET COLLECTIONURL="http://localhost:8081/tfs/DefaultCollection"
SET PROJECTNAME="CxTeam"
SET FILENAME="Bug.xml"

:: listwitd: Displays the names of the work item types in the specified project in the Command Prompt window
REM %WITADMIN_PATH%\witadmin listwitd /collection:%COLLECTIONURL% /p:%PROJECTNAME%

:: exportwitd: Exports the definition of a work item type to an XML file, or to the Command Prompt window.
REM %WITADMIN_PATH%\witadmin exportwitd /collection:%COLLECTIONURL% /p:%PROJECTNAME% /f:%FILENAME% /n:Bug

:: importwitd: Imports work item types from an XML definition file into a project on a server that runs Team Foundation Server. If a work item type with the same name already exists, the new work item type definition overwrites the existing one. If the work item type does not already exist, this command creates a new work item type. To validate the XML that defines a work item type, but not import the file, you use the /v option.
REM %WITADMIN_PATH%\witadmin importwitd /collection:%COLLECTIONURL% /p:%PROJECTNAME% /f:%FILENAME%