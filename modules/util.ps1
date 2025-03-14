function Show-AliveProgress {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, 100)]
        [int]$PercentComplete,
        [string]$Message = "Loading...", 
        [string]$MessageDone = "Loaded...",       
        [string]$Symbol = "█",        
        [int]$BarLength = 30,
        [System.Windows.Controls.TextBox]$terminal,
        [scriptblock]$OnComplete
    )

    # Ensure global StartTime exists
    if (-not $global:StartTime) {
        $global:StartTime = Get-Date
    }

    $syncHash = [hashtable]::Synchronized(@{})
    $syncHash.Terminal = $terminal
    $syncHash.PercentComplete = $PercentComplete
    $syncHash.Message = $Message
    $syncHash.MessageDone = $MessageDone
    $syncHash.Symbol = $Symbol
    $syncHash.BarLength = $BarLength
    $syncHash.StartTime = $global:StartTime
    $syncHash.OnComplete = $OnComplete

    # Create a new runspace for async execution
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.Open()
    $runspace.SessionStateProxy.SetVariable("syncHash", $syncHash)

    $scriptBlock = {
        $currentPercent = 0
        $symbol = $syncHash.Symbol

        # Clear the terminal before starting
        $syncHash.Terminal.Dispatcher.Invoke([Action] {
                $syncHash.Terminal.Text = ""
                $syncHash.Terminal.ScrollToHome()
            })

        while ($currentPercent -lt $syncHash.PercentComplete) {
            $currentPercent = [math]::Min($currentPercent + 10, $syncHash.PercentComplete) # Increment up to target

            $filledCount = [math]::Floor(($currentPercent / 100) * $syncHash.BarLength)
            $emptyCount = $syncHash.BarLength - $filledCount

            # Construct the visual bar correctly
            $bar = ($symbol * $filledCount) + ("-" * $emptyCount)

            # Estimate remaining time
            $elapsed = (Get-Date) - $syncHash.StartTime
            $remaining = if ($currentPercent -gt 0) { $elapsed.TotalSeconds / ($currentPercent / 100) - $elapsed.TotalSeconds } else { 0 }
            $eta = if ($currentPercent -lt 100) { "ETA: " + [math]::Round($remaining, 1) + "s" } else { "Done!" }

            # Update UI thread safely
            $syncHash.Terminal.Dispatcher.Invoke([Action] {
                    $syncHash.Terminal.Text = if ($currentPercent -lt 100) { "$($syncHash.Message) [$bar] $currentPercent% $eta" } else { "$($syncHash.MessageDone) [$bar] $currentPercent% $eta" }
                    $syncHash.Terminal.ScrollToEnd()
                })

            Start-Sleep -Milliseconds 100 # Animation effect
        }

        # Move to the next line after completion
        $syncHash.Terminal.Dispatcher.Invoke([Action] {
                $syncHash.Terminal.AppendText("`r`n")
                $syncHash.Terminal.ScrollToEnd()            
            })

        # Run the OnComplete script block if provided
        if ($null -ne $syncHash.OnComplete) {
            & $syncHash.OnComplete
        }        
    }

    $ps = [powershell]::Create().AddScript($scriptBlock)
    $ps.Runspace = $runspace
    $ps.BeginInvoke()
}