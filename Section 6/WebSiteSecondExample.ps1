
# Install-Module -Name xWebAdministration -Force
# Install-Module -Name cAccessControlEntry -Force
Configuration WebServerSecondExample {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xWebAdministration
    Import-DscResource -ModuleName AccessControlDsc
    $myData = @{
        AllNodes = @(
            $features = @('Web-WebServer', 'Web-Mgmt-Tools', 'Web-Asp-Net45')
        )
    }

    node 'localhost' {
        foreach ($feature in $features) { 
            WindowsFeature $feature {
                Ensure = "Present"
                Name   = $feature
            }
        }

        File "MyWebsiteFolder" {
            Ensure          = "Present"
            SourcePath      = "\\file-01\mywebsite\"
            Type            = "Directory"
            DestinationPath = "C:\MyWebsite"
            Recurse         = $true
            MatchSource     = $true
        }

        xWebsite "DefaultSite" {
            Ensure          = "Present"
            Name            = "Default Web Site"
            State           = "Started"
            PhysicalPath    = "C:\myWebsite"
            DependsOn       = "[WindowsFeature]Web-WebServer"
        }

        NTFSAccessEntry "MyWebsite" {
            Path      = "c:\MyWebsite"
            DependsOn = "[File]MyWebsiteFolder"
            AccessControlList = @(
                NTFSAccessControlList {
                    Principal = "IIS_IUSRS"
                    ForcePrincipal = $true
                    AccessControlEntry = @(
                        NTFSAccessControlEntry {
                            Ensure = "Present"
                            AccessControlType = "Allow"
                            FileSystemRights = "ReadAndExecute"
                            Inheritance = "This folder and files"
                        }  
                    )
                }
            )
        }
    }
}

WebServerSecondExample
Start-DscConfiguration -Path .\WebServerSecondExample -Wait -Verbose -Force

