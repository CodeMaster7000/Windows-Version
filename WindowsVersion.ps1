Function Get-OSVersion {
Param($ComputerName)
    Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        $all = @()
        (Get-Childitem c:\windows\system32) | ? Length | Foreach {
            $all += (Get-ItemProperty -Path $_.FullName).VersionInfo.Productversion
        }
        $version = [System.Environment]::OSVersion.Version
        $osversion = "$($version.major).0.$($version.build)"
        $minor = @()
        $all | ? {$_ -like "$osversion*"} | Foreach {
            $minor += [int]($_ -replace".*\.")
        }
        $minor = $minor | sort | Select -Last 1
        return "$osversion.$minor"
    }
}
