/*
DESCRIPTION
SqlAnchor core functions.

Filename : SqlAnchor.Core.js

HISTORY
???        (Niels Grove-Rasmussen) File created.
2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
*/


//***
//*** Main pages
//***

function DcsShow() {
    document.title = 'SqlAnchor > Domain Controllers';

    var DomainControllers = new Array('DNADM07.dn.lan', 'DNADM08.dn.lan', 'AD01.prod.dn.ext', 'AD01.pre.dn.ext', 'AD01.test.dn.ext', 'AD01.udv.dn.ext');

    var markup = '<h2>Domain Controllers</h2>' +
        '<table><thead><td>Computer name</td></thead>';
    for (var Computer in DomainControllers) {
        markup += '<tr><td>' + DomainControllers[Computer] + '&nbsp;' + buttonRemoteDesktop(DomainControllers[Computer]) + '</td></tr>';
    }
    markup += '</table>';

    MainArea.innerHTML = markup;
}  // DcsShow()

function ToolsShow() {
    document.title = 'SqlAnchor > Tools';

    var markup = '<h2>Tools</h2>' +
        '<p><a href="http://hpom01.sqladmin.lan:8081/OVPM/PMHome.jsp" title="Open HP Performance Manager (login = ********, pw = ********;).">HP Performance Manager</a></p>' +
        '<p><a href="http://hpom01.sqladmin.lan/hpov_reports/reports.htm" title="Open HP OpenView Reports">HP OpenView Reports</a></p>' +
        '<p><a href="https://172.16.42.123/vcops-vsphere/" title="Open vCenter Operations Manager (login = ********, pw = ********).">vCenter Operations Manager</a></p>' +
        '<p><a href="http://vnxapp028.sqladmin.lan:58080/VNX-MR/" title="Open EMC VNX (login = ********, pw = ********).">EMC VNX</a></p>' +
        '<p><a href="http://bsmgw01.sqladmin.lan/topaz" title="Open HP Business Service Management (login is your personal administrator&ndash;user).">HP Business Service Management (BSM)</a></p>' +
        '<p>&nbsp;</p>';

    MainArea.innerHTML = markup;
}  // ToolsShow()

function HelpShow() {
    document.title = 'SqlAnchor > Help';

    var WshNetwork = new ActiveXObject("WScript.Network");
    var ComputerName = WshNetwork.ComputerName;
    var UserDomain = WshNetwork.UserDomain;
    var UserName = WshNetwork.UserName;
    WshNetwork = null;
    var objUser = GetObject('WinNT://' + UserDomain + '/' + UserName);
    var markup = '<p>Welcome ' + objUser.FullName + ',</p>' +
        '<p>You are logged on the computer &bdquo;' + ComputerName + '&ldquo; as the user &bdquo;' + UserName + '@' + UserDomain + '&ldquo;.</p>' +
        '<p>Metadata is from the repository server &bdquo;' + OleDbDataSource + '&ldquo;.</p>' +
        '<p>The computer platform is ' + navigator.platform + ' and the browser is ' + navigator.appName + '.</p>' +
        '<h2>Source Code</h2>' +
        '<p>The Source Code of SqlAnchor is placed in the Codeplex project <a href="http://sqladmin.codeplex.com/" title="Codeplex &gt; SQLAdmin">SQLAdmin</a>.</p>' +
        '<h2>About</h2>' +
        '<p>Please contact <a href="http://dk.linkedin.com/in/nielsgrove" title="LinkedIn &gt; Niels Grove-Rasmussen">Niels&nbsp;Grove&ndash;Rasmussen</a>.</p>';
	/*markup += '<h2>AD info</h2>';
   markup += '<p>: ' + objUser.Info + '</p>';
	 markup += '<p>Description: ' + objUser.Description + '</p>';*/
    objUser = null;

    MainArea.innerHTML = markup;
}  // HelpShow()


/*
** HTML buttons
*/

function buttonSqlCmd(ComputerName, SqlDbInstanceName) {
    return '';  // Under Construction!

    var tag = '<input type="button" value="SQLCMD" ' +
        'onclick="openSqlCmd( \'' + ComputerName + '\', \'' + SqlDbInstanceName + '\');" ' +
        'title="Open Windows SQLCMD on &bdquo;' + ComputerName + '\\' + SqlDbInstanceName + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}

function buttonManagementStudio(SsdbName, ComputerName) {
    return '';  // No path for SqlWb.exe in environment when SQL2008R2 is installed

    var tag = '<input type="button" value="Management Studio" ' +
        'onclick="openManagementStudio( \'' + SsdbName + '\', \'' + ComputerName + '\' );" ' +
        'title = "Open SQL Server Management Studio for the database instance &bdquo;' + ComputerName + '\\' + SsdbName + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}


/*
** Open external applications
*/

function openRemoteDesktop(ComputerName) {
    var WshShell = new ActiveXObject("WScript.Shell");
    var CmdStr = "mstsc.exe /v:" + ComputerName;
    try { var oExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert("ERROR: Failed to start Remote Desktop (mstsc.exe) on the node " + ComputerName + ".\nWshShell.Exec() caught " + e);
        throw (e);
    }
    finally { WshShell = null; }
}

function openAdminRemoteDesktop(ComputerName) {
    var WshShell = new ActiveXObject("WScript.Shell");
    var CmdStr = "mstsc.exe -admin /v:" + ComputerName;
    try { var oExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert("ERROR: Failed to start Remote Desktop (mstsc.exe) on the node " + ComputerName + ".\nWshShell.Exec() caught " + e);
        throw (e);
    }
    finally { WshShell = null; }
}


function openComputerManagement(ComputerName) {
    var WshShell = new ActiveXObject("WScript.Shell");
    var WshSysEnv = WshShell.Environment("Process")
    var CmdStr = WshSysEnv("SystemRoot") + "\\system32\\mmc.exe compmgmt.msc /computer:" + ComputerName;
    try { var oExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert("ERROR: Failed to start Computer Management (compmgmt.msc) on the node " + ComputerName + ".\nWshShell.Exec() caught " + e);
        throw (e);
    }
    finally { WshShell = null; }
}

function openSqlCmd(ComputerName, SqlDbInstanceName) {
    alert('Under Construction...');
    return null;

    var WshShell = new ActiveXObject("WScript.Shell");
    var WshSysEnv = WshShell.Environment("Process")
    var SqlName_Full = (SqlDbInstanceName == '.' ? ComputerName : ComputerName + '\\' + SqlDbInstanceName);
    var CmdStr = WshSysEnv("ProgramFiles") + '\\Microsoft SQL Server\\100\Tools\\Binn\\SQLCMD.EXE -E -S ' + SqlName_Full;
    alert(CmdStr);
    try { var oExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert('ERROR: Failed to start SQLCMD (SQLCMD.EXE) on the node "' + ComputerName + '\\' + SqlDbInstanceName + "\".\nWshShell.Exec() caught " + e);
        throw (e);
    }
    finally { WshShell = null; }
}

function openManagementStudio(SqlInstanceName, ComputerName) {
    var WshShell = new ActiveXObject("WScript.Shell");
    var CmdStr = "SqlWb.exe -S " + ComputerName + "\\" + SqlInstanceName + " -E";
    try { var WshScriptExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert('ERROR: Failed to start Management Studio (SqlWb.exe) on SQL Server instance "' + ComputerName + "\\" + SqlInstanceName + "\".\nWshShell.Exec() caught " + e);
        throw (e);
    }
    finally { WshShell = null; }
}

function openShare(WindowsServerName, ShareName) {
    var WshShell = new ActiveXObject("WScript.Shell");
    var CmdStr = "explorer.exe /root,\\\\" + WindowsServerName + "\\" + ShareName;
    try { var WshScriptExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert("ERROR: Failed to start Windows Explorer on the drive '" + CmdStr + "'.\nWshShell.Exec() caught " + e);
        throw (e);
    }
    finally { WshShell = null; }
}

function openMMC(domain) {
    alert("openMMC( " + domain + " )");

    var domName = domain;
    var WshShell = new ActiveXObject("WScript.Shell");
    //var WshNetwork = new ActiveXObject("WScript.Network");
    var WshSysEnv = WshShell.Environment("Process")
    var CmdStr = WshSysEnv("SystemRoot") + "\\system32\\mmc.exe";
    try { var WshScriptExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert("ERROR: Failed to start Microsoft Management Console for the domain '" + domName + "'.\nWshShell.Exec() caught " + e.toString());
        throw (e);
    }
    finally { WshShell = null; }
}

function openWindowsShell(domain) {
    alert("Under Construction!");
    return null;

    var WshShell = new ActiveXObject("WScript.Shell");
    var WshSysEnv = WshShell.Environment("Process")
    var CmdStr = WshSysEnv("SystemRoot") + "\\system32\\cmd.exe";
    alert(CmdStr);
    try { var oExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert("ERROR: Failed to start Windows Shell (cmd.exe).\nWshShell.Exec() caught " + e);
        throw (e);
    }
    finally { WshShell = null; }
}

function openPowerShell(domain) {
    var WshShell = new ActiveXObject("WScript.Shell");
    var WshSysEnv = WshShell.Environment("Process")
    var CmdStr = WshSysEnv("SystemRoot") + "\\system32\\windowspowershell\\v1.0\\powershell.exe";
    try { var oExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert("ERROR: Failed to start PowerShell (powershell.exe).\nWshShell.Exec() caught " + e);
        throw (e);
    }
    finally { WshShell = null; }
}

function openSqlPowerShell(domain) {
    var WshShell = new ActiveXObject("WScript.Shell");
    var WshSysEnv = WshShell.Environment("Process")
    var CmdStr = WshSysEnv("ProgramFiles") + "\\Microsoft SQL Server\\100\\Tools\\Binn\\sqlps.exe";
    try { var oExec = WshShell.Exec(CmdStr); }
    catch (e) {
        alert("ERROR: Failed to start PowerShell (powershell.exe).\nWshShell.Exec() caught " + e);
        throw (e);
    }
    finally { WshShell = null; }
}

/*
** internal functions **
*/

function DateToIso8601(objDate) {
    objDate == null ? objDate = new Date() : null;
    // ToDo: Handle zero date (1970-01-01T1:0:0.0)

    var IsoDate = objDate.getFullYear() + '-' +
        (objDate.getMonth() < 9 ? '0' + (objDate.getMonth() + 1) : (objDate.getMonth() + 1)) + '-' +
        (objDate.getDate() < 10 ? '0' + objDate.getDate() : objDate.getDate()) + 'T' +
        (objDate.getHours() < 10 ? '0' + objDate.getHours() : objDate.getHours()) + ':' +
        (objDate.getMinutes() < 10 ? '0' + objDate.getMinutes() : objDate.getMinutes()) + ':' +
        (objDate.getSeconds() < 10 ? '0' + objDate.getSeconds() : objDate.getSeconds()); // + '.' +
    //(objDate.getMilliseconds() < 100 ? (objDate.getMilliseconds() < 10 ? '00' + objDate.getMilliseconds() : '0' + objDate.getMilliseconds()) : objDate.getMilliseconds());
    return IsoDate;
}

/*
Check if the user is administrator (Active Directory, Local Administrator)
*/
function isAdmin(UserName) {
}
