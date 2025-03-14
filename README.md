# bricked
This project is a PowerShell-based GUI application designed for Windows 11, developed by @BrickedDev (me).

## PowerShell Scripts

- **modules/disk.ps1**: Contains the `Invoke-DiskCheck` function which performs disk checks using CHKDSK and DISM commands, and updates the GUI terminal with the results.
- **modules/util.ps1**: Contains the `Show-AliveProgress` function which displays a progress bar in the GUI terminal, and can execute a script block upon completion.
- **runner.ps1**: The main script that sets up the GUI using WPF, loads the necessary modules, and defines the event handlers for the GUI elements.
