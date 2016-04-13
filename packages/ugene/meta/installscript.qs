/**************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Installer Framework.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file. Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** As a special exception, The Qt Company gives you certain additional
** rights. These rights are described in The Qt Company LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
**
** $QT_END_LICENSE$
**
**************************************************************************/

// Skip all pages and go directly to finished page.
// (see also componenterror example)
function cancelInstaller(message)
{
    installer.setDefaultPageVisible(QInstaller.Introduction, false);
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
    installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
    installer.setDefaultPageVisible(QInstaller.ReadyForInstallation, false);
    installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
    installer.setDefaultPageVisible(QInstaller.PerformInstallation, false);
    installer.setDefaultPageVisible(QInstaller.LicenseCheck, false);

    var abortText = "<font color='red'>" + message +"</font>";
    installer.setValue("FinishedText", abortText);
}

// Returns the major version number as int
//   string.split(".", 1) returns the string before the first '.',
//   parseInt() converts it to an int.
function majorVersion(str)
{
    return parseInt(str.split(".", 1));
}

function Component()
{
    //
    // Check whether OS is supported.
    //
    // For Windows and OS X we check the kernel version:
    //  - Require at least Windows Vista (winnt kernel version 6.0.x)
    //  - Require at least OS X 10.7 (Lion) (darwin kernel version 11.x)
    //
    // If the kernel version is older we move directly
    // to the final page & show an error.
    //
    // For Linux, we check the distribution and version, but only
    // show a warning if it does not match our preferred distribution.
    //

    // start installer with -v to see debug output
    console.log("OS: " + systemInfo.productType);
    console.log("Kernel: " + systemInfo.kernelType + "/" + systemInfo.kernelVersion);

    var validOs = false;

    if (systemInfo.kernelType === "winnt") {
        if (majorVersion(systemInfo.kernelVersion) >= 6)
            validOs = true;
    } else if (systemInfo.kernelType === "darwin") {
        if (majorVersion(systemInfo.kernelVersion) >= 11)
            validOs = true;
    } else {
        validOs = true;
    }

    if (!validOs) {
        cancelInstaller("Installation on " + systemInfo.prettyProductName + " is not supported");
        return;
    }

    //
    // Hide/select packages based on architecture
    //
    // Marking a component as "Virtual" will hide it in the UI.
    // Marking a component with "Default" will check it.
    //
    console.log("CPU Architecture: " +  systemInfo.currentCpuArchitecture);

    installer.componentByName("ugene.i386").setValue("Virtual", "true");
    installer.componentByName("ugene.x86_64").setValue("Virtual", "true");

    if ( systemInfo.currentCpuArchitecture === "i386") {
        installer.componentByName("ugene.i386").setValue("Virtual", "false");
        installer.componentByName("ugene.i386").setValue("Default", "true");
        installer.componentByName("ugene.i386").setValue("ForcedInstallation", "true");
    }
    if ( systemInfo.currentCpuArchitecture === "x86_64") {
        installer.componentByName("ugene.x86_64").setValue("Virtual", "false");
        installer.componentByName("ugene.x86_64").setValue("Default", "true");
        installer.componentByName("ugene.x86_64").setValue("ForcedInstallation", "true");
    }
    if (systemInfo.kernelType === "winnt") {
        if ( systemInfo.currentCpuArchitecture === "i386") {
            var programFiles = installer.environmentVariable("ProgramFiles");
        }
        if ( systemInfo.currentCpuArchitecture === "x86_64") {
            var programFiles = installer.environmentVariable("ProgramW6432");
        }
        if (programFiles != "")
            installer.setValue("TargetDir", programFiles + "/Unipro UGENE");

//        installer.installationFinished.connect(this, Component.prototype.installationFinishedPageIsShown);
//        installer.finishButtonClicked.connect(this, Component.prototype.installationFinished);
    }
}
Component.prototype.createOperations = function()
{
    component.createOperations();
    createShortcuts();
    registerFileTypes();
}
function createShortcuts()
{
    if (systemInfo.kernelType === "winnt") {
        var component_root_path = installer.value("TargetDir");
        component_root_path = component_root_path.replace(/\//g, "\\");

    	var windir = installer.environmentVariable("WINDIR");
        if (windir == "") {
            QMessageBox["warning"]( "Error" , "Error", "Could not find windows installation directory");
            return;
        }

        // UgeneUI
        component.addOperation( "CreateShortcut",
                                component_root_path + "/ugeneui.exe",
                                "@StartMenuDir@/UGENE.lnk");

        // UgeneCL
        var cmdLocation = windir + "\\system32\\cmd.exe";
        component.addOperation( "CreateShortcut",
                                cmdLocation,
                                "@StartMenuDir@/UGENECL.lnk", "workingDirectory=@TargetDir@", "/A /Q /K "+component_root_path + "/ugenecl.exe");
        // Maintaince
        component.addOperation( "CreateShortcut",
                                component_root_path + "/maintenancetool.exe", 
                                "@StartMenuDir@/Update.lnk", "--updater");
    }
}

function registerFileTypes()
{
    if (systemInfo.kernelType === "winnt") {
        var component_root_path = installer.value("TargetDir");
        component_root_path = component_root_path.replace(/\//g, "\\");
	var ugeneuiPath = component_root_path + "\\ugeneui.exe";

        //Project file
        component.addOperation("RegisterFileType",   "uprj",   ugeneuiPath + " %1", "Unipro UGENE project file", "text/plain", ugeneuiPath + ",0");

        //ABIF format
        component.addOperation("RegisterFileType",   "ab1",    ugeneuiPath + " %1", "ABIF file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "abi",    ugeneuiPath + " %1", "ABIF file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "abif",   ugeneuiPath + " %1", "ABIF file", "text/plain", ugeneuiPath + ",1");

        //ACE format
        component.addOperation("RegisterFileType",   "ace", ugeneuiPath + " %1", "ACE genome assembly", "text/plain", ugeneuiPath + ",1");

        //CLUSTAL format
        component.addOperation("RegisterFileType",   "aln",    ugeneuiPath + " %1", "Clustal alignment file", "text/plain", ugeneuiPath + ",1");

        //EMBL format
        component.addOperation("RegisterFileType",   "em",     ugeneuiPath + " %1", "EMBL file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "emb",    ugeneuiPath + " %1", "EMBL file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "embl",   ugeneuiPath + " %1", "EMBL file", "text/plain", ugeneuiPath + ",1");

        //Swiss-Prot format
        component.addOperation("RegisterFileType",   "sw",   ugeneuiPath + " %1", "Swiss-Prot file", "text/plain", ugeneuiPath + ",1");

        // Fasta
        component.addOperation("RegisterFileType",   "fa",    ugeneuiPath + " %1", "FASTA sequence file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "mpfa",  ugeneuiPath + " %1", "FASTA sequence file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "fna",   ugeneuiPath + " %1", "FASTA sequence file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "fas",   ugeneuiPath + " %1", "FASTA sequence file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "fasta", ugeneuiPath + " %1", "FASTA sequence file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "seq",   ugeneuiPath + " %1", "FASTA sequence file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "seqs",  ugeneuiPath + " %1", "FASTA sequence file", "text/plain", ugeneuiPath + ",1");

        //FASTQ format
        component.addOperation("RegisterFileType",   "fastq", ugeneuiPath + " %1", "FASTQ file", "text/plain", ugeneuiPath + ",1");

        //Genbank format
        component.addOperation("RegisterFileType",   "gb",      ugeneuiPath + " %1", "Genbank plain text file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "gbk",     ugeneuiPath + " %1", "Genbank plain text file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "gen",     ugeneuiPath + " %1", "Genbank plain text file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "genbank", ugeneuiPath + " %1", "Genbank plain text file", "text/plain", ugeneuiPath + ",1");

        //GFF format
        component.addOperation("RegisterFileType",   "gff",   ugeneuiPath + " %1", "GFF format", "text/plain", ugeneuiPath + ",1");

        //MSF format
        component.addOperation("RegisterFileType",   "msf",   ugeneuiPath + " %1", "MSF multiple sequence file", "text/plain", ugeneuiPath + ",1");

        //NEWICK format
        component.addOperation("RegisterFileType",   "nwk", ugeneuiPath + " %1", "NEWICK tree file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "newick", ugeneuiPath + " %1", "NEWICK tree file", "text/plain", ugeneuiPath + ",1");

        //PDB format
        component.addOperation("RegisterFileType",   "pdb", ugeneuiPath + " %1", "Protein Data Bank file", "text/plain", ugeneuiPath + ",1");

        //MMDB/PRT format
        component.addOperation("RegisterFileType",   "prt", ugeneuiPath + " %1", "MMDB file", "text/plain", ugeneuiPath + ",1");

        //SAM/BAM format
        component.addOperation("RegisterFileType",   "sam", ugeneuiPath + " %1", "SAM genome assembly", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "bam", ugeneuiPath + " %1", "BAM genome assembly", "text/plain", ugeneuiPath + ",1");

        //SCF format -> DISABLED: overrides show desktop icon!!
        //component.addOperation("RegisterFileType",   "scf", ugeneuiPath + " %1", "SCF file", "text/plain", ugeneuiPath + ",1");

        //Short Reads FASTA format
        component.addOperation("RegisterFileType",   "srfa",    ugeneuiPath + " %1", "FASTA short reads file", "text/plain", ugeneuiPath + ",1");
        component.addOperation("RegisterFileType",   "srfasta", ugeneuiPath + " %1", "FASTA short reads file", "text/plain", ugeneuiPath + ",1");

        //STOCKHOLM format
        component.addOperation("RegisterFileType",   "sto", ugeneuiPath + " %1", "Stockholm alignment file", "text/plain", ugeneuiPath + ",1");

        //UGENE Database format
        component.addOperation("RegisterFileType",   "ugenedb", ugeneuiPath + " %1", "UGENE Database", "text/plain", ugeneuiPath + ",1");

        //UGENE Query format
        component.addOperation("RegisterFileType",   "uql", ugeneuiPath + " %1", "UGENE Query Language", "text/plain", ugeneuiPath + ",1");

        //UGENE Workflow format
        component.addOperation("RegisterFileType",   "uwl", ugeneuiPath + " %1", "UGENE Workflow Language", "text/plain", ugeneuiPath + ",1");

    }
}
/*Component.prototype.installationFinishedPageIsShown = function()
{
    try {
        if (installer.isInstaller() && installer.status == QInstaller.Success) {
            installer.addWizardPageItem( component, "ReadMeCheckBoxForm", QInstaller.InstallationFinished );
        }
    } catch(e) {
        console.log(e);
    }
}

Component.prototype.installationFinished = function()
{
    try {
        if (installer.isInstaller() && installer.status == QInstaller.Success) {
            var isReadMeCheckBoxChecked = component.userInterface( "ReadMeCheckBoxForm" ).readMeCheckBox.checked;
            if (isReadMeCheckBoxChecked) {
                var component_root_path = installer.value("TargetDir");
                component_root_path = component_root_path.replace(/\//g, "\\");
                QDesktopServices.openUrl("file:///" + component_root_path + "\\ugeneui.exe"); //Working only for windows
            }
        }
    } catch(e) {
        console.log(e);
    }
} */
