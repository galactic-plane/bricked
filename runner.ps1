# Load necessary WPF assemblies
Add-Type -AssemblyName PresentationFramework

# References
. .\modules\util.ps1
. .\modules\disk.ps1

# XAML for UI Layout
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Bricked - for Windows 11 by @BrickedDev" Width="1024" Height="768" 
        WindowStartupLocation="CenterScreen" Background="#151329">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="200"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="50"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        
        <!-- Left Panel Navigation -->
        <StackPanel Grid.Column="0" Grid.RowSpan="2" Background="#060d21" VerticalAlignment="Stretch">
            <TextBlock Text="☠️" FontSize="48" Foreground="White" 
                       HorizontalAlignment="Center" Margin="0,20,0,0"/>
            <TextBlock Text="Bricked" Foreground="White" FontSize="20" 
                       HorizontalAlignment="Center" Margin="0,5,0,0" />
            <Border Height="50"/>
            <Border Background="#2E2E3E">
               <StackPanel HorizontalAlignment="Center" Width="150" Margin="20">
                    <TextBlock Text="📊" FontSize="24" Foreground="White"
                               HorizontalAlignment="Center" Cursor="Hand" />
                    <TextBlock Text="Dashboard" Foreground="White" FontSize="16" 
                               HorizontalAlignment="Center" Margin="5,0,0,0"/>
                </StackPanel>
            </Border>
        </StackPanel>
        
        <!-- Top Bar -->
        <Grid Grid.Column="1" Grid.Row="0" Background="#151329" Height="50">
            <TextBlock Text="💸" FontSize="24" Foreground="White"
                       HorizontalAlignment="Right" VerticalAlignment="Center"
                       Margin="0,0,20,0" Cursor="Hand"/>
        </Grid>
        
        <!-- Main Content Area -->
        <Grid Grid.Column="1" Grid.Row="1" Background="#060d21">
            <Grid.RowDefinitions>
                <RowDefinition Height="60*"/>
                <RowDefinition Height="50"/>
                <RowDefinition Height="40*"/>
            </Grid.RowDefinitions>
            
            <!-- Top Section with 3 Round Panels -->
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>                  
                </Grid.ColumnDefinitions>
                
               <!-- Updated Panel -->
                <Border Grid.Column="0" Background="#2e2e3e" CornerRadius="20" Padding="20" Margin="20" MaxHeight="500" HorizontalAlignment="Center" VerticalAlignment="Center">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="40*" />
                            <ColumnDefinition Width="60*" />
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*" />
                        </Grid.RowDefinitions>

                        <!-- Wrapping the icon in a Viewbox to scale with screen size -->
                        <Viewbox Grid.Column="0" HorizontalAlignment="Center" VerticalAlignment="Center">
                            <TextBlock Text="💽" FontSize="50" Foreground="White" />
                        </Viewbox>

                        <!-- Stacked Buttons -->
                        <StackPanel Grid.Column="1" VerticalAlignment="Center" HorizontalAlignment="Left">
                            <Button Name="CheckDiskBtn" Content="Check" FontSize="14" Cursor="Hand" Width="100" Height="50">
                                <Button.Style>
                                    <Style TargetType="Button">
                                        <Setter Property="Background" Value="#c54d85" />
                                        <Setter Property="Foreground" Value="White" />
                                        <Setter Property="Width" Value="100" />
                                        <Setter Property="Height" Value="50" />
                                        <Setter Property="Template">
                                            <Setter.Value>
                                                <ControlTemplate TargetType="Button">
                                                    <Border Background="{TemplateBinding Background}" 
                                                            CornerRadius="5"
                                                            BorderBrush="{TemplateBinding BorderBrush}" 
                                                            BorderThickness="{TemplateBinding BorderThickness}">
                                                        <ContentPresenter HorizontalAlignment="Center" 
                                                                        VerticalAlignment="Center" />
                                                    </Border>
                                                </ControlTemplate>
                                            </Setter.Value>
                                        </Setter>
                                        <Style.Triggers>
                                            <Trigger Property="IsMouseOver" Value="True">
                                                <Setter Property="Foreground" Value="Black" />
                                            </Trigger>
                                        </Style.Triggers>
                                    </Style>
                                </Button.Style>
                            </Button>
                            <Button Name="FixDiskBtn" Content="Fix" FontSize="14" Cursor="Hand" Width="100" Height="50" Margin="0,10,0,0">
                                <Button.Style>
                                    <Style TargetType="Button">
                                        <Setter Property="Background" Value="#c54d85" />
                                        <Setter Property="Foreground" Value="White" />
                                        <Setter Property="Width" Value="100" />
                                        <Setter Property="Height" Value="50" />
                                        <Setter Property="Template">
                                            <Setter.Value>
                                                <ControlTemplate TargetType="Button">
                                                    <Border Background="{TemplateBinding Background}" 
                                                            CornerRadius="5"
                                                            BorderBrush="{TemplateBinding BorderBrush}" 
                                                            BorderThickness="{TemplateBinding BorderThickness}">
                                                        <ContentPresenter HorizontalAlignment="Center" 
                                                                        VerticalAlignment="Center" />
                                                    </Border>
                                                </ControlTemplate>
                                            </Setter.Value>
                                        </Setter>
                                        <Style.Triggers>
                                            <Trigger Property="IsMouseOver" Value="True">
                                                <Setter Property="Foreground" Value="Black" />
                                            </Trigger>
                                        </Style.Triggers>
                                    </Style>
                                </Button.Style>
                            </Button>                  
                        </StackPanel>       
                    </Grid>
                </Border>

                <!-- Other Two Panels -->
                <Border Grid.Column="1" Background="#2e2e3e" CornerRadius="20" Padding="20" Margin="20" MaxHeight="500" HorizontalAlignment="Center" VerticalAlignment="Center"  />
                <Border Grid.Column="2" Background="#2e2e3e" CornerRadius="20" Padding="20" Margin="20" MaxHeight="500" HorizontalAlignment="Center" VerticalAlignment="Center" />               
            </Grid>

            <!-- Terminal Header (New Panel) -->
            <Border Grid.Row="1" Background="#0f0950" Height="50">
                <TextBlock Text="TERMINAL"
                           Foreground="#c54d85"
                           FontSize="20"
                           FontWeight="Bold"
                           FontFamily="Consolas"
                           HorizontalAlignment="Left"
                           VerticalAlignment="Center"
                           TextDecorations="Underline"
                           Margin="20,0,0,0"/>
            </Border>
            
           <!-- Bottom Section with Terminal-like Output Area -->
            <Border Grid.Row="2" Background="#0d0935">
                <ScrollViewer VerticalScrollBarVisibility="Visible">
                    <TextBox Name="TerminalOutput"
                            Background="#0d0935" 
                            Foreground="White" 
                            FontFamily="Consolas" 
                            FontSize="20"
                            IsReadOnly="True" 
                            TextWrapping="Wrap" 
                            BorderThickness="0"
                            Margin="20,20,0,0"/>
                </ScrollViewer>
            </Border>
        </Grid>
    </Grid>
</Window>
"@

$logo = @" 
 _______           __          __                      __ 
|       \         |  \        |  \                    |  \
| ▓▓▓▓▓▓▓\ ______  \▓▓ _______| ▓▓   __  ______   ____| ▓▓
| ▓▓__/ ▓▓/      \|  \/       \ ▓▓  /  \/      \ /      ▓▓
| ▓▓    ▓▓  ▓▓▓▓▓▓\ ▓▓  ▓▓▓▓▓▓▓ ▓▓_/  ▓▓  ▓▓▓▓▓▓\  ▓▓▓▓▓▓▓
| ▓▓▓▓▓▓▓\ ▓▓   \▓▓ ▓▓ ▓▓     | ▓▓   ▓▓| ▓▓    ▓▓ ▓▓  | ▓▓
| ▓▓__/ ▓▓ ▓▓     | ▓▓ ▓▓_____| ▓▓▓▓▓▓\| ▓▓▓▓▓▓▓▓ ▓▓__| ▓▓
| ▓▓    ▓▓ ▓▓     | ▓▓\▓▓     \ ▓▓  \▓▓\\▓▓     \\▓▓    ▓▓
 \▓▓▓▓▓▓▓ \▓▓      \▓▓ \▓▓▓▓▓▓▓\▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓▓
                                                          
by: @BrickedDev
"@

# Display ASCII Art in Terminal
Write-Host $logo -ForegroundColor Cyan

# Convert XAML string to a MemoryStream for proper parsing
$byteArray = [System.Text.Encoding]::Unicode.GetBytes($xaml)
$memoryStream = New-Object System.IO.MemoryStream (, $byteArray)
$xmlReader = [System.Xml.XmlReader]::Create($memoryStream)

# Load XAML
$window = [Windows.Markup.XamlReader]::Load($xmlReader)

# Get the terminal TextBox
$terminal = $window.FindName("TerminalOutput")

# Set initial terminal message
$initialMessage = "<@BrickedDEV>: Bricked v1.0 initialized.`r`n"
$terminal.Text = $initialMessage

# Define the CheckDiskBtn click event
$CheckDiskBtn = $window.FindName("CheckDiskBtn")
$CheckDiskBtn.Add_Click({
        Show-AliveProgress -PercentComplete 100 -Message "Loading..." -MessageDone "Loaded..." -Symbol "█" -BarLength 35 -terminal $terminal -OnComplete {
            Invoke-DiskCheck -terminal $terminal
            $terminal.Dispatcher.Invoke([Action] {
                    $terminal.AppendText("<@BrickedDEV>: Disk check starting...`r`n")
                    $terminal.ScrollToEnd()
                })
        }  
    })

# Show Window
$window.ShowDialog() | Out-Null
