# 8dot3name.ps1

Script file ([`8dot3name.ps1`](./8dot3name.ps1)) with implementation(s) on getting af short (8.3) name on a given Directory or File. The result is similar to what is given by `dir /x`.

## Backlog

- [ ] Add-Type can only add type once in a .NET AppDomain, that is in reality like a PowerShell session. It is not possible to programmatically remove custom type.  
Add-Type should be avoided.
- [ ] Function should take input on either `DirectoryInfo` or `FileInfo` type. Look into overload possibilities. Maybe using custom PowerShell class.
