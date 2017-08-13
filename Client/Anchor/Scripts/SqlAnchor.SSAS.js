/*
DESCRIPTION
SQL Server Analysis Services (SSAS) in SQLAnchor.

HISTORY
2014-11-11 (Niels Grove-Rasmussen) File created.
2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
*/

/**
 * @description List SQL Server Analysis Services (SSAS) installations.
 * <p>2014-11-11 (NGR) Function definition moved from "SqlAnchor.hta" to "SqlAnchor.SSAS.js".</p>
 * <p>???        (NGR) Function created.</p>
 */
function SsasShow() {
    document.title = 'SqlAnchor > SSAS';

    var markup = '<h1>SQL Server Analysis Services (SSAS)</h1>' +
        '<table><thead><td><a title="Full instance name of SQL Server Analysis Service (SSAS) Instance.">Instance name</a></td>' +
        '<td><a title="Environment abbreviation.">Environment</a></td>' +
        '<td><a title="Prose description of SQL Server Analysis Services (SSAS) instance.">Description</a></td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[ssas-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields('computer_name').Value;
        var SsasName = rstDbaRepository.Fields('ssas_name').Value;
        var EnvironmentAbbreviation = rstDbaRepository.Fields('environment_abbreviation').Value;
        var SsisDescription = rstDbaRepository.Fields('ssas_description').Value;
        rstDbaRepository.moveNext();

        markup += '<tr><td>' + linkComputerDetails(ComputerName) + '&nbsp;\\&nbsp;' + linkSsasDetails(ComputerName, SsasName) + '&nbsp;' + buttonRemoteDesktop(ComputerName) + buttonAdminRemoteDesktop(ComputerName) + '</td>' +
            '<td>' + linkEnvironmentDetails(EnvironmentAbbreviation) + '</td>' +
            '<td>' + SsisDescription + '</td></tr>';
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();

    markup += '</table>';
    MainArea.innerHTML = markup;
}  // SsasShow()

/**
 * @description Show details on SQL Server Analysis Services (SSAS) instance.
 * <p>2014-11-13 (NGR) Function created.</p>
 *
 * @param {String} ComputerName
 * @param {String} SsasName
 */
function SsasDetailsShow(ComputerName, SsasName) {
    document.title = 'SqlAnchor > SSAS instance > ' + ComputerName + '\\' + SsasName

    cmdDbaRepository.CommandText = '[sqlanchor].[ssas_detail-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@computer_name', adVarChar, adParamInput, 128, ComputerName));
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@ssas_name', adVarChar, adParamInput, 128, SsasName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();

    var EditionName = rstDbaRepository.Fields('edition_name').Value;
    var VersionNumber = rstDbaRepository.Fields('version_number').Value;
    var VersionLevel = rstDbaRepository.Fields('version_level').Value;
    var EnvAbb = rstDbaRepository.Fields('environment_abbreviation').Value;
    var EnvName = rstDbaRepository.Fields('environment_name').Value;
    var CollationName = rstDbaRepository.Fields('collation_name').Value;
    var TcpPort = rstDbaRepository.Fields('ssas_tcp_port').Value;
    var BackupPath = rstDbaRepository.Fields('ssas_backup_path').Value;
    var isBackupCompressed = rstDbaRepository.Fields('ssas_is_backup_compressed').Value;
    var DataPath = rstDbaRepository.Fields('ssas_data_path').Value;
    var LogPath = rstDbaRepository.Fields('ssas_log_path').Value;
    var ServiceAccount = rstDbaRepository.Fields('ssas_serviceaccount').Value;
    var LastUpdateUser = rstDbaRepository.Fields('ssas_last_update_user').Value;
    var LastUpdateTime = rstDbaRepository.Fields('ssas_last_update_time').Value;
    var Description = rstDbaRepository.Fields('ssas_description').Value;

    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    // Delete Parameter objects as the Command object is reused
    cmdDbaRepository.Parameters.Delete(1);
    cmdDbaRepository.Parameters.Delete(0);

    MainArea.innerHTML = '<h1>Analysis Services instance &bdquo;' + ComputerName + '\\' + SsasName + '&ldquo;</h1>' +
        '<p>Computer: &bdquo;' + linkComputerDetails(ComputerName) + '&ldquo; ' + buttonComputerManagement(ComputerName) + buttonRemoteDesktop(ComputerName) + '</p>' +
        '<p>' + Description + '</p>' +
        '<table><thead><td><a title="SQL Server Analysis Services (SSAS) instance property name.">Property</a></td>' +
        '<td><a title="SQL Server Analysis Services (SSAS) instance property value.">Value</a></td></thead>' +
        '<tr><td>Edition</td><td>' + linkMssqlEditionDetails(EditionName) + '</td></tr>' +
        '<tr><td>Version</td><td>' + linkMssqlVersionDetails(VersionNumber) + (VersionNumber == '(unknown)' ? '' : '&nbsp;(' + VersionLevel + ')') + '</td></tr>' +
        '<tr><td>Environment</td><td>' + EnvName + '&nbsp;(' + linkEnvironmentDetails(EnvAbb) + ')</td></tr>' +
        '<tr><td>Collation</td><td>' + linkCollationDetails(CollationName) + '</td></tr>' +
        '<tr><td>TCP port</td>' + (TcpPort == null ? '<td class="empty">' : '<td>' + TcpPort) + '</td></tr>' +
        '<tr><td>Backup path</td>' + (BackupPath == null ? '<td class="empty">' : '<td>' + buttonDefaultShare(ComputerName, BackupPath) + '&nbsp;' + BackupPath + '&nbsp;(' + (isBackupCompressed ? '' : 'not ') + 'compressed)') + '</td></tr>' +
        '<tr><td>Data path</td>' + (DataPath == null ? '<td class="empty">' : '<td>' + buttonDefaultShare(ComputerName, DataPath) + '&nbsp;' + DataPath) + '</td></tr>' +
        '<tr><td>Log path</td>' + (LogPath == null ? '<td class="empty">' : '<td>' + buttonDefaultShare(ComputerName, LogPath) + '&nbsp;' + LogPath) + '</td></tr>' +
        '<tr><td>Service account</td>' + (ServiceAccount == null ? '<td class="empty">' : '<td>' + ServiceAccount) + '</td></tr>' +
        '<tr><td>Last update</td><td>' + DateToIso8601(new Date(LastUpdateTime)) + ' by ' + LastUpdateUser + '</td></tr>' +
        '</table>';
}  // SsasDetailsShow()

/**
 * @description Create HTML link for the function SsasDetailsShow().
 * <p>2014-11-13 (NGR) Function created.</p>
 *
 * @param {String} ComputerName
 * @param {String} SsasName
 */
function linkSsasDetails(ComputerName, SsasName) {
    var tag = '<a href="#"' +
        "onclick=\"SsasDetailsShow('" + ComputerName + "','" + SsasName + "');return false;\"" +
        'title="Show details for the SQL&nbsp;Server Analysis&nbsp;Services instance&nbsp;&bdquo;' + (SsasName == '.' ? '(default)' : SsasName) + '&ldquo; on the computer&nbsp;&bdquo;' + ComputerName + '&ldquo;.">' +
        (SsasName == '.' ? '(default)' : SsasName) +
        '</a>';
    return tag;
}  // linkSsasDetails()
