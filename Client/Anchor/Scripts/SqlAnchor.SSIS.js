/*
DESCRIPTION
SQL Server Integration Services (SSIS) in SQLAnchor.

HISTORY
2014-10-30 (Niels Grove-Rasmussen) File created. Initial content pasted from SqlAnchor.hta, SqlAnchor.Core.js and SqlAnchor.DetailPages.js
2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
*/

function SsisShow() {
    document.title = 'SqlAnchor > SSIS';

    var markup = '<h1>SQL Server Integrations Services (SSIS)</h1>' +
        '<table><thead><td><a title="Full Domain Name (FQDN) of computer.">Computer name</a></td>' +
        '<td><a title="Environment abbreviation.">Environment</a></td>' +
        '<td><a title="Prose description of SSIS installation.">Description</a></td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[ssis-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields('computer_name').Value;
        var SsdbName = rstDbaRepository.Fields('ssdb_name').Value;
        var EnvironmentAbbreviation = rstDbaRepository.Fields('environment_abbreviation').Value;
        var SsisDescription = rstDbaRepository.Fields('ssis_description').Value;

        markup += '<tr><td>' + linkComputerDetails(ComputerName) + '&nbsp;' + buttonRemoteDesktop(ComputerName) + buttonAdminRemoteDesktop(ComputerName) + buttonSsdbDetails(SsdbName, ComputerName) + '</td>' +
            '<td>' + linkEnvironmentDetails(EnvironmentAbbreviation) + '</td>' +
            '<td>' + (SsisDescription == null ? '' : SsisDescription) + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    markup += "</table>";

    MainArea.innerHTML = markup;
}  // SsisShow()
