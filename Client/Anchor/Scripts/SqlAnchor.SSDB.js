/*
DESCRIPTION
SQL Server Database Engine (SSDB) in SQLAnchor.

HISTORY
2014-10-24 (Niels Grove-Rasmussen) File created. Initial content pasted from SqlAnchor.hta, SqlAnchor.Core.js and SqlAnchor.DetailPages.js
2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
*/

/**
 * @description List all SQL Server Database Engine instances.
 * ???  (NGR) Function created.
 */
function SsdbShow() {
    document.title = 'SqlAnchor > SSDB';

    var markup = '<h1>SQL Server Database Engine (SSDB)</h1>' +
        '<table><thead><td><a title="SQL Server Database Engine (SSDB) instance name. Full Qualified Domain Name (FQDN) of the computer.">Instance Name</a></td>' +
        '<td><a title="Number of databases in the SQL Server Database Engine (SSDB) instance.">DB Count</a></td>' +
        '<td><a title="Environment abbreviation.">Environment</a></td>' +
        '<td><a title="Prose description of the SQL Server Database Engine (SSDB) instance.">Description</a></td></thead>';

    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb-get]';
    try
    { cnnDbaRepository.Open(); }
    catch (exception) {
        alert("Could not establish connection to SQLAdmin Repository.\nPlease check the server '" + OleDbDataSource + "'.\n\nADODB.Connection.Open() caught:\n" + exception.message);
        throw (exception);
    }
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields('computer_name').Value;
        var SsdbName = rstDbaRepository.Fields('ssdb_name').Value;
        var DbCount = rstDbaRepository.Fields('database_count').Value;
        var EnvAbb = rstDbaRepository.Fields('environment_abbreviation').Value;
        var SsdbDescription = rstDbaRepository.Fields('ssdb_description').Value;
        rstDbaRepository.moveNext();

        markup += '<tr><td>' + linkComputerDetails(ComputerName) + '&nbsp;\\&nbsp;' + linkSsdbDetails(ComputerName, SsdbName) + '&nbsp;' + buttonRemoteDesktop(ComputerName) + '</td>' +
            (DbCount == 0 ? '<td class="empty">' : '<td>' + DbCount) + '</td>' +
            '<td>' + linkEnvironmentDetails(EnvAbb) + '</td>' +
            '<td>' + (SsdbDescription == null ? '' : SsdbDescription) + buttonSsdbDescription(ComputerName, SsdbName) + '</td>';
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();

    markup += '</table>';
    MainArea.innerHTML = markup;
}  // SsdbInstancesShow()

/**
 * @description Show details on SQL Server Database Engine instance.
 * ???        (NGR) Function created.
 * 2014-12-30 (NGR) Service Call 91514: Error in list of databases fixed. Correct presentation of MAXDOP. More precise presentation of NULL values in SSDB details table.
 *                  Prettier presentation of default instance in heading and title.
 *
 * @param {String} SqlName
 * @param {String} ComputerName
 */
function SsdbDetailsShow(SqlName, ComputerName) {
    document.title = 'SqlAnchor > DB instance > ' + ComputerName + (SqlName == '.' ? '' : '\\' + SqlName);

    var markup = '<h1>Database Engine instance &bdquo;' + ComputerName + (SqlName == '.' ? '' : '\\' + SqlName) + '&ldquo;</h1>' +
        '<p>Computer: &bdquo;' + linkComputerDetails(ComputerName) + '&ldquo; ' + buttonComputerManagement(ComputerName) + buttonRemoteDesktop(ComputerName) + '</p>';

    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_detail-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@computer_name', adVarChar, adParamInput, 128, ComputerName));
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@ssdb_name', adVarChar, adParamInput, 128, SqlName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    var SqlTcp = rstDbaRepository.Fields('tcp_port').Value;
    var SqlIsTcpDynamic = rstDbaRepository.Fields('is_tcp_dynamic').Value;
    var SqlEditionName = rstDbaRepository.Fields('edition_name').Value;
    var VersionNumber = rstDbaRepository.Fields('version_number').Value;
    var VersionMajor = VersionNumber.split('.')[0];
    var VersionLevel = rstDbaRepository.Fields('version_level').Value;
    var EnvAbb = rstDbaRepository.Fields('environment_abbreviation').Value;
    var EnvName = rstDbaRepository.Fields('environment_name').Value;
    var Collation = rstDbaRepository.Fields('collation_name').Value;
    var SqlAuditLevel = rstDbaRepository.Fields('audit_level').Value;
    var SqlMaxMem = rstDbaRepository.Fields('maxmem_in_mb').Value;
    var SqlMinMem = rstDbaRepository.Fields('minmem_in_mb').Value;
    var SqlMaxDOP = rstDbaRepository.Fields('maxdop').Value;
    var SqlBackupPath = rstDbaRepository.Fields('backup_path').Value;
    var SqlIsBackupCompressed = rstDbaRepository.Fields('is_backup_compressed').Value;
    var SqlErrorlogCount = rstDbaRepository.Fields('errorlog_count').Value;
    var SqlErrorlogPath = rstDbaRepository.Fields('errorlog_path').Value;
    var SqlDataPath = rstDbaRepository.Fields('data_path').Value;
    var SqlLogPath = rstDbaRepository.Fields('log_path').Value;
    var SqlServiceAccount = rstDbaRepository.Fields('serviceaccount').Value;
    var SqlIsFulltextInstalled = rstDbaRepository.Fields('is_fulltext_installed').Value;
    var SqlLoginMode = rstDbaRepository.Fields('loginmode').Value;
    var SqlIsSingleUser = rstDbaRepository.Fields('is_single_user').Value;
    var SqlIsOleAutomationEnabled = rstDbaRepository.Fields('is_oleautomation_enabled').Value;
    var ClrVersion = rstDbaRepository.Fields('clr_version').Value;
    var SqlIsClrEnabled = rstDbaRepository.Fields('is_clr_enabled').Value;
    var SqlIsPagesLockedInMemory = rstDbaRepository.Fields('is_pages_locked_in_memory').Value;
    var SqlDescription = rstDbaRepository.Fields('description').Value;
    var SqlLastUpdateTime = rstDbaRepository.Fields('last_update_time').Value;
    var SqlLastUpdateUser = rstDbaRepository.Fields('last_update_user').Value;
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    // Delete Parameter objects as the Command object is reused
    cmdDbaRepository.Parameters.Delete(1);
    cmdDbaRepository.Parameters.Delete(0);

    markup += '<table><thead><td><a title="Descriptive name of the SQL Server Database Engine (SSDB) property.">Property</a></td>' +
        '<td><a title="Value of the SQL Server Database Engine (SSDB) property. The value can be multipart and with multiple different presentations.">Value</a></td></thead>' +
        '<tr><td>TCP port</td>' + (SqlTcp ? '<td>' + SqlTcp : '<td class="empty">(unknown)') +
        (SqlIsTcpDynamic ? '&nbsp;(' + (SqlIsTcpDynamic ? 'Dynamic' : 'Static') + ')' : '') + '</td></tr>' +
        '<tr><td>Edition</td><td>' + linkMssqlEditionDetails(SqlEditionName) + '</td></tr>' +
        '<tr><td>SQL Server version</td>' +
        '<td>' + linkMssqlVersionDetails(VersionNumber) + (VersionNumber == '(unknown)' ? '' : ' (' + VersionLevel + ')') + '</td></tr>' +
        '<tr><td>Environment</td><td>' + EnvName + '&nbsp;(' + linkEnvironmentDetails(EnvAbb) + ')</td></tr>' +
        '<tr><td>Collation</td>' + (Collation == null ? '<td class="empty">&nbsp;' : '<td>' + Collation) + '</td></tr>' +
        '<tr><td>Audit Level</td>' + (SqlAuditLevel ? '<td>' + SqlAuditLevel : '<td class="empty">&nbsp;') + '</td></tr>' +
        '<tr><td>Memory</td>' +
        ((!SqlMaxMem && !SqlMinMem) ? '<td class="empty">&nbsp</td></tr>' : '<td>Min = ' + SqlMinMem + ' MB; Max = ' + SqlMaxMem + ' MB</td></tr>') +
        '<tr><td>Max DOP</td>' + (SqlMaxDOP == null ? '<td class="empty">&nbsp;' : '<td>' + SqlMaxDOP) + '</td></tr>' +
        '<tr><td>Backup</td>' + (SqlBackupPath == null ? '<td class="empty">&nbsp;' : '<td>' + buttonDefaultShare(ComputerName, SqlBackupPath) + '&nbsp;' + SqlBackupPath + ' (' + (SqlIsBackupCompressed ? '' : 'not ') + 'compressed)') + '</td></tr>' +
        '<tr><td>SQL Error Log</td>' + (SqlErrorlogPath ? '<td>' + buttonDefaultShare(ComputerName, SqlErrorlogPath) + '&nbsp;' + SqlErrorlogPath : '<td class="empty">') + (SqlErrorlogCount ? ' (' + SqlErrorlogCount + ' generations)' : '') + '</td></tr>' +
        '<tr><td>Data</td>' + (SqlDataPath ? '<td>' + buttonDefaultShare(ComputerName, SqlDataPath) + '&nbsp;' + SqlDataPath : '<td class="empty">&nbsp;') + '</td></tr>' +
        '<tr><td>Log (ldf)</td>' + (SqlLogPath ? '<td>' + buttonDefaultShare(ComputerName, SqlLogPath) + '&nbsp;' + SqlLogPath : '<td class="empty">&nbsp;') + '</td></tr>' +
        '<tr><td>Service account</td>' + (SqlServiceAccount ? '<td>' + SqlServiceAccount : '<td class="empty">&nbsp;') + '</td></tr>' +
        '<tr><td>FullText</td>' + (SqlIsFulltextInstalled == null ? '<td class="empty">&nbsp;' : '<td>' + (SqlIsFulltextInstalled ? '' : 'not ') + 'installed') + '</td></tr>' +
        '<tr><td>Single User Mode</td>' + (SqlIsSingleUser == null ? '<td class="empty">&nbsp;' : '<td>' + (SqlIsSingleUser ? 'YES' : 'no')) + '</td></tr>' +
        '<tr><td>OLE Automation</td>' + (SqlIsOleAutomationEnabled == null ? '<td class="empty">&nbsp;' : '<td>' + (SqlIsOleAutomationEnabled ? '' : 'not ') + 'enabled') + '</td></tr>' +
        ((VersionMajor > 8) ? '<tr><td>CLR</td>' + (ClrVersion == null ? '<td class="empty">&nbsp;' : '<td>' + ClrVersion + (ClrVersion == '(unknown)' ? '' : ' (' + (SqlIsClrEnabled ? '' : 'not ') + 'enabled)')) + '</td></tr>' : '<tr><td>Pages locked in memory</td><td>' + (SqlIsPagesLockedInMemory ? 'yes' : 'no') + '</td></tr>') +
        '<tr><td>Last update</td><td>' + DateToIso8601(new Date(SqlLastUpdateTime)) + ' by ' + SqlLastUpdateUser + '</td></tr>' +
        '</table>' +
        '<p>' + (SqlDescription == null ? '' : SqlDescription) + '&nbsp;' + buttonSqlCmd(ComputerName, SqlName) + '</p>' +
        '<h2>Databases</h2>';

    cmdDbaRepository.CommandText = '[sqlanchor].[database_by_ssdb-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@computer_name', adVarChar, adParamInput, 128, ComputerName));
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@ssdb_name', adVarChar, adParamInput, 128, SqlName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    if (rstDbaRepository.EOF)
    { markup += '<p>No databases are registered active on this database instance in the SqlAdmin repository.</p>'; }
    else {
        markup += '<table><thead><td><a title="Database name.">Name</a></td>' +
            '<td><a title="Database Compability Level.">CompLevel</a></td>' +
            '<td><a title="Database Recovery Model.">Recovery Model</a></td>' +
            '<td><a title="Date and time for last full backup of the database.">Backup Full</a></td>' +
            '<td><a title="Date and time for last differential database backup.">Backup Diff</a></td>' +
            '<td><a title="Date and time of last backup of the database transaction log.">Backup Log</a></td>' +
            '<td><a title="Database status.">Status</a></td>' +
            '<td><a title="Prose description of the database.">Description</a></td></thead>';
        while (!rstDbaRepository.EOF) {
            var DbName = rstDbaRepository.Fields('database_name').Value;
            var DbCompabilityLevel = rstDbaRepository.Fields('database_compabilitylevel').Value;
            var DbRecoveryModel = rstDbaRepository.Fields('database_recovery_model').Value;
            var DbBackupFullLast = rstDbaRepository.Fields('database_backup_full_last').Value;
            var DbBackupDiffLast = rstDbaRepository.Fields('database_backup_diff_last').Value;
            var DbBackupLogLast = rstDbaRepository.Fields('database_backup_log_last').Value;
            var DbStatus = rstDbaRepository.Fields('database_status').Value;
            var DbDescription = rstDbaRepository.Fields('database_description').Value;
            rstDbaRepository.moveNext();

            markup += '<tr><td>' + linkSsdbDatabaseDetails(ComputerName, SqlName, DbName) + '</td>' +
                '<td>' + linkMssqlCompabilityLevel(DbCompabilityLevel) + '</td>' +
                (DbName == 'tempdb' ? '<td class="empty">&nbsp;' : '<td>' + DbRecoveryModel) + '</td>' +
                (DbBackupFullLast == null ? '<td class="empty">&nbsp;' : '<td>' + DateToIso8601(new Date(DbBackupFullLast))) + '</td>' +
                (DbBackupDiffLast == null ? '<td class="empty">&nbsp;' : '<td>' + DateToIso8601(new Date(DbBackupDiffLast))) + '</td>' +
                (DbBackupLogLast == null ? '<td class="empty">&nbsp;' : '<td>' + DateToIso8601(new Date(DbBackupLogLast))) + '</td>' +
                '<td>' + DbStatus + '</td>' +
                '<td>' + (DbDescription == null ? '' : DbDescription) + '</td></tr>';
        }
        markup += '</table>';
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    // Delete Parameter objects as the Command object is reused
    cmdDbaRepository.Parameters.Delete(1);
    cmdDbaRepository.Parameters.Delete(0);

    MainArea.innerHTML = markup;
}  //SsdbDetailsShow()

/**
 * @description UNDER CONSTRUCTION
 * @param {String} ComputerName
 * @param {String} SqlName
 */
function changeSsdbDescription(ComputerName, SqlName) {
    //window.open('', 'Change instance description');
    alert('changeSsdbDescription(' + ComputerName + ', ' + SqlName + ')');
    var Popup = window.createPopup();
    var PopupBody = Popup.document.body;
    PopupBody.innerHTML = '<h1>Change DB instance description</h1>';
    Popup.show(150, 150, 200, 50, document.body);
}

/**
 * @description UNDER CONSTRUCTION
 * @param {String} ComputerName
 * @param {String} SqlName
 */
function changeSsdbDescription_1(ComputerName, SqlName) {
    document.title = 'SqlAnchor > DB Instance ' + ComputerName + '\\' + SqlName;

    var markup = '<h2>' + ComputerName + '\\' + SqlName + '</h2>';

    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_detail-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@computer_name', adVarChar, adParamInput, 128, ComputerName));
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@ssdb_name', adVarChar, adParamInput, 128, SqlName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();

    var SqlTcp = rstDbaRepository.Fields("tcp_port").Value;
    var SqlIsTcpDynamic = rstDbaRepository.Fields("is_tcp_dynamic").Value;
    var SqlEditionName = rstDbaRepository.Fields("edition_name").Value;
    var VersionNumber = rstDbaRepository.Fields("version_number").Value;
    var VersionMajor = VersionNumber.split('.')[0];
    var VersionLevel = rstDbaRepository.Fields("version_level").Value;
    var EnvAbb = rstDbaRepository.Fields("environment_abbreviation").Value;
    var EnvName = rstDbaRepository.Fields("environment_name").Value;
    var Collation = rstDbaRepository.Fields("collation_name").Value;
    var SqlAuditLevel = rstDbaRepository.Fields("audit_level").Value;
    var SqlMaxMem = rstDbaRepository.Fields("maxmem_in_mb").Value;
    var SqlMinMem = rstDbaRepository.Fields("minmem_in_mb").Value;
    var SqlMaxDOP = rstDbaRepository.Fields("maxdop").Value;
    var SqlBackupPath = rstDbaRepository.Fields("backup_path").Value;
    var SqlIsBackupCompressed = rstDbaRepository.Fields("is_backup_compressed").Value;
    var SqlErrorlogCount = rstDbaRepository.Fields("errorlog_count").Value;
    var SqlErrorlogPath = rstDbaRepository.Fields("errorlog_path").Value;
    var SqlDataPath = rstDbaRepository.Fields("data_path").Value;
    var SqlLogPath = rstDbaRepository.Fields("log_path").Value;
    var SqlServiceAccount = rstDbaRepository.Fields("serviceaccount").Value;
    var SqlIsFulltextInstalled = rstDbaRepository.Fields("is_fulltext_installed").Value;
    var SqlLoginMode = rstDbaRepository.Fields("loginmode").Value;
    var SqlIsSingleUser = rstDbaRepository.Fields("is_single_user").Value;
    var SqlIsOleAutomationEnabled = rstDbaRepository.Fields("is_oleautomation_enabled").Value;
    if (VersionMajor > 8) {
        var ClrVersion = rstDbaRepository.Fields("clr_version").Value;
        var SqlIsClrEnabled = rstDbaRepository.Fields("is_clr_enabled").Value;
    }
    var SqlIsPagesLockedInMemory = rstDbaRepository.Fields("is_pages_locked_in_memory").Value;
    var SqlDescription = rstDbaRepository.Fields("description").Value;
    var SqlLastUpdateTime = rstDbaRepository.Fields("last_update_time").Value;
    var SqlLastUpdateUser = rstDbaRepository.Fields("last_update_user").Value;

    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    // Delete Parameter objects as the Command object is reused
    cmdDbaRepository.Parameters.Delete(1);
    cmdDbaRepository.Parameters.Delete(0);

    markup += '<p>Change Description:</p>' +
        '<form method="post">' +
        'Current description: ' + SqlDescription + '<br />' +
        'New Description: ' + '<input type="text" name="newdesc" />' +
        '</form>' +
        '<h3>Computer &bdquo;' + ComputerName + '&ldquo;</h3>' + buttonComputerDetails(ComputerName) + buttonComputerManagement(ComputerName) + buttonRemoteDesktop(ComputerName) +
        '<h3>Database instance &bdquo;' + ComputerName + '\\' + SqlName + '&ldquo;</h3>' + buttonSqlCmd(ComputerName, SqlName) + buttonManagementStudio(SqlName, ComputerName) +
        '<table><thead><td>Property</td><td>Value</td></thead>' +
        '<tr><td>TCP port</td><td>' + (SqlTcp == null ? '(unknown)' : SqlTcp) + (SqlIsTcpDynamic == null ? '' : '&nbsp;(' + (SqlIsTcpDynamic ? 'Dynamic' : 'Static') + ')') + '</td></tr>' +
        '<tr><td>Edition</td><td>' + SqlEditionName + "&nbsp;" + buttonSsdbEditionDetails(SqlEditionName) + '</td></tr>' +
        '<tr><td>SQL Server version</td><td>' + VersionNumber + (VersionNumber == '(unknown)' ? '' : ' (' + VersionLevel + ')&nbsp;') + buttonSsdbVersionDetails(VersionNumber) + '</td></tr>' +
        '<tr><td>Environment</td><td>' + EnvName + '&nbsp;(' + EnvAbb + ')&nbsp;' + buttonEnvironmentDetails(EnvAbb) + '</td></tr>' +
        '<tr><td>Collation</td><td>' + Collation + '</td></tr>' +
        '<tr><td>Audit Level</td><td>' + SqlAuditLevel + '</td></tr>' +
        '<tr><td>Memory</td><td>Min = ' + SqlMinMem + ' MB; Max = ' + SqlMaxMem + ' MB</td></tr>' +
        '<tr><td>Max DOP</td><td>' + SqlMaxDOP + '</td></tr>' +
        '<tr><td>Backup</td><td>' + SqlBackupPath + ' (' + (SqlIsBackupCompressed ? '' : 'not ') + 'compressed)</td></tr>' +
        '<tr><td>SQL Error Log</td><td>' + SqlErrorlogPath + ' (' + SqlErrorlogCount + ' generations)</td></tr>' +
        '<tr><td>Data</td><td>' + SqlDataPath + '</td></tr>' +
        '<tr><td>Log (ldf)</td><td>' + SqlLogPath + '</td></tr>' +
        '<tr><td>Service account</td><td>' + SqlServiceAccount + '</td></tr>' +
        '<tr><td>FullText</td><td>' + (SqlIsFulltextInstalled ? '' : 'not ') + 'installed</td></tr>' +
        '<tr><td>Single User Mode</td><td>' + (SqlIsSingleUser ? 'YES' : 'no') + '</td></tr>' +
        '<tr><td>OLE Automation</td><td>' + (SqlIsOleAutomationEnabled ? '' : 'not ') + 'enabled</td></tr>';
    if (VersionMajor > 8) {
        markup += '<tr><td>CLR</td><td>' + ClrVersion + ' (' + (SqlIsClrEnabled ? '' : 'not ') + 'enabled)</td></tr>';
    }
    markup += '<tr><td>Pages locked in memory</td><td>' + (SqlIsPagesLockedInMemory ? 'yes' : 'no') + '</td></tr>' +
        '<tr><td>Last update</td><td>' + DateToIso8601(new Date(SqlLastUpdateTime)) + ' by ' + SqlLastUpdateUser + '</td></tr>';

    MainArea.innerHTML = markup;
}  // changeSsdbDescription()

/**
 * @description
 * @param {String} SsdbName
 * @param {String} WindowsServerName
 */
function buttonSsdbDetails(SsdbName, WindowsServerName) {
    var tag = '<input type="button" value="SSDB&raquo;" ' +
        'onclick="SsdbDetailsShow(\'' + SsdbName + '\',\'' + WindowsServerName + '\');" ' +
        'title="Show details for the SQL Server Database Engine instance &bdquo;' + WindowsServerName + (SsdbName == '.' ? '' : '\\' + SsdbName) + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}

/**
 * @description Create HTML link for the function SsdbDetailsShow().
 * 2014-10-30 (NGR) Function created.
 *
 * @param {String} ComputerName
 * @param {String} SsdbName
 */
function linkSsdbDetails(ComputerName, SsdbName) {
    var tag = '<a href="#"' +
        "onclick=\"SsdbDetailsShow('" + SsdbName + "','" + ComputerName + "');return false;\"" +
        'title="Show details for the SQL&nbsp;Server Database&nbsp;Engine instance&nbsp;&bdquo;' + (SsdbName == '.' ? '(default)' : SsdbName) + '&ldquo; on the computer&nbsp;&bdquo;' + ComputerName + '&ldquo;.">' +
        (SsdbName == '.' ? '(default)' : SsdbName) +
        '</a>';
    return tag;
}

/**
 * @description
 * @param {String} ComputerName
 * @param {String} SqlName
 */
function buttonSsdbDescription(ComputerName, SqlName) {
    return '';  // Under Construction!

    var tag = '<input type="button" value="C" ' +
        'onclick="changeSsdbDescription(\'' + ComputerName + '\',\'' + SqlName + '\');" ' +
        'title="Change description for the database instance &bdquo;' + (ComputerName + '\\' + SqlName) + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}


/*
SSDB Database
*/
/**
 * @description Show conplete list of active databases in SQLAdmin Repository.
 * ???        (NGR) Function created
 * 2015-04-24 (NGR) Titles added to tables.
 */
function SsdbDatabasesShow() {
    document.title = 'DBAnchor > SSDB Databases';

    var markup = '<h1>SQL Server Database Engine (SSDB) database</h1>' +
        '<table><thead><td><a title="Database Compability level.">Compability Level</a></td>' +
        '<td><a title="Number of databases.">DB Count</a></td></thead>';
    var DbCountTotal = 0;
    cmdDbaRepository.CommandText = '[sqlanchor].[database_summary-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var DbCompabilityLevel = rstDbaRepository.Fields('database_compabilitylevel').Value;
        var DbCount = rstDbaRepository.Fields('database_count').Value;
        rstDbaRepository.moveNext();

        markup += '<tr><td>' + linkMssqlCompabilityLevel(DbCompabilityLevel) + '</td>' +
            '<td>' + DbCount + '</td></tr>';
        DbCountTotal += DbCount;
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();

    markup += '<tr style="font-style:italic;"><td>Total</td><td>' + DbCountTotal + '</td></tr></table>' +
        '<h2>List</h2>' +
        '<table><thead><td><a title="The real name of the physical database.">Database name</a></td>' +
        '<td><a title="Full SQL Server Database Engine (SSDB) instance name.">Instance name</a></td>' +
        '<td><a title="Environment abbreviation.">Environment</a></td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[database-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var DatabaseName = rstDbaRepository.Fields('database_name').Value;
        var ComputerName = rstDbaRepository.Fields('computer_name').Value;
        var SsdbName = rstDbaRepository.Fields('ssdb_name').Value;
        var EnvironmentAbbreviation = rstDbaRepository.Fields('environment_abbreviation').Value;
        rstDbaRepository.moveNext();

        markup += '<tr><td>' + linkSsdbDatabaseDetails(ComputerName, SsdbName, DatabaseName) + '</td>' +
            '<td>' + linkComputerDetails(ComputerName) + '&nbsp;\\&nbsp;' + linkSsdbDetails(ComputerName, SsdbName) + '</td>' +
            '<td>' + linkEnvironmentDetails(EnvironmentAbbreviation) + '</td></tr>';
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    markup += '</table>';

    MainArea.innerHTML = markup;
}  // SsdbDatabasesShow()

/**
 * @description Show details on given database.
 * ??? (NGR) Function created.
 *
 * @param {any} ComputerName
 * @param {any} SsdbName
 * @param {any} DatabaseName
 */
function SsdbDatabaseDetailsShow(ComputerName, SsdbName, DatabaseName) {
    document.title = 'SqlAnchor > SSDB > Databases > ' + DatabaseName + ' (' + ComputerName + (SsdbName == '.' ? '' : '\\' + SsdbName) + ')';

    var markup = '<h2>Database &bdquo;' + DatabaseName + '&ldquo;</h2>' +
        '<p>Computer: &bdquo;' + linkComputerDetails(ComputerName) + '&ldquo;</p>' +
        '<p>Database Engine instance: &bdquo;' + linkSsdbDetails(ComputerName, SsdbName) + '&ldquo;</p>' +
        '<table><thead><td>Property</td><td>Value</td></thead>';

    cmdDbaRepository.CommandText = '[sqlanchor].[database_detail-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@computer_name', adVarChar, adParamInput, 128, ComputerName));
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@ssdb_name', adVarChar, adParamInput, 128, SsdbName));
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@db_name', adVarChar, adParamInput, 128, DatabaseName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();

    var CollationName = rstDbaRepository.Fields('collation_name').Value;
    var CompabilityLevel = rstDbaRepository.Fields('database_compabilitylevel').Value;
    var RecoveryModel = rstDbaRepository.Fields('database_recovery_model').Value;
    var Owner = rstDbaRepository.Fields('database_owner').Value;
    var BackupFullLast = rstDbaRepository.Fields('database_backup_full_last').Value;
    var BackupDiffLast = rstDbaRepository.Fields('database_backup_diff_last').Value;
    var BackupLogLast = rstDbaRepository.Fields('database_backup_log_last').Value;
    var DataSpace = rstDbaRepository.Fields('database_dataspace_in_kb').Value;
    var IndexSpace = rstDbaRepository.Fields('database_indexspace_in_kb').Value;
    var Size = rstDbaRepository.Fields('database_size_in_kb').Value;
    var FreeSpace = rstDbaRepository.Fields('database_freespace_in_kb').Value;
    var VlfCount = rstDbaRepository.Fields('database_vlf_count').Value;
    var CreateTime = rstDbaRepository.Fields('database_create_time').Value;
    var CreatePerson = rstDbaRepository.Fields('database_create_person').Value;
    var PageVerify = rstDbaRepository.Fields('database_pageverify').Value;
    var Status = rstDbaRepository.Fields('database_status').Value;
    var isEncrypted = rstDbaRepository.Fields('database_is_encrypted').Value;
    var isReadOnly = rstDbaRepository.Fields('database_is_readonly').Value;
    var isHomeMade = rstDbaRepository.Fields('database_is_homemade').Value;
    var isAutoClose = rstDbaRepository.Fields('database_is_autoclose').Value;
    var isAutoShrink = rstDbaRepository.Fields('database_is_autoshrink').Value;
    var isBrokerEnabled = rstDbaRepository.Fields('database_is_brokerenabled').Value;
    var UpdateTime = rstDbaRepository.Fields('database_update_time').Value;
    var UpdateUser = rstDbaRepository.Fields('database_update_user').Value;
    var Description = rstDbaRepository.Fields('database_description').Value;

    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    // Delete Parameter objects as the Command object is reused
    cmdDbaRepository.Parameters.Delete(2);
    cmdDbaRepository.Parameters.Delete(1);
    cmdDbaRepository.Parameters.Delete(0);

    markup += '<tr><td>Collation</td><td>' + CollationName + '</td></tr>' +
        '<tr><td>Compability Level</td><td>' + CompabilityLevel + '</td></tr>' +
        '<tr><td>Recovery Model</td><td>' + RecoveryModel + '</td></tr>' +
        '<tr><td>Owner</td><td>' + Owner + '</td></tr>' +
        '<tr><td>Backup Full</td>' + (BackupFullLast == null ? '<td class="empty">&nbsp;' : '<td>' + DateToIso8601(new Date(BackupFullLast))) + '</td></tr>' +
        '<tr><td>Backup Diff</td>' + (BackupDiffLast == null ? '<td class="empty">&nbsp;' : '<td>' + DateToIso8601(new Date(BackupDiffLast))) + '</td></tr>' +
        '<tr><td>Backup Log</td>' + (BackupLogLast == null ? '<td class="empty">&nbsp;' : '<td>' + DateToIso8601(new Date(BackupLogLast))) + '</td></tr>' +
        '<tr><td>Dataspace</td><td>' + DataSpace + ' KB</td></tr>' +
        '<tr><td>Indexspace</td><td>' + IndexSpace + ' KB</td></tr>' +
        '<tr><td>Size</td><td>' + Size + ' KB</td></tr>' +
        '<tr><td>Free space</td><td>' + FreeSpace + ' KB</td></tr>' +
        '<tr><td>Translog VLF count</td><td>' + VlfCount + '</td></tr>' +
        '<tr><td>Created</td><td>' + DateToIso8601(new Date(CreateTime)) + (CreatePerson == null ? '' : ' by ' + CreatePerson) + '</td></tr>' +
        '<tr><td>Page Verify</td>';
    switch (PageVerify) {
        case 'None':
            markup += '<td class="alert">';
            break;
        case 'TornPageDetection':
            if (CompabilityLevel <= 80)
            { markup += '<td>'; }
            else
            { markup += '<td class="warning">'; }
            break;
        case 'Checksum':
            markup += '<td>';
    }
    markup += PageVerify + '</td></tr>' +
        '<tr><td>Status</td><td>' + Status + '</td></tr>' +
        '<tr><td>Encrypted</td><td>' + isEncrypted + '</td></tr>' +
        '<tr><td>Read Only</td><td>' + isReadOnly + '</td></tr>' +
        '<tr><td>Home Made</td><td>' + isHomeMade + '</td></tr>' +
        '<tr><td>Autoclose</td><td>' + isAutoClose + '</td></tr>' +
        '<tr><td>Autoshrink</td><td>' + isAutoShrink + '</td></tr>' +
        '<tr><td>Broker Enabled</td><td>' + isBrokerEnabled + '</td></tr>' +
        '<tr><td>Updated</td><td>' + DateToIso8601(new Date(UpdateTime)) + ' by ' + UpdateUser + '</td></tr>' +
        '</table>' + (Description ? '<p>' + Description + '</p>' : '');

    MainArea.innerHTML = markup;
}  //SsdbDatabaseDetailsShow()

/**
 * @description Create HTML buttom for the function SsdbDetailsShow().
 * 2015-04-24 (NGR) Function obsolete.
 *
 * @param {any} ComputerName
 * @param {any} SsdbName
 * @param {any} SsdbDatabaseName
 */
function buttonSsdbDatabaseDetails(ComputerName, SsdbName, SsdbDatabaseName) {
    return '<p>Function buttonSsdbDatabaseDetails() is obsolete.</p>'

    /*var tag = '<input type="button" value="&raquo;" ' +
          'onclick="SsdbDatabaseDetailsShow(\'' + ComputerName + '\',\'' + SsdbName + '\',\'' + SsdbDatabaseName + '\');" ' +
          'title="Show details for the SQL Server Database Engine (SSDB) database &bdquo;' + SsdbDatabaseName + '&ldquo; on &bdquo;' + (ComputerName + '\\' + SsdbName) + '&ldquo;." ' +
          'style="font-size:x-small" />';
    return tag;*/
}

/**
 * @description Create HTML link for the function SsdbDatabaseDetailsShow().
 * 2014-10-30 (NGR) Function created.
 *
 * @param {any} ComputerName
 * @param {any} SsdbName
 * @param {any} SsdbDatabaseName
 */
function linkSsdbDatabaseDetails(ComputerName, SsdbName, SsdbDatabaseName) {
    var tag = '<a href="#"' +
        "onclick=\"SsdbDatabaseDetailsShow('" + ComputerName + "','" + SsdbName + "','" + SsdbDatabaseName + "');return false;\"" +
        'title="Show details for the SQL&nbsp;Server Database&nbsp;Engine database&nbsp;&bdquo;' + SsdbDatabaseName + '&ldquo; on the SSDB&nbsp;instance&nbsp;&bdquo;' + (ComputerName + '\\' + SsdbName) + '&ldquo;.">' +
        SsdbDatabaseName +
        '</a>';
    return tag;
}
