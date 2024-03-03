/*
DESCRIPTION
SQL Server Master Data Services (MDS) in SQLAnchor.

HISTORY
2018-08-13 (Niels Grove-Rasmussen) Comments converted to JSDoc.
2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
2014-10-24 (Niels Grove-Rasmussen) File created. Initial content pasted from SqlAnchor.hta
*/

/**
 * @description Show all MDS installation registrered in SQLAdmin Repository.
 * <p>2014-10-14 (NGR) Function created.</p>
 */
function MdsShow() {
    document.title = 'SqlAnchor > MDS';

    var markup = '<h1>SQL Server Master Data Services (MDS)</h1>' +
        '<table><thead><td><a title="Computer full domain name (FQDN).">Computer name</a></td>' +
        '<td><a title="MDS database name.">Database</a></td>' +
        '<td><a title="URL for MDS Master Data Manager.">Master Data Manager</a></td>' +
        '<td><a title="Name of Internet Information Server (IIS) Application Pool service account.">AppPool service account</a></td>' +
        '<td><a title="Environment abbrevation.">Environment</a></td>' +
        '<td><a title="Prose description of MDS installation.">Description</a></td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[mds-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields('computer_name').Value;
        var SsdbName = rstDbaRepository.Fields('ssdb_name').Value;
        markup += '<tr><td>' + linkMdsDetails(ComputerName, SsdbName, DatabaseName) + '&nbsp;' + buttonSsdbDetails(SsdbName, ComputerName) + '</td>';
        var DatabaseName = rstDbaRepository.Fields('database_name').Value;
        markup += '<td>' + linkSsdbDatabaseDetails(ComputerName, SsdbName, DatabaseName) + '</td>';
        var MasterDataManagerUrl = 'http://' + ComputerName + ':8080';
        markup += '<td><a href="' + MasterDataManagerUrl + '" title="Click to open MDS Master Data Manager or copy link to specific usage.">' + MasterDataManagerUrl + '</td>';
        var AppPoolSvcAcc = rstDbaRepository.Fields('mds_applicationpool_serviceaccount').Value;
        markup += '<td>' + AppPoolSvcAcc + '</td>';
        var EnvironmentAbbreviation = rstDbaRepository.Fields('environment_abbreviation').Value;
        markup += '<td>' + linkEnvironmentDetails(EnvironmentAbbreviation) + '</td>';
        var MdsDescription = rstDbaRepository.Fields('mds_description').Value;
        markup += '<td>' + MdsDescription + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();

    markup += '</table>';
    MainArea.innerHTML = markup;
}  // MdsShow()

/**
 * @description Show details on SQL Server Master Data Services (MDS) installation.
 * <p>2014-10-24 (NGR) Function created.</p>
 *
 * @param {String} ComputerName
 * @param {String} SsdbName
 * @param {String} DatabaseName
 */
function MdsDetailsShow(ComputerName, SsdbName, DatabaseName) {
    document.title = 'SQLAnchor > MDS > ' + ComputerName;

    var MasterDataManagerUrl = 'http://' + ComputerName + ':8080';

    var markup = '<p>Computer: &bdquo;' + ComputerName + '&ldquo;</p>' +
        '<p>Computer: &bdquo;' + linkComputerDetails(ComputerName) + '&ldquo;</p>' +
        '<p>Database Engine instance: &bdquo;' + linkSsdbDetails(ComputerName, SsdbName) + '&ldquo;</p>' +
        '<p>Database: &bdquo;' + linkSsdbDatabaseDetails(ComputerName, SsdbName, DatabaseName) + '&ldquo;</p>' +
        '<p>Master Data Manager: <a href="' + MasterDataManagerUrl + '" title="Click to open MDS Master Data Manager or copy link to specific usage.">' + MasterDataManagerUrl + '</p>';

    MainArea.innerHTML = markup;
}

/**
 * @description Create HTML link for the function MdsDetailsShow().
 * <p>2014-10-24 (NGR) Function created.</p>
 *
 * @param {String} ComputerName
 * @param {String} SsdbName
 * @param {String} DatabaseName
 */
function linkMdsDetails(ComputerName, SsdbName, DatabaseName) {
    var tag = '<a href="#"' +
        "onclick=\"MdsDetailsShow('" + ComputerName + "','" + SsdbName + "','" + DatabaseName + "');return false;\"" +
        'title="Show details for the MDS installation on the computer &bdquo;' + ComputerName + '&ldquo;.">' +
        ComputerName +
        '</a>';
    return tag;
}
