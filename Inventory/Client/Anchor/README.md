# SQLAdmin Anchor (SQLAnchor)

Simple _HTA_ written in _JScript_ with _CSS_-themes. Ended up being fast enough, but with a too manual deployment. The application is a _DHTML_-application wrapped in a simple _HTA_ definition.

Data are in the **SQLAdmin Inventory** database. This is described in the section on **SQLAdmin Server**.

## Sub-Folders

The code is structured in a few sub-folders as described below.

### [Scripts](./Scripts/)

Application modules written in _JScript_.

Calls to the **SQLAdmin Inventory** database is done by stored procedures through _ADO_.

Tables are created dynamically in local variable before shown with a _innerHTML_ call to the _DOM_ area. This increaces speed and removes memory preassure dramatically, even with a lot of dynamically string activity in the code.

### [Themes](./Themes/)

_CSS_-files with visual themes for the **SQLAnchor** GUI.
