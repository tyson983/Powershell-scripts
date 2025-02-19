# Run a command
function RunCommand([ScriptBlock] $command) {

    # Run the command and write the output to the window and to a variable ("SFC" formatting)
    $stringcommand = $command.ToString()
    if (
        $stringcommand -match "^SFC$" -or
        $stringcommand -match "^SFC.exe$" -or
        $stringcommand -match "^SFC .*$" -or
        $stringcommand -match "^SFC.exe .*$"
    ) {
        $oldEncoding = [console]::OutputEncoding
        [console]::OutputEncoding = [Text.Encoding]::Unicode
        $command = [ScriptBlock]::Create("(" + $stringcommand + ")" + " -join ""`r`n"" -replace ""`r`n`r`n"", ""`r`n""")
        & ($command) 2>&1 | Tee-Object -Variable out_content
        [console]::OutputEncoding = $oldEncoding

    # Run the command and write the output to the window and to a variable (normal formatting)
    } else {
        & ($command) 2>&1 | Tee-Object -Variable out_content
    }

    # Manipulate output variable, write it to a file...
    # ...
    return
}

RunCommand {Sfc /verifyonly}