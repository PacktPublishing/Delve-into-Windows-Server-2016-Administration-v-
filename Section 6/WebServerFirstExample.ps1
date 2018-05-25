
Configuration WebServerFirstExample {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    node 'localhost' {
        WindowsFeature "IIS" {
            Ensure     = "Present"
            Name       = "Web-WebServer"
        }
    }

}

WebServerFirstExample
Start-DscConfiguration -Path .\WebServerFirstExample -Verbose -Wait -Force

