# MDGenerator.md

## Synopsis
Will generate a documentation file based on the given script.

## Syntax
```
MDGenerator.ps1 [[-Script] <FileInfo>] [<CommonParameters>]
```

## Description
Will generate a markdown file based on the content of your scripts comments.

## Examples

### Example 1
```ps
MDGenerator.ps1 -Script .\Test.ps1
```

## Parameters

### -Script
Path to the script for which you want to generate the file.
```
Type: FileInfo
Parameter Sets: (All)

Required: false
Position: 1
Default value: None
Accept pipeline: false
Accept wildcard characters: false
```

## Related Links
* [Get-Help](https://go.microsoft.com/fwlink/?LinkID=113316)
* [Add-Content](https://go.microsoft.com/fwlink/?LinkID=113278)
