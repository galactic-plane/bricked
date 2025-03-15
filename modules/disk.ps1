function Invoke-DiskCheck {
    param (
        [System.Windows.Controls.TextBox]$terminal,
        [System.Windows.Controls.ScrollViewer]$scrollViewer
    )

    $syncHash = [hashtable]::Synchronized(@{})
    $syncHash.Terminal = $terminal
    $syncHash.ScrollViewer = $scrollViewer

    # Create a new runspace for async execution
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.Open()
    $runspace.SessionStateProxy.SetVariable("syncHash", $syncHash)

    $scriptBlock = {
        # Check if the script is running as an administrator
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
        if (-not $isAdmin) {
            $syncHash.Terminal.Dispatcher.Invoke([Action] {
                    $syncHash.Terminal.AppendText("<@BrickedDEV>: Please run the application as an administrator.`r`n")
                    $syncHash.ScrollViewer.ScrollToEnd()
                })
            return
        }

        function Get-OSDrive {
            $osDrive = (Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq (Get-WmiObject Win32_OperatingSystem).SystemDrive + "\" }).Name + ":"
            return $osDrive  # Ensure it is formatted properly for CHKDSK
        }

        function Test-CommandStatus {
            param ($CommandString)
            
            $syncHash.Terminal.Dispatcher.Invoke([Action] {
                    $syncHash.Terminal.AppendText("<@BrickedDEV>: Running: ${CommandString}`r`n")
                    $syncHash.ScrollViewer.ScrollToEnd()
                })
        
            $logPath = "${env:TEMP}\cmd_output.log"
            $errPath = "${env:TEMP}\cmd_error.log"
        
            # Ensure log files do not exist before execution
            Remove-Item -Path $logPath, $errPath -ErrorAction SilentlyContinue
        
            $process = Start-Process -FilePath "pwsh.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command ${CommandString}" -PassThru -RedirectStandardOutput $logPath -RedirectStandardError $errPath
        
            if ($null -eq $process) {
                $syncHash.Terminal.Dispatcher.Invoke([Action] {
                        $syncHash.Terminal.AppendText("<@BrickedDEV>: ERROR: Failed to start process for ${CommandString}`r`n")
                        $syncHash.ScrollViewer.ScrollToEnd()
                    })
                return "Failed"
            }

            $process.WaitForExit()
        
            $output = if (Test-Path $logPath) { Get-Content -Path $logPath -Raw } else { "" }
            $errorOutput = if (Test-Path $errPath) { Get-Content -Path $errPath -Raw } else { "" }
        
            if ($output) {
                $syncHash.Terminal.Dispatcher.Invoke([Action] {
                        $syncHash.Terminal.AppendText("<@BrickedDEV>: ${output}`r`n")
                        $syncHash.ScrollViewer.ScrollToEnd()
                    })
            }

            if ($errorOutput) {
                $syncHash.Terminal.Dispatcher.Invoke([Action] {
                        $syncHash.Terminal.AppendText("<@BrickedDEV>: ERROR: ${errorOutput}`r`n")
                        $syncHash.ScrollViewer.ScrollToEnd()
                    })
            }
        
            # Delete log files to release handles
            Remove-Item -Path $logPath, $errPath -ErrorAction SilentlyContinue
        
            return if ($null -eq $process.ExitCode -or $process.ExitCode -eq 0) { "Passed" } else { "Failed" }
        }        

        $osDrive = Get-OSDrive
        $chkDskStatus = Test-CommandStatus "chkdsk ${osDrive} /scan"
        $dismCheckStatus = Test-CommandStatus "dism /online /cleanup-image /checkhealth"
        $dismScanStatus = Test-CommandStatus "dism /online /cleanup-image /scanhealth"

        $output = @(
            "<@BrickedDEV>: CHKDSK (${osDrive}): ${chkDskStatus}",
            "<@BrickedDEV>: DISM Check: ${dismCheckStatus}",
            "<@BrickedDEV>: DISM Scan: ${dismScanStatus}"
        )

$table = @"
| Command       | Status                                           
|---------------|--------------------------------------------------
| CHKDSK        | ${chkDskStatus}
| DISM Check    | ${dismCheckStatus}
| DISM Scan     | ${dismScanStatus}
"@

        $finalMessage = if ($chkDskStatus -eq "Failed" -or $dismCheckStatus -eq "Failed" -or $dismScanStatus -eq "Failed") {
            "<@BrickedDEV>: One or more checks failed. Please click the fix button."
        }
        else {
            "<@BrickedDEV>: All checks passed. No further action needed."
        }

        $syncHash.Terminal.Dispatcher.Invoke([Action] {
                $syncHash.Terminal.Clear()
                $syncHash.Terminal.AppendText("${table}`r`n${finalMessage}`r`n")
                $syncHash.ScrollViewer.ScrollToEnd()
            })
    }

    $ps = [powershell]::Create().AddScript($scriptBlock)
    $ps.Runspace = $runspace
    $ps.BeginInvoke()
}