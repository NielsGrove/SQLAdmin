/*
DESCRIPTION
SqlAnchor configuraton file.
The file is to have different content in every environment.
Variables are declared as global variables.

Must be included first in HTA-file.

HISTORY
2015-04-44 (Niels Grove-Rasmussen) File created. Global variables moved from HTA-file.
2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
*/


// Production
//OleDbDataSource = 'tcp:******,***';
//OleDbCatalog = 'sqladmin';

// Development
//OleDbDataSource = 'tcp:******,***';
//OleDbCatalog = 'sqladmin';

// Sandbox
OleDbDataSource = '(local)';
OleDbCatalog = 'sqladmin';
