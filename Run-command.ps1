function Run-Command {
    param (
        [string]$command,
        [string]$arguments
    )
    $output = & $command $arguments.Split(" ")
    if ($DebugMode) {
        Write-Host "Debug: Full output of '$command $arguments':" -ForegroundColor Magenta
        $output | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
    }
    return $output
}