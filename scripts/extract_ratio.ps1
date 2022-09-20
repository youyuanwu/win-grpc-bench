
$win_path = ".\log\win_grpc.log"
$mt_path = ".\log\grpc_mt.log"

If (!(test-path $win_path) -or !(Test-Path $mt_path))
{
    Write-Error "log not found"
    Exit 1
}

$winline = Get-Content $win_path | Select-String -Pattern Requests/sec: | select-object -First 1
$mtline = Get-Content $mt_path | Select-String -Pattern Requests/sec: | select-object -First 1

# split by tab
$winnum = $winline.Line.Split("`t")[1]
$mtnum = $mtline.Line.Split("`t")[1]
Write-Output "wingrpc: $winnum req/s"
Write-Output  "grpcmt:  $mtnum req/s"
$ratio = $winnum/$mtnum
Write-Output  "ratio: $ratio"