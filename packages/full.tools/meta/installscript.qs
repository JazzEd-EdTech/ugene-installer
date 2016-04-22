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
        var component_root_path = installer.value("TargetDir");
        component_root_path = component_root_path.replace(/\//g, "\\");

        // Create dir
        component.addOperation( "Mkdir",
                                component_root_path + "/tools/");
        // Crate shortcut
        component.addOperation( "CreateShortcut",
                                component_root_path + "/tools/",
                                "@StartMenuDir@/Tools.lnk");
    }
}
