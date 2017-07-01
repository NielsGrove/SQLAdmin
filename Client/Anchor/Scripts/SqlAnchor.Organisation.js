/*
DESCRIPTION
Present organisation data in SqlAnchor

Filename   : SqlAnchor.Organisation.js

HISTORY
2012-09-13 (Niels Grove-Rasmussen) File created.
2014-10-31 (Niels Grove-Rasmussen) File renamed from "SqlAnchor.Environment.js" to "SqlAnchor.Organisation.js".
2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
*/

/*
Environment
*/

function EnvironmentsShow() {
    /*
    HISTORY
    ???  (NGR) Function created.
    */
    document.title = 'SqlAnchor > Environments';

    var markup = '<h1>Environment</h1>' +
        '<table><thead><td>Environment name</td>' +
        '<td>Environment abbreviation</td>' +
        '<td>Description</td>' +
        '<td>DB Instance Count</td>' +
        '<td>DB Count</td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[environment-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var EnvironmentName = rstDbaRepository.Fields("environment_name");
        markup += "<tr><td>" + EnvironmentName + "</td>";
        var EnvironmentAbbreviation = rstDbaRepository.Fields("environment_abbreviation");
        markup += "<td>" + linkEnvironmentDetails(EnvironmentAbbreviation) + "</td>";
        var EnvironmentDescription = rstDbaRepository.Fields("environment_description");
        markup += '<td>' + EnvironmentDescription + '</td>';
        var SsdbCount = rstDbaRepository.Fields("ssdb_count");
        markup += '<td>' + SsdbCount + '</td>';
        var DatabaseCount = rstDbaRepository.Fields("database_count");
        markup += '<td>' + DatabaseCount + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    markup += "</table>";

    MainArea.innerHTML = markup;
}  // EnvironmentsShow()


function openEnvironmentDetails(EnvironmentAbbreviation) {
    /*
    HISTORY
    ???  (NGR) Function created.
    */
    cmdDbaRepository.CommandText = '[sqlanchor].[environment_detail-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@environment_abbreviation', adChar, adParamInput, 3, EnvironmentAbbreviation));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    var EnvironmentName = rstDbaRepository.Fields("environment_name").Value;
    var EnvironmentDescription = rstDbaRepository.Fields("environment_description").Value;
    var SsdbCount = rstDbaRepository.Fields("ssdb_count").Value;
    var DatabaseCount = rstDbaRepository.Fields("database_count").Value;
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    // Delete Parameter objects as the Command object is reused
    cmdDbaRepository.Parameters.Delete(0);

    document.title = 'SqlAnchor > Environment > ' + EnvironmentName;

    var markup = '<h1>Environment &bdquo;' + EnvironmentName + '&ldquo;</h1>' +
        '<table><tr><td>Abbreviation</td><td>' + EnvironmentAbbreviation + '</td></tr>' +
        '<tr><td>Database instance count</td><td>' + SsdbCount + '</td></tr>' +
        '<tr><td>Database count</td><td>' + DatabaseCount + '</td></tr></table>' +
        '<p>' + EnvironmentDescription + '</p>' +
        '<table><thead><td>Instance name</td>' +
        '<td>Version</td>' +
        '<td>Version Support End</td>' +
        '<td>Edition</td>' +
        '<td>Description</td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[ssdb_by_environment-get]';
    cmdDbaRepository.Parameters.Append(cmdDbaRepository.CreateParameter('@environment_name', adVarChar, adParamInput, 128, EnvironmentName));
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var ComputerName = rstDbaRepository.Fields("computer_name").Value;
        var SqlName = rstDbaRepository.Fields("ssdb_name").Value;
        var SqlEdition = rstDbaRepository.Fields("edition_name").Value;
        var SqlVersionNumber = rstDbaRepository.Fields("version_number").Value;
        var SqlVersionMajor = rstDbaRepository.Fields("version_major").Value;
        var SqlVersionLevel = rstDbaRepository.Fields("version_level").Value;
        var SqlVersionSupportEnd = rstDbaRepository.Fields("version_extended_support_end_date").Value;
        var SqlDescription = rstDbaRepository.Fields("ssdb_description").Value;

        markup += "<tr><td>" + linkComputerDetails(ComputerName) + '&nbsp;\\&nbsp;' + linkSsdbDetails(ComputerName, SqlName) + '&nbsp;' + buttonRemoteDesktop(ComputerName) + '</td>' +
            '<td>' + linkMssqlVersionDetails(SqlVersionNumber) + '&nbsp;(' + SqlVersionLevel + ')&nbsp;' + buttonMssqlVersionMajorDetails(SqlVersionMajor, SqlVersionLevel) + '</td>';

        if (SqlVersionSupportEnd == null) {
            markup += '<td class="empty"></td>';
        }
        else {
            var arrVSE = SqlVersionSupportEnd.split('-');
            var SqlVersionSupportEndDate = new Date(arrVSE[0], arrVSE[1], arrVSE[2]);
            var DateNow = new Date();

            if (SqlVersionSupportEndDate < DateNow) {
                markup += '<td class="support_out">' + SqlVersionSupportEnd + '</td>';
            }
            else {
                markup += '<td>' + SqlVersionSupportEnd + '</td>';
            }
        }

        markup += '<td>' + linkMssqlEditionDetails(SqlEdition) + '</td>';
        markup += '<td>' + (SqlDescription == null ? '' : SqlDescription) + '</td></tr>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    cmdDbaRepository.Parameters.Delete(0);
    markup += "</table>";

    MainArea.innerHTML = markup;
}  // openEnvironmentDetails()


function linkEnvironmentDetails(EnvironmentAbbreviation) {
    /*
    DESCRIPTION
    Create HTML link for the function openEnvironmentDetails().
    HISTRORY
    2014-10-24 (NGR) Function created.
    */
    var tag = '<a href="#"' +
        "onclick=\"openEnvironmentDetails('" + EnvironmentAbbreviation + "');return false;\"" +
        'title="Show details for the environment &bdquo;' + EnvironmentAbbreviation + '&ldquo;.">' +
        EnvironmentAbbreviation +
        '</a>';
    return tag;
}

function buttonEnvironmentDetails(EnvironmentName) {
    /*
    DESCRIPTION
    Create HTML button for the function openEnvironmentDetaions().
    HISTORY
    ???  (NGR) Function created.
    */
    var tag = '<input type="button" value="&raquo;" ' +
        'onclick="openEnvironmentDetails(\'' + EnvironmentName + '\');" ' +
        'title="Show details for the environment &bdquo;' + EnvironmentName + '&ldquo;." ' +
        'style="font-size:xx-small" />';
    return tag;
}


/*
Department
*/

function DepartmentsShow() {
    /*
    HISTORY
    ???        (NGR) Function created.
    2014-10-31 (NGR) Function moved from "SqlAnchor.hta" to "SqlAnchor.Organisation.js"
    */
    document.title = 'SqlAnchor > Departments';

    var markup = '<h1>Department</h1>' +
        '<table><thead><td>Department name</td>' +
        '<td>Dep. abb.</td>' +
        '<td>Department name (EN)</td></thead>';
    cmdDbaRepository.CommandText = '[sqlanchor].[department-get]';
    cnnDbaRepository.Open();
    cmdDbaRepository.ActiveConnection = cnnDbaRepository;
    rstDbaRepository = cmdDbaRepository.Execute();
    while (!rstDbaRepository.EOF) {
        var DepartmentName = rstDbaRepository.Fields("department_name");
        markup += '<tr><td>' + linkDepartmentDetails(DepartmentName) + '</td>';
        var DepartmentAbb = rstDbaRepository.Fields("department_abbreviation").Value;
        markup += '<td>' + DepartmentAbb + '</td>';
        var DepartmentName_EN = rstDbaRepository.Fields("department_name_en").Value;
        markup += '<td>' + DepartmentName_EN + '</td>';

        rstDbaRepository.moveNext();
    }
    rstDbaRepository.Close();
    cnnDbaRepository.Close();
    markup += '</table>';

    MainArea.innerHTML = markup;
}  // DepartmentsShow()

function DepartmentDetailsShow(DepartmentName) {
    /*
    HISTORY
    ???        (NGR) Function created
    2014-10-31 (NGR) Function moved from "SqlAnchor.DetailPages.js" to "SqlAnchor.Organisation.js"
                     Function renamed from "openDepartmentDetails()" to "DepartmendDetailsShow()"
    */
    document.title = 'SqlAnchor > Department > ' + DepartmentName;

    var markup = '<h1>Department &bdquo;' + DepartmentName + '&ldquo;</h1>'

    MainArea.innerHTML = markup;
}


function linkDepartmentDetails(DepartmentName) {
    /*
    HISTORY
    2014-10-31 (NGR) Function created
    */
    var tag = '<a href="#"' +
        "onclick=\"DepartmentDetailsShow('" + DepartmentName + "');return false;\"" +
        'title="Show details for the department&nbsp;&bdquo;' + DepartmentName + '&ldquo;.">' +
        DepartmentName +
        '</a>';
    return tag;

}

function buttonDepartmentDetails(DepartmentName) {
    /*
    HISTORY
    ???        (NGR) Function created
    2014-10-31 (NGR) Function moved from "SqlAnchor.Core.js" to "SqlAnchor.Organisation.js"
    */
    var tag = '<input type="button" value="&raquo;" ' +
        'onclick="openDepartmentDetails(\'' + DepartmentName + '\');" ' +
        'title="Show details for the department &bdquo;' + DepartmentName + '&ldquo;." ' +
        'style="font-size:x-small" />';
    return tag;
}
