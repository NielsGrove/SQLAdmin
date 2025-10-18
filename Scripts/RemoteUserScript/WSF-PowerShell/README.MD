# WSF through PowerShell

1. A WSF-file ([`RemoteUserScript.wsf`](/RemoteUserScript.wsf)) is in the desktop shortcut.
    - Shortcut command: `cscript.exe ...`
1. This copy PowerShell files to local storage. And the execute the local PowerShell script.
1. The local PowerShell script copy application files to local storage.
1. ...and then execute the application files.

- Every copy to local storage is with RoboCopy to reduce copy activity to only required files.
- Every step is logged in a simple way to a local file. This can be improved!

