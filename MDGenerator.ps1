[cmdletbinding()]
param(
    [ValidateScript({
        if( -Not ($_ | Test-Path -Filter *.ps1) ){
            throw 'File does not exist'
        }
        return $true
    })]
    [String]$Script,    
    [ValidateScript({
        if( -Not ($_ | Test-Path -Filter *.md) ){
            throw 'File does not exist'
        }
        return $true
    })]
    [String]$Append
)

Write-Verbose "Recovering help description for the script."
$HelpContent = Get-Help $Script -Full
$ScriptName = [String]$Script.Split('\')[-1]
$FileName = $HelpContent.Name.Replace('.ps1','.md')
Write-Verbose "Creating file: $FileName"

"# $ScriptName" | Out-File -FilePath $FileName

if($HelpContent.Synopsis){
    Write-Verbose "Adding Synopsis..."
    "",'## Synopsis',$HelpContent.Synopsis | ForEach-Object{Add-Content -Path $FileName -Value $_}
}

Write-Verbose "Adding Syntax..."
# $Syntax = ($HelpContent.syntax | Out-String).Trim().Split('\') | Where-Object{$_ -match $FileName}
$Syntax = (($HelpContent.syntax | Out-String) -Replace '[A-Z]?:?\\.+\\',';').Split(';').Trim()
"",'## Syntax'| Add-Content -Path $FileName
foreach($CodeBlock in $Syntax){
    if($CodeBlock -eq ''){
        Continue
    }
    '```',"$CodeBlock",'```'| Add-Content -Path $FileName
}

if($HelpContent.description.Text){
    Write-Verbose "Adding Description..."
    "",'## Description',$HelpContent.description.Text.Trim() | Add-Content -Path $FileName
}

if($HelpContent.examples){
    Write-Verbose "Adding Examples..."
    "",'## Examples' | Add-Content -Path $FileName
    $Examples = $HelpContent.examples.example
    $Count = 1
    foreach($Example in $Examples){
        "","### Example $Count",'```ps',$Example.code,'```' | Add-Content -Path $FileName
    }
}

if($HelpContent.parameters){
    Write-Verbose "Adding Parameters..."
    "",'## Parameters' | Add-Content -Path $FileName
    $Parameters = $HelpContent.parameters.parameter
    foreach($Parameter in $Parameters){
        "","### -$($Parameter.Name)",$Parameter.Description.Text,'```',"Type: $($Parameter.type.Name)",'Parameter Sets: (All)',"","Required: $($Parameter.required)","Position: $($Parameter.Position)","Default value: $(if($Parameter.defaultValue){$Parameter.defaultValue}else{"None"})","Accept pipeline: $($Parameter.pipelineInput)","Accept wildcard characters: $($Parameter.globbing)",'```' | Add-Content -Path $FileName
    }
}

if($HelpContent.inputType){
    Write-Verbose "Adding InputType..."
    "",'## Inputs',$HelpContent.inputTypes.inputType.type.Name | Add-Content -Path $FileName
}

if($HelpContent.returnValue){
    Write-Verbose "Adding Returnvalues..."
    "",'## Outputs',$HelpContent.returnValues.returnValue.type.name | Add-Content -Path $FileName
}

if($HelpContent.relatedLinks){
    Write-Verbose "Adding Links..."
    "",'## Related Links' | Add-Content -Path $FileName
    $Links = $HelpContent.relatedLinks.navigationLink.linkText
    foreach($Link in $Links){
        try{
            $Url = (Get-Help $Link -ErrorAction Stop).relatedLinks.navigationLink.uri | Where-Object{$_ -ne $null}
            "* [$Link]($Url)" | Add-Content -Path $FileName
        }catch{
            continue
        }
    }
}

if(-not $Append){
    Write-Verbose "Done generating file: $FileName"
}else{
    $MD = Get-Content -Path $FileName
    "" | Add-Content -Path $Append
    $MD | ForEach-Object{$_.Replace('# ','## ') | Add-Content -Path $Append}
    Write-Verbose "Content added to: $Append"
}

<#
    .SYNOPSIS
    Will generate a documentation file based on the given script.

    .DESCRIPTION
    Will generate a markdown file based on the content of your scripts comments in the script's current directory.

    .PARAMETER Script
    Path to the script for which you want to generate the file.

    .PARAMETER Append
    Existing MD file you want to append the generated report to.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    MDGenerator.ps1 -Script .\Test.ps1

    .LINK
    Get-Help

    .LINK
    Add-Content
#>