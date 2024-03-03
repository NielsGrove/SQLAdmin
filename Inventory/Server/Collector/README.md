# SQLAdmin Collector

Script files that collect data for **SQLAdmin Inventory**. This is the implementation of the agent-free data collection.

Scripts are usually scheduled by SQL Server Agent.

## Optimization

The **SQLAdmin Inventory** Collector should be a (massive) multithreaded application to handle SQL Server installations in large organizations.

This will probably surpass the capabilities of PowerShell and require a refactoring to a C# or Rust application for the Collector.
