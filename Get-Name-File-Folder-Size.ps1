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
