function Restore-TestDB {
    <#
        .SYNOPSIS
            Exports scripts from SQL Management Objects (SMO)
        .DESCRIPTION
            Exports scripts from SQL Management Objects
        .PARAMETER InputObject
            A SQL Managment Object such as the one returned from Get-DbaLogin
        .PARAMETER Path
            The output filename and location. If no path is specified, one will be created. If the file already exists, the output will be appended.
        .PARAMETER Encoding
            Specifies the file encoding. The default is UTF8.
            Valid values are:
            -- ASCII: Uses the encoding for the ASCII (7-bit) character set.
            -- BigEndianUnicode: Encodes in UTF-16 format using the big-endian byte order.
            -- Byte: Encodes a set of characters into a sequence of bytes.
            -- String: Uses the encoding type for a string.
            -- Unicode: Encodes in UTF-16 format using the little-endian byte order.
            -- UTF7: Encodes in UTF-7 format.
            -- UTF8: Encodes in UTF-8 format.
            -- Unknown: The encoding type is unknown or invalid. The data can be treated as binary.
        .PARAMETER Passthru
            Output script to console
        .PARAMETER ScriptingOptionsObject
            An SMO Scripting Object that can be used to customize the output - see New-DbaScriptingOption
        .PARAMETER WhatIf
            Shows what would happen if the command were to run. No actions are actually performed
        .PARAMETER NoClobber
            Do not overwrite file
        .PARAMETER Append
            Append to file
        .PARAMETER Confirm
            Prompts you for confirmation before executing any changing operations within the command
        .PARAMETER EnableException
            By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
            This avoids overwhelming you with "sea of red" exceptions, but is inconvenient because it basically disables advanced scripting.
            Using this switch turns this "nice by default" feature off and enables you to catch exceptions with your own try/catch.
        .NOTES
            Tags: Migration, Backup, Export
            Website: https://dbatools.io
            Copyright: (C) Chrissy LeMaire, clemaire@gmail.com
            License: GNU GPL v3 https://opensource.org/licenses/GPL-3.0
        .LINK
            https://dbatools.io/Export-DbaScript
        .EXAMPLE
            Get-DbaAgentJob -SqlInstance sql2016 | Export-DbaScript
            Exports all jobs on the SQL Server sql2016 instance using a trusted connection - automatically determines filename as .\sql2016-Job-Export-date.sql
        .EXAMPLE
            Get-DbaAgentJob -SqlInstance sql2016 | Export-DbaScript -Path C:\temp\export.sql -Append
            Exports all jobs on the SQL Server sql2016 instance using a trusted connection - Will append the output to the file C:\temp\export.sql if it already exists
        .EXAMPLE
            Get-DbaAgentJob -SqlInstance sql2016 -Job syspolicy_purge_history, 'Hourly Log Backups' -SqlCredential (Get-Credential sqladmin) | Export-DbaScript -Path C:\temp\export.sql
            Exports only syspolicy_purge_history and 'Hourly Log Backups' to C:temp\export.sql and uses the SQL login "sqladmin" to login to sql2016
        .EXAMPLE
            Get-DbaAgentJob -SqlInstance sql2014 | Export-DbaJob -Passthru | ForEach-Object { $_.Replace('sql2014','sql2016') } | Set-Content -Path C:\temp\export.sql
            Exports jobs and replaces all instances of the servername "sql2014" with "sql2016" then writes to C:\temp\export.sql
        .EXAMPLE
            $options = New-DbaScriptingOption
            $options.ScriptDrops = $false
            $options.WithDependencies = $true
            Get-DbaAgentJob -SqlInstance sql2016 | Export-DbaScript -ScriptingOptionsObject $options
            Exports Agent Jobs with the Scripting Options ScriptDrops set to $false and WithDependencies set to $true.
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
       # [parameter(Mandatory = $true, ValueFromPipeline = $true)]
       # [object[]]$InputObject,
       # [Alias("ScriptingOptionObject")]
       # [Microsoft.SqlServer.Management.Smo.ScriptingOptions]$ScriptingOptionsObject,
       # [string]$Path,
       # [ValidateSet('ASCII', 'BigEndianUnicode', 'Byte', 'String', 'Unicode', 'UTF7', 'UTF8', 'Unknown')]
       # [string]$Encoding = 'UTF8',
       # [switch]$Passthru,
       # [switch]$NoClobber,
       # [switch]$Append,
       # [switch][Alias('Silent')]$EnableException
    )
    begin {
        #$executingUser = [Security.Principal.WindowsIdentity]::GetCurrent().Name
        #$commandName = $MyInvocation.MyCommand.Name
        #$timeNow = (Get-Date -uformat "%m%d%Y%H%M%S")
        #$prefixArray = @()
    }
    process
    {
        Invoke-DbaSqlCmd -SqlInstance . -Query "RESTORE DATABASE [WideWorldImporters] FROM  DISK = N'C:\WideWorldImporters-Full.bak' WITH  FILE = 1,  MOVE N'WWI_Primary' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\WideWorldImporters.mdf',  MOVE N'WWI_UserData' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\WideWorldImporters_UserData.ndf',  MOVE N'WWI_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\WideWorldImporters.ldf',  MOVE N'WWI_InMemory_Data_1' TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\WideWorldImporters_InMemory_Data_1',  NOUNLOAD,  REPLACE,  STATS = 5"
    }
}
