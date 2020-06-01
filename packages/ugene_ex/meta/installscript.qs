function Component() {

}

Component.prototype.createOperations = function() {
    component.createOperations();
    createDesktopShortcuts();

    if (installer.isUpdater() && component.updateRequested()) {
        component.addOperation("SendStatistics", "http://ugene.net/installer_reports_dest.php");
    }
}

function createDesktopShortcuts()
{
    var component_root_path = installer.value("TargetDir");
    
    if (systemInfo.kernelType === "winnt") {
        try {
            component_root_path = component_root_path.replace(/\//g, "\\");

            var windir = installer.environmentVariable("WINDIR");
            if (windir == "") {
                QMessageBox["warning"]( "Error" , "Error", "Could not find windows installation directory");
                return;
            }

            component.addOperation("CreateShortcut",
                                   component_root_path + "/ugeneui.exe",
                                   "@DesktopDir@/UGENE.lnk");
        } catch (e) {
            console.log(e);
        }
    }
    if (systemInfo.kernelType === "linux") {
        try {
            component.addOperation("Copy",
                                   "@InstallerDirPath@/config/ugene.png",
                                   "@TargetDir@");
            
            component.addElevatedOperation("CreateDesktopEntry",
                                           "/usr/share/applications/UGENE.desktop",                                
                                           "Version=1.0\nType=Application\nTerminal=false\nExec=@TargetDir@/ugeneui\nName=UGENE\nIcon=@TargetDir@ugene.png\nName[en_US]=UGENE");
            component.addElevatedOperation("Copy",
                                           "/usr/share/applications/UGENE.desktop",
                                           "@HomeDir@/Desktop/UGENE.desktop");
        } catch (e) {
            console.log(e);
        }
    }
    if (systemInfo.kernelType === "darwin") {
        try {
            var argList = ["@InstallerDirPath@/config/makeAlias.sh",
                           "@TargetDir@/Contents/MacOS/ugeneui"];
            installer.execute("sh", argList);
        } catch (e) {
            console.log(e);
        }
    }
}

