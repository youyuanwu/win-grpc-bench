# this script launches all test cases one by one

param(
  [string] $Mode = "Debug",
  [int] $Loop = 1
)

$ErrorActionPreference = "Stop";

$path = ".\log"   
If (!(test-path $path))
{
  New-Item $path -ItemType Directory
} else {
  Remove-Item -Recurse $path\*
}

Get-ChildItem .\scenarios | Select-Object -Property Name | ForEach-Object -Process {
  # for each scenario run the bench launcher
  $scenarios_str = $_ | Select-Object -ExpandProperty Name
  Write-Host "running scenario $scenarios_str"
  .\scripts\bench_launcher.ps1 -Scenarios $scenarios_str -Mode $Mode -Loop $Loop

  # Get-Content -Path .\log\extract_ratio.log | Out-File -FilePath .\log\endresult\$scenarios_str.log
}