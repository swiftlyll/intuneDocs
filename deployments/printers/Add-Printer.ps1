<#
.DESCRIPTION
    Generic printer mapping script for for Win32 deployment
.NOTES
    Author: Kennet Morales
    Date: 05/06/2024
    Last Modified: 05/20/2024
    GitHub: https://github.com/swiftlyll
#>

<# Printers #>
$myPrinter = @{
    Name = ""
    DriverName = ""
    PortName = ""
    ErrorAction = "Stop"
}

$myPrinterPort = @{
    Name = ""
    PrinterHostAddress = ""
    ErrorAction = "Stop"
}

<# Optional: Printer Configuration #>
$printerConfig = @{
    Color = $false
    DuplexingMode = "OneSided"
    ErrorAction = "SilentlyContinue"
}

<# Check for Used Ports #>
$existingPorts = Get-PrinterPort

$requiredPorts = @{
    portA = ""
    portB = ""
    portC = ""
    portD = ""
}

try {

    foreach ($printerPort in $existingPorts) {
        if ($requiredPorts.ContainsValue($printerPort.Name)) {
            Write-Output "[ERROR] Printer port $($printerPort.Name) is currently in use"
            $requiredPortExists = $true
        }
    }

    if ($requiredPortExists) {
        Write-Output "[INFO] Exiting"
        Remove-Variable -Name "requiredPortExists"
        Exit 1
    }

}

catch {

    Write-Output "[ERROR] Failed to run validation"
    Exit 1

}

<# Mapping #>
try {

    # Printer
    Write-Output "[INFO] Creating port for $($myPrinter.Name)"
    Add-PrinterPort @myPrinterPort
    Write-Output "[INFO] Adding printer $($myPrinter.Name)"
    Add-Printer @myPrinter
    Write-Output "[INFO] Successfully added $($myPrinter.Name)"

    # Optional: B&W and Duplex Settings
    Set-PrintConfiguration -PrinterName $myPrinter.Name @printerConfig
    Exit 0

}

catch {

    Write-Output "[ERROR] Failed to map printers"
    Exit 1

}