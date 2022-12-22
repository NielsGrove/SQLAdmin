# Compare-Instance

Behave like [`Compare-Object`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/compare-object).

## Input

### Instances[]

### AvailabilityGroup

### FCI

### DbMirror

Backwards compability. Very low priority!

## Comparisons

- Processor; Vendor, family, frequency, sockets, cores, threads
- Memory; available, minmem, maxmem
- Storage; controller, firmware, driver, drives, size
- Network; controller, firmware, driver, TCP

### Database Engine

- SQL Server configuration; sp_configure, facets, instance
- Collation (instance)
- Version; major, minor, build, edition
- Endpoints
- Trace flags
- Traces
- XEvent sessions
- Authentication Model; SPNs
- Logins; id, name
- CCC, C2, Cross Database Ownership chaining
- Credentials
- Certificates and Keys
- Server Roles; name, members, rights
- Errorlog; audit level, generations, path
- Audits; name, specification
- master (system database); resource database
- tempdb (system database)
- Linked server(s)
- Custom error messages
- Policies
- msdb (system database)
- Database; Compress Backup, Backup Checksum, paths
- Advanced Properties; Cost Threshold for Parallelism, MaxDOP
- SQL Agent; config, jobs, steps, schedules, proxies, ids
- Availability Group; nodes, databases, roles
- FCI; nodes
- Database Replication; Publisher, Distributor

System database data:

- Data file(s); logical name, physical name, path, size, growth rate, number of files
- log file(s); (as data files)

### SQL Agent

- Jobs, steps, schedules; definition, owner, properties

### Analysis Services (SSAS)

(later)

### Integration Services (SSIS)

(Next major version)

### Reporting Services (SSRS)

(later)

### Secondary Services

(maybe)

- Master Data Service (MDS)
- Data Quality Service (DQS)

## Process

### Collect

1. Get data from each node
1. Create custom object with all data
1. ??? Export data (`Export-Clixml`) ???

### Compare

Use `Compare-Object` to ensure general compability.

Create custom object with equals and differences. This object can be accessed as output

### Analyze

Functionality outside core comparison functionality. Format compare data in prioritized groups and color markings. Present equals and differences and equals in a pedagogic way.
