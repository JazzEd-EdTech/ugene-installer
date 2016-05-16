function Controller()
{
}

Controller.prototype.TargetDirectoryPageCallback = function()
{
    var widget = gui.currentPageWidget(); // get the current wizard page
    if (widget != null) {
        if (systemInfo.kernelType === "winnt") {
            if ( systemInfo.currentCpuArchitecture === "i386") {
                var programFiles = installer.environmentVariable("ProgramFiles");
            }
            if ( systemInfo.currentCpuArchitecture === "x86_64") {
                var programFiles = installer.environmentVariable("ProgramW6432");
            }
            if (programFiles != "") {
                installer.setValue("TargetDir", programFiles + "\\Unipro UGENE");
                widget.TargetDirectoryLineEdit.setText(programFiles + "\\Unipro UGENE");
            }
        }
    }
}
