# PowerShell Directory Analyzer

This PowerShell script is a utility tool designed to perform a detailed analysis of a specified directory and its immediate subdirectories. The analysis focuses on gathering statistics that include the name of each subdirectory, the number of folders within it, the number of files it contains, and the total size of the directory.

## Features

- Easy to use: Just set the directory to analyze and the output file path.
- Detailed output: Get the name, number of folders, number of files, and total size (in MB) of each subdirectory.
- Export to CSV: The output is written to a CSV file, making it easy to digest and manipulate the data.

## Usage

1. Modify the `$directoryToAnalyze` and `$outputFilePath` variables at the top of the script to set the directory you wish to analyze and the output file path for the CSV file, respectively.
2. Run the script in your PowerShell environment.

```powershell
# Define the directory to analyze and the output file path
$directoryToAnalyze = "C:\Path\To\Your\Directory"
$outputFilePath = "C:\Path\To\Your\File.csv"

Get-ChildItem -Path $directoryToAnalyze -Directory |
Select-Object FullName |
ForEach-Object -Process{
    New-Object -TypeName PSObject -Property @{
        Name=(Split-Path $_.FullName -Leaf); # Get just the directory name
        BlankColumn=""; # Blank column
        Num_of_Folders=(Get-ChildItem -Path $_.FullName -Directory -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object).Count;
        Num_of_Files=(Get-ChildItem -Path $_.FullName -File -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object).Count; # Number of files
        Size= "{0:F0} MB" -f ((Get-ChildItem -path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum/1mb) # Add "MB" to the size
    }
} |
Select-Object Name,BlankColumn,Num_of_Folders,Num_of_Files,Size |
Export-Csv -Path $outputFilePath -NoTypeInformation
```
## Dependencies

- PowerShell 3.0 or later.

## Limitations

- The script currently only analyzes the immediate subdirectories of the specified directory, not their subdirectories.
- The total size of the directory is formatted in MB.
