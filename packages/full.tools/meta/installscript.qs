function Component()
{
}

Component.prototype.createOperations = function()
{
    component.createOperations();
    createShortcuts();
}
function createShortcuts()
{
    if (systemInfo.kernelType === "winnt") {
        // Create a batch file with the development environment
        var component_root_path = installer.value("TargetDir");
        component_root_path = component_root_path.replace(/\//g, "\\");

        // Tools
        component.addOperation( "CreateShortcut",
                                component_root_path + "/tools/",
                                "@StartMenuDir@/Tools.lnk");
    }
}
