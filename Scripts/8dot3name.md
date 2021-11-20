# 8dot3name.ps1

Script file ([`8dot3name.ps1`](./8dot3name.ps1)) with implementation(s) on getting af short (8.3) name on a given Directory or File. The result is similar to what is given by `dir /x`.

## Backlog

- [ ] `Add-Type` can only add type once in a .NET AppDomain, that is in reality like a PowerShell session. It is not possible to programmatically remove custom type.  
Investigate if `Add-Type` can be avoided.
- [x] Function should take input on either `DirectoryInfo` or `FileInfo` type. Look into overload possibilities. Maybe using custom PowerShell class. Or `ParameterSetName`.
- [ ] Validate parameter value; does object exist.

## Link

Microsoft Docs: [`GetShortPathNameW` function (`fileapi.h`)](https://docs.microsoft.com/da-dk/windows/win32/api/fileapi/nf-fileapi-getshortpathnamew)

Idera Community: [Converting File Paths to 8.3 (Part 2)](https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/converting-file-paths-to-8-3-part-2)
