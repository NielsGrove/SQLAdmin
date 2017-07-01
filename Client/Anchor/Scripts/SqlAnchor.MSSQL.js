/*
DESCRIPTION
Present product version data in SqlAnchor

Filename   : SqlAnchor.MSSQL.js

HISTORY
2012-11-22 (NGR) File created.
2014-10-31 (NGR) File renamed from "SqlAnchor.Version.js" to "SqlAnchor.MSSQL.js"
2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
*/


/*
SQL Server version
*/

function SsdbVersionsShow() {
    /*
    DESCRITION
    Show all SQL Server versions.
    HISTORY
    ???  (NGR) Function created.
    */
    document.title = 'SqlAnchor > SQL versions';

    var markup = '<h1>SQL Server version</h1>' +
        '<table><thead><td>Version Number</td>' +
        '<td>Version Level</td>' +
        '<td>Version Support End</td>' +
        '<td>DB Instance Count</td>' +
        '<td>DB Count</td>' +
        '<td>Description</td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_version-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var VersionNumber = rstDbaRepository.Fields("version_number");
        var VersionMajorNumber = rstDbaRepository.Fields("version_major");
        var VersionLevel = rstDbaRepository.Fields("version_level");
        markup += "<tr><td>" + linkMssqlVersionDetails(VersionNumber) + '&nbsp;' + buttonMssqlVersionMajorDetails(VersionMajorNumber, VersionLevel) + "</td>";
        markup += "<td>" + VersionLevel + "</td>";

        var VersionSupportEnd = rstDbaRepository.Fields("version_extended_support_end_date").Value;
        if (VersionSupportEnd == null) {
            markup += '<td class="empty"></td>';
        }
        else {
            var arrVSE = VersionSupportEnd.split('-');
            var VersionSupportEndDate = new Date(arrVSE[0], arrVSE[1], arrVSE[2]);
            var DateNow = new Date();

            if (VersionSupportEndDate < DateNow) {
                markup += '<td class="support_out">' + VersionSupportEnd + '</td>';
            }
            else {
                markup += '<td>' + VersionSupportEnd + '</td>';
            }
        }

        var SsdbCount = rstDbaRepository.Fields("ssdb_count");
        markup += '<td>' + SsdbCount + '</td>';
        var DbCount = rstDbaRepository.Fields("database_count");
        markup += (DbCount == 0 ? '<td class="empty">' : '<td>' + DbCount) + '</td>';
        var VersionDescription = rstDbaRepository.Fields("version_description");
        markup += '<td>' + VersionDescription + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();

    markup += "</table>" +
        '<p>' + buttonSsdbVersionOutOfSupport() + '</p>' +
        '<p>A list of SQL Server versions from 7.0 is available at &bdquo;<a href="http://sqlserverbuilds.blogspot.com/" title="Microsoft SQL Server 2008, 2005, 2000 and 7.0 Builds">Microsoft SQL Server 2008, 2005, 2000 and 7.0 Builds</a>&ldquo;.</p>' +
        '<p>The official Microsoft Support Lifecycle for SQL Server is at &bdquo;<a href="http://support.microsoft.com/lifecycle/?c2=1044" title="Microsoft Support Lifecycle on SQL Server">Microsoft Support Lifecycle</a>&ldquo;.</p>';

    MainArea.innerHTML = markup;
}  // SsdbVersionsShow()

function openSsdbVersionDetails(VersionNumber) {
    /*
    DESCRIPTION
    Show details on a given SQL Server version number.
    HISTORY
    ???  (NGR) Function created.
    */
    document.title = 'SqlAnchor > SQL Server version > ' + VersionNumber;

    var markup = '<h1>SQL Server version &bdquo;' + VersionNumber + '&ldquo;</h1>';

    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_version_detail-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@version_number', adVarChar, adParamInput, 128, VersionNumber));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    var VersionLevel = rstDbaRepository.Fields("version_level").Value;
    var VersionReleaseDate = rstDbaRepository.Fields("version_release_date").Value;
    var VersionSupportEnd = rstDbaRepository.Fields("version_support_end_date").Value;
    var VersionExtendedSupportEnd = rstDbaRepository.Fields("version_extended_support_end_date").Value;
    var VersionDescription = rstDbaRepository.Fields("version_description").Value;
    var SsdbCount = rstDbaRepository.Fields("ssdb_count").Value;
    rstDbaRepository.Close();
    cnnDbaRepository.Close();

    cmdDbaRepository.Parameters.Delete(0);

    markup += '<table><tr><td>Level</td><td>' + VersionLevel + '</td></tr>' +
        '<tr><td>Release date</td><td>' + (VersionReleaseDate == null ? '(unknown)' : VersionReleaseDate) + '</td></tr>';

    markup += '<tr><td>Support end date</td>';
    if (VersionSupportEnd == null) {
        markup += '<td class="empty">(unknown)</td></tr>';
    }
    else {
        var arrVSE = VersionSupportEnd.split('-');
        var VersionSupportEndDate = new Date(arrVSE[0], arrVSE[1], arrVSE[2]);
        var DateNow = new Date();

        if (VersionSupportEndDate < DateNow) {
            markup += '<td class="support_out">' + VersionSupportEnd + '</td>';
        }
        else {
            markup += '<td>' + VersionSupportEnd + '</td>';
        }
    }

    markup += '<tr><td>Extended support end date</td>'
    if (VersionExtendedSupportEnd == null) {
        markup += '<td class="empty">(unknown)</td></tr>';
    }
    else {
        var arrVSE = VersionExtendedSupportEnd.split('-');
        var VersionExtendedSupportEndDate = new Date(arrVSE[0], arrVSE[1], arrVSE[2]);
        var DateNow = new Date();

        if (VersionExtendedSupportEndDate < DateNow) {
            markup += '<td class="support_out">' + VersionExtendedSupportEnd + '</td>';
        }
        else {
            markup += '<td>' + VersionExtendedSupportEnd + '</td>';
        }
    }

    markup += '<tr><td>Database instance count</td><td>' + SsdbCount + '</td></tr></table>' +
        '<p>' + buttonSsdbVersionOutOfSupport() + '</p>' +
        '<p>' + VersionDescription + '</p>';

    markup += '<table><thead><td>SSDB name</td>' +
        '<td>Environment</td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_by_version-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@version_number', adVarChar, adParamInput, 128, VersionNumber));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields("computer_name");
        var SqlName = rstDbaRepository.Fields("ssdb_name");
        markup += "<tr><td>" + linkSsdbDetails(ComputerName, SqlName) + "&nbsp;" + buttonRemoteDesktop(ComputerName) + "</td>";
        var EnvAbb = rstDbaRepository.Fields("environment_abbreviation");
        markup += '<td>' + linkEnvironmentDetails(EnvAbb) + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);

    markup += "</table>";
    MainArea.innerHTML = markup;
}  // openSsdbVersionDetails()

function MssqlVersionMajorDetailsShow(VersionMajorNumber) {
    /*
    DESCRIPTION
    Show details on a version major number.
    HISTORY
    ???  (NGR) Function created.
    2014-11-06 (NGR) Function renamed from "openSsdbVersionMajorDetails" to "MssqlVersionMajorDetailsShow".
    2014-11-10 (NGR) Function changed to execution of the stored procedure "mssql_version_major_detail-get".
    */
    document.title = 'SqlAnchor > SQL Server major version > ' + VersionMajorNumber;

    var markup = '<h1>SQL Server major version &bdquo;' + VersionMajorNumber + '&ldquo;</h1>' +
        '<table><thead><td><a title="SQL Server service abbreviation.">Service</a></td>' +
        '<td><a title="SQL Server service instance name.">Instance Name</a></td>' +
        '<td><a title="SQL Server version number and level.">Version</a></td>' +
        '<td><a title="End date for Extended Support of the version from Microsoft.">Support End</a></td>' +
        '<td><a title="Environment abbreviation.">Environment</a></td>' +
        '<td><a title="Prose description of the SQL Server service installation (instance).">Description</a></td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[mssql_version_major_detail-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@version_major_number', adInteger, adParamInput, 4, VersionMajorNumber));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var MsSqlService = rstDbaRepository.Fields('mssql_service').Value;
        markup += '<tr><td>' + MsSqlService + '</td>';
        var ComputerName = rstDbaRepository.Fields('computer_name').Value;
        var MsSqlName = rstDbaRepository.Fields('mssql_name').Value;
        markup += '<td>' + linkComputerDetails(ComputerName);
        if (MsSqlName == '') { }
        else {
            markup += '&nbsp;\\&nbsp;' + linkSsdbDetails(ComputerName, MsSqlName) + '</td>';
        }
        var VersionNumber = rstDbaRepository.Fields('version_number').Value;
        var VersionLevel = rstDbaRepository.Fields('version_level').Value;
        markup += '<td>' + linkMssqlVersionDetails(VersionNumber) + ' (' + VersionLevel + ')</td>';
        var VersionExtendedSupportEnd = rstDbaRepository.Fields("version_extended_support_end_date").Value;
        if (VersionExtendedSupportEnd == null) {
            markup += '<td class="empty">(unknown)</td>';
        }
        else {
            var arrVSE = VersionExtendedSupportEnd.split('-');
            var VersionExtendedSupportEndDate = new Date(arrVSE[0], arrVSE[1], arrVSE[2]);
            var DateNow = new Date();

            if (VersionExtendedSupportEndDate < DateNow) {
                markup += '<td class="support_out">' + VersionExtendedSupportEnd + '</td>';
            }
            else {
                markup += '<td>' + VersionExtendedSupportEnd + '</td>';
            }
        }
        var EnvAbb = rstDbaRepository.Fields("environment_abbreviation");
        markup += '<td>' + linkEnvironmentDetails(EnvAbb) + '</td>';
        var SqlDescription = rstDbaRepository.Fields("mssql_description").Value;
        markup += (SqlDescription == null ? '<td class="empty">' : '<td>' + SqlDescription) + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);

    markup += '</table>' +
        '<p>' + buttonSsdbVersionOutOfSupport() + '</p>' +
        '<p>A list of SQL Server versions from 7.0 is available at &bdquo;<a href="http://sqlserverbuilds.blogspot.com/" title="Microsoft SQL Server 2008, 2005, 2000 and 7.0 Builds">Microsoft SQL Server 2008, 2005, 2000 and 7.0 Builds</a>&ldquo;.</p>';

    MainArea.innerHTML = markup;
}  // openSsdbVersionMajorDetails()

function openSsdbVersionOutOfSupport() {
    /*
    DESCRIPTION
    Show list of versions out of support.
    HISTORY
    ???  (NGR) Function created.
    */
    document.title = 'SqlAnchor > SQL Server versions > Out Of Support';

    var markup = '<h1>SQL Server versions Out Of Support</h1>' +
        '<table><thead><td>Computer Name</td>' +
        '<td>Instance Name</td>' +
        '<td>Version Number</td>' +
        '<td>Version Support End</td>' +
        '<td>Version Level</td>' +
        '<td>Db Count</td>' +
        '<td>Description</td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_version_out_of_support-get]';

    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields("computer_name");
        markup += "<tr><td>" + linkComputerDetails(ComputerName) + "&nbsp;" + buttonRemoteDesktop(ComputerName) + "</td>";
        var SqlName = rstDbaRepository.Fields("ssdb_name");
        markup += "<td>" + linkSsdbDetails(ComputerName, SqlName) + "&nbsp;" + buttonManagementStudio(ComputerName) + "</td>";
        var VersionNumber = rstDbaRepository.Fields("version_number");
        var VersionMajorNumber = rstDbaRepository.Fields("version_major");
        markup += "<td>" + linkMssqlVersionDetails(VersionNumber) + '&nbsp;' + buttonSsdbVersionMajorDetails(VersionMajorNumber, VersionLevel) + "</td>";
        var VersionSupportEnd = rstDbaRepository.Fields("version_extended_support_end_date").Value;
        markup += '<td>' + VersionSupportEnd + '</td>';
        var VersionLevel = rstDbaRepository.Fields("version_level");
        markup += "<td>" + VersionLevel + "</td>";
        var DbCount = rstDbaRepository.Fields("database_count");
        markup += (DbCount == 0 ? '<td class="empty">' : '<td>' + DbCount) + '</td>';
        var SqlDescription = rstDbaRepository.Fields("ssdb_description").Value;
        markup += (SqlDescription == null ? '<td class="empty">' : '<td>' + SqlDescription) + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();

    markup += "</table>";

    MainArea.innerHTML = markup;
}  // openSsdbVersionOutOfSupport()


function buttonSsdbVersionDetails(VersionNumber) {
    var tag = '<input type="button" value="&raquo;" ' +
        'onclick="openSsdbVersionDetails(\'' + VersionNumber + '\');" ' +
        'title="Show details for the SQL Server version &bdquo;' + VersionNumber + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}

function linkMssqlVersionDetails(VersionNumber) {
    /*
    DESCRIPTION
  
    HISTORY
    2014-10-31 (NGR) Function created.
    */
    var tag = '<a href="#"' +
        "onclick=\"openSsdbVersionDetails('" + VersionNumber + "');return false;\"" +
        'title="Show details for the SQL&nbsp;Server version&nbsp;&bdquo;' + VersionNumber + '&ldquo;.">' +
        VersionNumber +
        '</a>';
    return tag;
}

function buttonMssqlVersionMajorDetails(VersionMajorNumber, VersionLevel) {
    var tag = '<input type="button" value="' + VersionMajorNumber + '" ' +
        'onclick="MssqlVersionMajorDetailsShow(\'' + VersionMajorNumber + '\');" ' +
        'title="Show details for the SQL Server major version &bdquo;' + VersionMajorNumber + '&ldquo; (' + VersionLevel + ')." ' +
        'style="font-size:x-small" />';
    return tag;
}

function buttonSsdbVersionOutOfSupport() {
    var tag = '<input type="button" value="Out Of Support" ' +
        'onclick="openSsdbVersionOutOfSupport();" ' +
        'title="Show SQL Server instances Out Of Support." ' +
        'style="font-size:small;color:yellow;background-color:darkred" />';
    return tag;
}


/*
SQL Server edition
*/

function MssqlEditionsShow() {
    /*
    DESCRIPTION
    Show all SQL Server editions.
    HISTORY
    ???        (NGR) Function created.
    2014-10-31 (NGR) Function moved from file "SqlAnchor.hta" to file "SqlAnchor.MSSQL.js".
                     Function renamed fram "SsdbEditionsShow()" to "MssqlEditionsShow()".
    */
    document.title = 'SqlAnchor > SQL Server editions';

    var markup = '<h1>SQL Server Editiopn</h1>' +
        '<table><thead><td>Edition name</td><td>Edition engine name</td><td>DB Instance Count</td><td>DB Count</td><td>Description</td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_edition-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var EditionName = rstDbaRepository.Fields("edition_name");
        markup += "<tr><td>" + linkMssqlEditionDetails(EditionName) + "</td>";
        var EditionEngineName = rstDbaRepository.Fields("edition_engine_name");
        markup += "<td>" + EditionEngineName + "</td>";
        var SsdbCount = rstDbaRepository.Fields("ssdb_count");
        markup += '<td>' + SsdbCount + '</td>';
        var DbCount = rstDbaRepository.Fields("database_count");
        markup += '<td>' + DbCount + '</td>';
        var EditionDescription = rstDbaRepository.Fields("edition_description");
        markup += '<td>' + EditionDescription + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    markup += "</table>";

    MainArea.innerHTML = markup;
}  // MssqlEditionsShow()

function MssqlEditionDetailsShow(EditionName) {
    /*
    HISTORY
    ???        (NGR) Function created.
    2014-10-31 (NGR) Function moved from "SqlAnchor.DetailPages.js" to "SqlAnchor.MSSQL.js"
                     Function renamed from "openSsdbEditionDetails()" to "MssqlEditionDetailsShow()".
    */
    document.title = 'SqlAnchor > SQL Server edition > ' + EditionName;

    var markup = '<h2>SQL Server edition &bdquo;' + EditionName + '&ldquo;</h2>' +
        '<table><thead><td>Computer Name</td>' +
        '<td>SSDB Instance Name</td>' +
        '<td>Environment</td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_by_edition-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@edition_name', adVarChar, adParamInput, 128, EditionName));

    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields("computer_name");
        markup += "<tr><td>" + linkComputerDetails(ComputerName) + "&nbsp;" + buttonRemoteDesktop(ComputerName) + "</td>";
        var SqlName = rstDbaRepository.Fields("ssdb_name");
        markup += "<td>" + linkSsdbDetails(ComputerName, SqlName) + "&nbsp;" + buttonManagementStudio(ComputerName) + "</td>";
        var EnvAbb = rstDbaRepository.Fields("environment_abbreviation");
        markup += '<td>' + linkEnvironmentDetails(EnvAbb) + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);  // Delete Parameter objects as the Command object is reused

    markup += "</table>";

    MainArea.innerHTML = markup;
}  // MssqlEditionDetailsShow()


function buttonMssqlEditionDetails(EditionName) {
    /*
    HISTORY
    ???        (NGR) Function created.
    2014-10-31 (NGR) Function renamed from "buttonSsdbEditionDetails()" to "buttonMssqlEditionDetails()".
    */
    var tag = '<input type="button" value="&raquo;" ' +
        'onclick="MssqlEditionDetailsShow(\'' + EditionName + '\');" ' +
        'title="Show details for the SQL Server edition &bdquo;' + EditionName + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}

function linkMssqlEditionDetails(EditionName) {
    /*
    HISTORY
    2014-10-31 (NGR) Function created.
    */
    var tag = '<a href="#"' +
        "onclick=\"MssqlEditionDetailsShow('" + EditionName + "');return false;\"" +
        'title="Show details for the SQL&nbsp;Server edition&nbsp;&bdquo;' + EditionName + '&ldquo;.">' +
        EditionName +
        '</a>';
    return tag;
}


/*
SQL Server collation
*/

function CollationssShow() {
    /*
    HISTORY
    ???  (NGR) Function created.
    2014-10-31 (NGR) Function moved from "SqlAnchor.hta" to "SqlAnchor.MSSQL.js".
    */
    document.title = 'SqlAnchor > Collations';

    var markup = '<table><thead><td>Collation name</td><td>Instance count</td><td>Database count</td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[collation-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var CollationName = rstDbaRepository.Fields("collation_name");
        markup += "<tr><td>" + CollationName + '&nbsp;' + buttonCollationDetails(CollationName) + "</td>";
        var SsdbCount = rstDbaRepository.Fields("ssdb_count").Value;
        markup += (SsdbCount == 0 ? '<td class="empty">' : '<td>' + SsdbCount) + '</td>';
        var DbCount = rstDbaRepository.Fields("database_count").Value;
        markup += (DbCount == 0 ? '<td class="empty">' : '<td>' + DbCount) + '</td>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    markup += "</table>";

    MainArea.innerHTML = markup;
}  // CollationssShow()

function openCollationDetails(CollationName) {
    /*
    DESCRIPTION
    Show details on a SQL Server collation.
    HISTORY
    ???        (NGR) Function created
    2014-11-03 (NGR) Function moved from "SqlAnchor.DetailsPages.js" to "SqlAnchor.MSSSQL.js"
    */
    document.title = 'SqlAnchor > Collation > ' + CollationName;

    var markup = '<h2>Collation &bdquo;' + CollationName + '&ldquo;</h2>';
    cmdDbaRepository.CommandText = '[sqlanchor].[collation_detail-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@collation_name', adVarChar, adParamInput, 128, CollationName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    var CollationDescription = rstDbaRepository.Fields("collation_description").Value;
    markup += '<p>' + CollationDescription + '.</p>';
    var SsdbCount = rstDbaRepository.Fields("ssdb_count").Value;
    var DatabaseCount = rstDbaRepository.Fields("database_count").Value;
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);  // Delete Parameter objects as the Command object is reused

    markup += '<p>The collation is used by ' + SsdbCount + ' database instances and ' + DatabaseCount + ' databases.</p>';

    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_by_collation-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@collation_name', adVarChar, adParamInput, 128, CollationName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    if (rstDbaRepository.EOF) { }
    else {
        markup += '<h3>Database instances</h3>' +
            '<table><thead><td>Server name</td><td>Instance name</td><td>Instance description</td></thead>';
        while (!rstDbaRepository.EOF) {
            var ComputerName = rstDbaRepository.Fields("computer_name").Value;
            markup += "<tr><td>" + ComputerName + "&nbsp;" + buttonRemoteDesktop(ComputerName) + buttonComputerDetails(ComputerName) + "</td>";
            var SqlName = rstDbaRepository.Fields("ssdb_name").Value;
            markup += "<td>" + SqlName + "&nbsp;" + buttonManagementStudio(ComputerName) + buttonSsdbDetails(SqlName, ComputerName) + '</td>';
            var SsdbDescription = rstDbaRepository.Fields("ssdb_description").Value;
            markup += '<td>' + (SsdbDescription == null ? '' : SsdbDescription) + '</td></tr>';

            rstDbaRepository.moveNext();
        }
        markup += "</table>";
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);

    cmdDbaRepository.CommandText = '[sqlanchor].[database_by_collation-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@collation_name', adVarChar, adParamInput, 128, CollationName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    if (rstDbaRepository.EOF) { }
    else {
        markup += '<h3>Databases</h3>' +
            '<table><thead><td>Instance name</td><td>Database name</td><td>Database description</td></thead>';
        while (!rstDbaRepository.EOF) {
            var ComputerName = rstDbaRepository.Fields("computer_name").Value;
            var SqlName = rstDbaRepository.Fields("ssdb_name").Value;
            markup += "<tr><td>" + ComputerName +
                (SqlName == '.' ? '' : '\\' + SqlName) + '&nbsp;' +
                buttonRemoteDesktop(ComputerName) + buttonManagementStudio(ComputerName) + buttonSsdbDetails(SqlName, ComputerName) + '</td>';
            var DbName = rstDbaRepository.Fields("database_name").Value;
            markup += '<td>' + DbName + '</td>';
            var DbDescription = rstDbaRepository.Fields("database_description").Value;
            markup += '<td>' + (DbDescription == null ? '' : DbDescription) + '</td></tr>';

            rstDbaRepository.moveNext();
        }
        markup += "</table>";
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);  // Delete Parameter objects as the Command object is reused

    MainArea.innerHTML = markup;
}  // openCollationDetails()


function buttonCollationDetails(CollationName) {
    /*
    HISTORY
    ???        (NGR) Function created.
    2014-10-31 (NGR) Function moved from "SqlAnchor.Core.js" to "SqlAnchor.MSSQL.js".
    */
    var tag = '<input type="button" value="&raquo;" ' +
        'onclick="openCollationDetails(\'' + CollationName + '\');" ' +
        'title="Show details for the collation &bdquo;' + CollationName + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}

function linkCollationDetails(CollationName) {
    /*
    DESCRIPTION
    Create HTML link for Collation Details.
    HISTORY
    2014-11-13 (NGR) Function created.
    */
    var tag = '<a href="#"' +
        "onclick=\"openCollationDetails('" + CollationName + "');return false;\"" +
        'title="Show the SQL&nbsp;Server Collation&nbsp;&bdquo;' + CollationName + '&ldquo;.">' +
        CollationName +
        '</a>';
    return tag;
}

/*
SQL Server compability level
*/

function MssqlCompabilityLevelShow(DbCompabilityLevel) {
    /*
    DESCRIPTION
    Show details on a SQL Server compability levels and a list of installations that has the compability level.
    HISTORY
    ???        (NGR) Function created.
    2014-10-31 (NGR) Function moved from "SqlAnchor.hta" to "SqlAnchor.MSSQL.js".
                     Function renamed from "openDbCompabilityLevel()" to "MssqlCompabilityLevelShow()".
    */
    document.title = 'SqlAnchor > Databases > Compability Level > ' + DbCompabilityLevel;

    var markup = '<h1>SQL Server Compability Level &bdquo;' + DbCompabilityLevel + '&ldquo;</h1>' +
        '<table><thead><td><a title="Full SQL Server service instance name.">Instance Name</a></td>' +
        '<td><a title="SQL Server database Engine (SSDB) database name.">Database Name</a></td>' +
        '<td><a title="Environment abbreviation.">Environment</a></td></thead>';

    cmdDbaRepository.CommandText = '[sqlanchor].[database_by_compabilitylevel-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@compabilitylevel', adInteger, adParamInput, 4, DbCompabilityLevel));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields("computer_name").Value;
        var SsdbName = rstDbaRepository.Fields("ssdb_name").Value;
        markup += '<tr><td>' + linkComputerDetails(ComputerName) + '&nbsp;\\&nbsp;' + linkSsdbDetails(ComputerName, SsdbName) + '</td>';
        var DatabaseName = rstDbaRepository.Fields("database_name");
        markup += "<td>" + linkSsdbDatabaseDetails(ComputerName, SsdbName, DatabaseName) + "</td>";
        var EnvironmentAbbreviation = rstDbaRepository.Fields("environment_abbreviation");
        markup += '<td>' + linkEnvironmentDetails(EnvironmentAbbreviation) + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);  // Delete Parameter objects as the Command object is reused

    markup += "</table>";
    MainArea.innerHTML = markup;
}  // MssqlCompabilityLevelShow()


function buttonDbCompabilityLevel(DbCompabilityLevel) {
    /*
    HISTORY
    ???        (NGR) Function created.
    2014-10-31 (NGR) Function moved from ""SqlAnchor.Core.js" to "SqlAnchor.MSSQL.js".
    */
    var tag = '<input type="button" value="&raquo;" ' +
        'onclick="openDbCompabilityLevel(\'' + DbCompabilityLevel + '\');" ' +
        'title="Show details for the database compability level &bdquo;' + DbCompabilityLevel + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}

function linkMssqlCompabilityLevel(CompabilityLevel) {
    /*
    HISTORY
    2014-10-31 (NGR) Function created.
    */
    var tag = '<a href="#"' +
        "onclick=\"MssqlCompabilityLevelShow('" + CompabilityLevel + "');return false;\"" +
        'title="Show the SQL&nbsp;Server Compability&nbspLevel&nbsp;;&bdquo;' + CompabilityLevel + '&ldquo;.">' +
        CompabilityLevel +
        '</a>';
    return tag;
}
