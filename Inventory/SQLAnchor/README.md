# SQLAnchor

GUI for a SQLAdmin Inventory.

This edition is based on Microsoft PowerShell and Windows Forms. It is not clear if this will just be a prototype or a more permanent edition.

Later this might be refactored to Windows Presentation Foundation (WPF) to gain some performance. .NET has some optimizations in WPF that are not in Windows Forms.

## Code Structure

The main script file is `SQLAnchor.ps1` which will start and run the program.

All functionality is in the PowerShell script module `SQLAnchor.psm1` and its submodules.

Static configuration points and their values are in the file `SQLAnchor.config.json`.
