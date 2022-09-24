# This script launches one test for one exeutable

param(
  [string] $Mode = "Debug",
  [string] $Flavour = "win_grpc",
  [string] $ExePath,
  [string] $Port = 12356,
  [int] $Connection = 50,
  [int] $Concurrency = 1000,
  [string] $Scenarios = "2bytes.json"
)

$ErrorActionPreference = "Stop";

$proto_file_path = "build\helloworld_proto\helloworld.proto"
$hgz_path = "build\_deps\hgz-src\ghz.exe"
$payload = "scenarios\$Scenarios"

if($Flavour -eq "grpc_mt"){
  $Port = 50051;
}
$_hostport = "localhost:$Port"

if([string]::IsNullOrEmpty($ExePath))
{
  $ExePath = "build\$Flavour\$Mode\${Flavour}_main.exe"
  Write-Host "Start $Flavour Using [$Mode] build. hostport: [$_hostport] Scenario [$Scenarios]"
}
Write-Host "ExePath: $ExePath"

$wingrpc_process = Start-Process $ExePath -PassThru -NoNewWindow
Start-Sleep -Seconds 5

Write-Host "warming up"
# warm up
& $hgz_path `
    		--proto="$proto_file_path" `
    		--call=helloworld.Greeter.SayHello `
        --skipTLS `
            --concurrency=$Concurrency `
            --connections=$Connection `
            --rps=0 `
            --duration 5s `
            --data-file "$payload" `
            $_hostport | Out-Null

# remove rpc error strings noise output
Write-Host "start bench"
& $hgz_path `
    		--proto="$proto_file_path" `
    		--call=helloworld.Greeter.SayHello `
        --skipTLS `
            --concurrency=$Concurrency `
            --connections=$Connection `
            --rps=0 `
            --duration 20s `
            --data-file "$payload" `
            $_hostport | Select-String -Pattern "rpc error" -NotMatch | Select-Object -ExpandProperty Line

Write-Host "End bench"

# there is no graceful kill yet.
Stop-Process $wingrpc_process
Start-Sleep -Seconds 2