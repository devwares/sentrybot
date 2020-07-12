function Test-function
{
    param
    (
        [Parameter(Mandatory=$true)] [string]
        # Server name
        $Server,

        [Parameter(Mandatory=$false)] [int]
        # Port number   
        $Port,

        [Parameter(Mandatory=$false)] [string]
        $option
         
    )

    $server

    <#
        .SYNOPSIS
        Test function to demonstrate how to define help.

        .DESCRIPTION
        Demonstrates how to write help.
        Works for a function, or an entire script.
        To see help, type "Get-Help Test-Function -Full"

        .PARAMETER Option
        Specifies options

        .INPUTS
        None. You cannot pipe objects to Test-Function.

        .OUTPUTS
        System.String. Test-Function returns a string with the server name.

        .EXAMPLE
        C:\PS> Test-Function -name "some.server.com"
        some.server.com

        .EXAMPLE
        C:\PS> Test-Function -name "some.server.com" -port 80
        some.server.com

        .EXAMPLE
        C:\PS> Test-Function -name "some.server.com" -port 80 -option "scan"
        some.server.com

        .LINK
        Online version: https://docs.microsoft.com/fr-fr/powershell/

        .LINK
        Set-Item
    #>
}