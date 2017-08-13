/*
DESCRIPTION
Computer in SQLAnchor.

HISTORY
2017-08-13 (Niels Grove-Rasmussen) Comments converted to JSDoc.
2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
2014-10-24 (Niels Grove-Rasmussen) File created. Initial content pasted from SqlAnchor.hta, SqlAnchor.Core.js and SqlAnchor.DetailPages.js
*/

/**
 * @description List computers active in SQLAdmin Repository.
 * ???        (NGR) Function created.
 * 2014-10-30 (NGR) Function changed from SSDB count to MSSQL count.
 */
function ComputersShow() {
    document.title = 'SqlAnchor > Computers';

    cmdDbaRepository.CommandText = '[sqlanchor].[computer_summary-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    var ComputerCount = rstDbaRepository.Fields("computer_count").Value;
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    var markup = '<h1>Computer</h1>' +
        '<p>There are registered ' + ComputerCount + ' active computers in the SQLAdmin Repository.</p>' +
        '<table><thead><td><a title="Full Domain Name (FQDN) of computer.">Computer Name</a></td>' +
        '<td><a title="Number of SQL Server services in the computer.">MSSQL Count</a></td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[computer-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields('computer_name').Value;
        markup += "<tr><td>" + linkComputerDetails(ComputerName) + '&nbsp;' + buttonComputerManagement(ComputerName) + buttonRemoteDesktop(ComputerName) + buttonAdminRemoteDesktop(ComputerName) + '</td>';
        var DbCount = rstDbaRepository.Fields('mssql_count').Value;
        markup += (DbCount == 0 ? '<td class="empty">' : '<td>' + DbCount) + '</td>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    markup += '</table>';

    MainArea.innerHTML = markup;
}  // ComputersShow()

/**
 * @description Show details on computer registered in SQLAdmin Repository.
 * ???        (NGR) Function created
 * 2014-10-31 (NGR) OS installation date disabled.
 *
 * @param {String} ComputerName
 */
function ComputerDetailsShow(ComputerName) {
    document.title = 'SqlAnchor > Computers > ' + ComputerName;

    var markup = '<h2>' + ComputerName + '</h2>' +
        '<table><thead><td>Property</td><td>Value</td></thead>';

    cmdDbaRepository.CommandText = '[sqlanchor].[computer_detail-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@computer_name', adVarChar, adParamInput, 128, ComputerName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();

    var ComputerIP4 = rstDbaRepository.Fields("ip4_address").Value;
    markup += '<tr><td>IP4 address</td>' + (ComputerIP4 == null ? '<td class="empty">' : '<td>' + ComputerIP4) + '</td></tr>';
    var ComputerMemory = rstDbaRepository.Fields("memory_in_kb").Value;
    markup += '<tr><td>Memory</td>';
    if (ComputerMemory == null) {
        markup += '<td class="empty">';
    }
    else {
        markup += '<td>';
        if (ComputerMemory > (1024 * 1024)) {  // GB
            markup += (ComputerMemory / (1024 * 1024)) + ' GB';
        }
        else if (ComputerMemory > 1024) {  // MB
            markup += (ComputerMemory / 1024) + ' MB';
        }
        else {
            markup += ComputerMemory + ' KB';
        }
    }
    markup += '</td></tr>';
    var ComputerKernelCount = rstDbaRepository.Fields("cpu_kernel_count").Value;
    markup += '<tr><td>CPU kernel count</td>' + (ComputerKernelCount == null ? '<td class="empty">' : '<td>' + ComputerKernelCount) + '</td></tr>';
    /* UNDER CONSTRUCTION: Data collection must be established.
      var ComputerInstallDate = rstDbaRepository.Fields("install_date").Value;
      markup += '<tr><td>Installation date (OS)</td>' + (ComputerInstallDate == null ? '<td class="empty">' : '<td>' + DateToIso8601(new Date(ComputerInstallDate))) + '</td></tr>';
    */
    var LastUpdateTime = rstDbaRepository.Fields("last_update_time").Value;
    var LastUpdateUser = rstDbaRepository.Fields("last_update_user").Value;
    markup += '<tr><td>Last update</td><td>' + DateToIso8601(new Date(LastUpdateTime)) + ' by&nbsp;' + LastUpdateUser + '</td></tr>';
    var ComputerDescription = rstDbaRepository.Fields("description").Value;
    markup += '</table>' + '<p>' + (ComputerDescription ? ComputerDescription : '') + '</p>' +
        buttonComputerManagement(ComputerName) + buttonRemoteDesktop(ComputerName) + buttonAdminRemoteDesktop(ComputerName);

    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);  // Delete Parameter objects as the Command object is reused

    // Show SQL Server services on the computer
    markup += '<h3>SQL Server services</h3>' +
        '<table><thead><td><a title="SQL Server service abbreviation.">Service</a></td>' +
        '<td><a title="SQL Server service instance name. If a service can have multiple instances on a computer, the instance is handled as a default instance.">Instance Name</a></td>' +
        '<td><a title="Version number of the installed SQL Server service.">Service Version</a></td>' +
        '<td><a title="Edition name of the installed SQL Server service.">Service Edition</a></td>' +
        '<td><a title="Prose description of the installed SQL Server service.">Description</a></td></thead>'
    cmdDbaRepository.CommandText = '[sqlanchor].[mssql_by_computer-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@computer_name', adVarChar, adParamInput, 128, ComputerName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ServiceName = rstDbaRepository.Fields('mssql_service_name').Value;
        markup += '<tr><td>' + ServiceName + '</td>';
        var InstanceName = rstDbaRepository.Fields('mssql_name').Value;
        switch (ServiceName) {
            case 'SSDB':
                markup += '<td>' + linkSsdbDetails(ComputerName, InstanceName) + '&nbsp;' + buttonManagementStudio(ComputerName);
                break;
            case 'SSIS':
                markup += '<td>'; //+ buttonSsdbDetails(InstanceName, ComputerName);  //ToDo: Get the SSDB related to the given SSIS 
                break;
            case 'MDS':
                markup += '<td>';
                break;
            case 'DQS':
                markup += '<td>';
                break;
            case 'SSAS':
                markup += '<td>' + InstanceName + '&nbsp;';
                break;
            case 'SSRS':
                markup += '<td>';
                break;
        }
        markup += '</td>';
        var VersionNumber = rstDbaRepository.Fields('mssql_version_number').Value;
        markup += '<td>' + linkMssqlVersionDetails(VersionNumber) + '&nbsp;';
        var VersionLevel = rstDbaRepository.Fields('mssql_version_level').Value;
        markup += '(' + VersionLevel + ')</td>';
        var EditionName = rstDbaRepository.Fields('mssql_edition_name').Value;
        markup += '<td>' + linkMssqlEditionDetails(EditionName) + '</td>';
        var InstanceDescription = rstDbaRepository.Fields('mssql_description').Value;
        markup += '<td>' + InstanceDescription + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);  // Delete Parameter objects as the Command object is reused

    markup += '</table>';

    MainArea.innerHTML = markup;
}  // ComputerDetailsShow()

/**
 * @description
 * @param {String} ComputerName
 */
function buttonComputerDetails(ComputerName) {
    var tag = '<input type="button" value="C&raquo;" ' +
        'onclick="ComputerDetailsShow(\'' + ComputerName + '\');" ' +
        'title="Show details for the computer &bdquo;' + ComputerName + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}

/**
 * @description Create HTML link for the function ComputerDetailsShow().
 * 2014-10-30 (NGR) Functioncreated.
 *
 * @param {String} ComputerName
 */
function linkComputerDetails(ComputerName) {
    var tag = '<a href="#"' +
        "onclick=\"ComputerDetailsShow('" + ComputerName + "');return false;\"" +
        'title="Show details for the computer &bdquo;' + ComputerName + '&ldquo;.">' +
        ComputerName +
        '</a>';
    return tag;
}

/**
 * @description
 * @param {String} WindowsServerName
 * @param {String} WindowsShareName
 */
function buttonWindowsShare(WindowsServerName, WindowsShareName) {
    var tag = '<input type="button" value="' + WindowsShareName + '" ' +
        'onclick="openShare( \'' + WindowsServerName + '\', \'' + WindowsShareName + '\' );" ' +
        'style="font-size:x-small" />';
    return tag;
}

/**
 * @description Create HTML buttom for default share on given local path on a computer.
 * ???        (NGR) Function created
 * 2015-04-24 (NGR) Drive letter always upper-case.
 *
 * @param {any} WindowsServerName
 * @param {any} LocalPath
 */
function buttonDefaultShare(WindowsServerName, LocalPath) {
    if (LocalPath) {
        // Get drive letter from LocalPath
        var DriveLetter = LocalPath.charAt(0).toUpperCase();

        var tag = '<input type="button" value="' + DriveLetter + ':" ' +
            'onclick="openShare( \'' + WindowsServerName + '\', \'' + DriveLetter + '$\' );" ' +
            'title="Open default share &bdquo;' + DriveLetter + '$&ldquo; on the computer &bdquo;' + WindowsServerName + '&ldquo;."' +
            'style="font-size:x-small" />';
    }
    else {  // unknown path (NULL)
        var tag = '';
    }
    return tag;
}

/**
 * @description
 * @param {String} WindowsServerName
 */
function buttonRemoteDesktop(WindowsServerName) {
    var tag = '<input type="button" value="&loz;" ' +
        'onclick="openRemoteDesktop( \'' + WindowsServerName + '\' );" ' +
        'title="Open Windows Remote Desktop for the server &bdquo;' + WindowsServerName + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}

/**
 * @description
 * @param {String} WindowsServerName
 */
function buttonAdminRemoteDesktop(WindowsServerName) {
    return '';  // Osolete by Windows Server design

    var tag = '<input type="button" value="&diams;" ' +
        'onclick="openAdminRemoteDesktop( \'' + WindowsServerName + '\' );" ' +
        'title="Open administrators Windows Remote Desktop for the server &bdquo;' + WindowsServerName + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}

/**
 * @description
 * @param {String} ComputerName
 */
function buttonComputerManagement(ComputerName) {
    var tag = '<input type="button" value="CM" ' +
        'onclick="openComputerManagement( \'' + ComputerName + '\' );" ' +
        'title="Open Computer Management for the server &bdquo;' + ComputerName + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}
