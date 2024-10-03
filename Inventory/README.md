# SQLAdmin Inventory

SQL Server inventory tool with features to support daily operative tasks and activities.

The tool is with two major components

- _[SQLAdmin Inventory Server](./Server/README.md)_: Central component with data and their APIs.
- _[SQLAdmin Inventory Client](./Client/README.md)_: Thick high performance client with extended functionality. This is the primary tool to senior DBAs.

There is a simple client with [SQLAnchor](./SQLAnchor/README.md) (SQLAdmin Inventory Anchor) with some basic features. The client require some metadata that is in the _SQLAdmin Inventory_ database.

These components could be added to the tool to improve its scalability

- _SQLAdmin Inventory Core_: Central component with APIs and common functionality.
- _SQLAdmin Inventory Agent_: Component on each SQL Server node with functionality and APIs to collect and configure the SQL Server installation with functionality and APIs for effective communication with the central components.
- _SQLAdmin Inventory Portal_: Simpel central portal to supply common functionality to a wide selection of users.
- _SQLAdmin Inventory Installer_: Handle complex installation activities.
