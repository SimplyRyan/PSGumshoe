function Get-SysmonDriverLoadEvent {
    <#
    .SYNOPSIS
        Get Sysmon Driver Load events (EventId 6).
    .DESCRIPTION
        The driver loaded events provides information about a driver being loaded on the system. 
        The configured hashes are provided as well as signature information. The signature is 
        created asynchronously for performance reasons and indicates if the file was removed 
        after loading.
    .EXAMPLE
        PS C:\> Get-SysmonDriverLoadEvent -Path ..\Desktop\sysmondriver.evtx  -SignatureStatus Expired

        EventId         : 6
        EventType       : DriverLoad
        Computer        : DESKTOP-4TVLVMD
        EventRecordID   : 10562189
        RuleName        :
        UtcTime         : 2019-07-27 02:27:51.075
        ImageLoaded     : C:\mimi\x64\mimidrv.sys
        Hashes          : SHA1=02A9314109E47C5CE52FA553EA57070BF0F8186A
        Signed          : false
        Signature       :
        SignatureStatus : Expired

        Find drivers loaded with expired signature.
    .INPUTS
        System.IO.FileInfo
    .OUTPUTS
        Sysmon.EventRecord.DriverLoad
    .NOTES
        https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=90006
    #>
    [CmdletBinding(DefaultParameterSetName = 'Local')]
    param (
        # Log name for where the events are stored.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]
        $LogName = 'Microsoft-Windows-Sysmon/Operational',

        # Image that was was loaded as a driver.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $ImageLoaded,

        # If the image loaded as a driver is signed.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('true','false')]
        [string]
        $Signed,

        # If the signature on the driver is valid or not
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Valid','Expired')]
        [string]
        $SignatureStatus,

        # Signature field referencing the signer of the driver.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Signature,

        # Imange hash.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Hashes,

        # Rule Name for filter that generated the event.
        [Parameter(Mandatory = $false)]
        [string[]]
        $RuleName,

        # Specifies the path to the event log files that this cmdlet get events from. Enter the paths to the log files in a comma-separated list, or use wildcard characters to create file path patterns. Function supports files with the .evtx file name extension. You can include events from different files and file types in the same command.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="file",
                   ValueFromPipelineByPropertyName=$true)]
        [Alias("FullName")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Path,


        # Gets events from the event logs on the specified computer. Type the NetBIOS name, an Internet Protocol (IP) address, or the fully qualified domain name of the computer.
        # The default value is the local computer.
        # To get events and event logs from remote computers, the firewall port for the event log service must be configured to allow remote access.
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   ParameterSetName = 'Remote')]
        [string[]]
        $ComputerName,

        # Specifies a user account that has permission to perform this action.
        #
        # Type a user name, such as User01 or Domain01\User01. Or, enter a PSCredential object, such as one generated by the Get-Credential cmdlet. If you type a user name, you will
        # be prompted for a password. If you type only the parameter name, you will be prompted for both a user name and a password.
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'Remote')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential,

        # Specifies the maximum number of events that are returned. Enter an integer. The default is to return all the events in the logs or files.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [int64]
        $MaxEvents,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $StartTime,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $EndTime,

        # Changes the default logic for matching fields from 'and' to 'or'.
        [Parameter(Mandatory = $false)]
        [switch]
        $ChangeLogic,

        # Changes the query action from inclusion to exclusion when fields are matched.
        [Parameter(Mandatory = $false)]
        [switch]
        $Suppress
    )

    begin {}

    process {
        Search-SysmonEvent -EventId 6 -ParamHash $MyInvocation.BoundParameters

    }

    end {}
}