# MarkDownGenerator
Will generate a MarkDown file containing the given script's documentation, based on [Comment Based Help](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.3).

[MDGenerator.md](MDGenerator.md) was generated using the script.

You can pipe scripts into the function:
```ps
Get-ChildItem -Filter *.ps1 | Write-MDDocumentation
```