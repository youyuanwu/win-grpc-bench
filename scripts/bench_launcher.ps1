param(
  [string] $Mode = "Debug",
  [int] $Loop = 1,
#  [string] $ExePath
  [string] $Scenarios = "2bytes.json"
)
$ErrorActionPreference = "Stop";

# set up log dir
$path = ".\log"   
If (!(test-path $path))
{
  New-Item $path -ItemType Directory
} else {
  Remove-Item -Recurse $path\*
}

Write-Host "Loop for $Loop rounds"

for (($i = 0); $i -lt $Loop; $i++)
{

Write-Host "---win_grpc bench---"

.\scripts\bench.ps1 -Mode $Mode -Flavour "win_grpc" -Scenarios $Scenarios | Tee-Object -FilePath .\log\win_grpc.log

Write-Host "---win_grpc bench end---"

Write-Host "---grpc_mt bench---"

.\scripts\bench.ps1 -Mode $Mode -Flavour "grpc_mt" -Scenarios $Scenarios | Tee-Object -FilePath .\log\grpc_mt.log

Write-Host "---grpc_mt bench end---"

Write-Host "extracting result for comparison"
.\scripts\extract_ratio.ps1 | Tee-Object -FilePath .\log\extract_ratio.log -Append

}

Write-Host "Final result"
Get-Content -Path .\log\extract_ratio.log | Write-Host

