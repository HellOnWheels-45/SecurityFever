
<#
    .SYNOPSIS
    Removes an existing entry in the Windows Credential Manager vault.

    .DESCRIPTION
    This cmdlet uses the native unmanaged Win32 api to remove a existing entry
    in the Windows Credential Manager vault.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Get-VaultEntry -TargetName 'MyUserCred' -Type 'DomainPassword' -Persist 'Session' | Remove-VaultEntry
    Remove the Credential Manager vault entry which was piped to the cmdlet.

    .EXAMPLE
    PS C:\> Remove-VaultEntry -TargetName 'MyUserCred' -Type 'DomainPassword'
    Remove the Credential Manager vault entry with the specified target name and
    type.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/SecurityFever
#>

function Remove-VaultEntry
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        # The target entry to delete as objects.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Object')]
        [SecurityFever.CredentialManager.CredentialEntry[]]
        $InputObject,

        # The name of the target entry to delete.
        [Parameter(Mandatory = $true, ParameterSetName = 'Properties')]
        [System.String]
        $TargetName,

        # The type of the target entry to delete.
        [Parameter(Mandatory = $true, ParameterSetName = 'Properties')]
        [SecurityFever.CredentialManager.CredentialType]
        $Type
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Properties')
        {
            [SecurityFever.CredentialManager.CredentialStore]::RemoveCredential($TargetName, $Type)
        }
        else
        {
            foreach ($object in $InputObject)
            {
                [SecurityFever.CredentialManager.CredentialStore]::RemoveCredential($object.TargetName, $object.Type)
            }
        }
    }
}