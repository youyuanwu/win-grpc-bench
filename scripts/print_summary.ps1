
$path2 = ".\log\endresult"   
If (!(test-path $path2))
{
  Write-Host "log dir not found : $path2"
}


Get-ChildItem $path2 | Select-Object -Property Name | ForEach-Object -Process {

  $log_case_name = $_ | Select-Object -ExpandProperty Name
  $log_case_file = "$path2\$log_case_name"

  # wingrpc: 7141.43
  # grpcmt:  9953.71
  # ratio: 0.717464141511055

  $wingrpc_reqs = 0
  $grpcmt_reqs = 0
  $ratio = 0
  $i = 0 #cound how many lines
  Get-Content $log_case_file | Select-String -Pattern wingrpc | ForEach-Object -Process{
    $wingrpc_reqs += ($_.Line -Split ": ")[1]
    $i++
  }
  Get-Content $log_case_file | Select-String -Pattern grpcmt | ForEach-Object -Process{
    $grpcmt_reqs += ($_.Line -Split ": ")[1]
  }
  Get-Content $log_case_file | Select-String -Pattern ratio | ForEach-Object -Process{
    $ratio += ($_.Line -Split ": ")[1]
  }

  if($i -ge 1){
    $wingrpc_reqs = $wingrpc_reqs / $i
    $grpcmt_reqs = $grpcmt_reqs / $i
    $ratio = $ratio / $i
  }
  Write-Host "---Case $log_case_name average [$i] summary ---"
  Write-Host "wingrpc req/s: $wingrpc_reqs"
  Write-Host "grpcmt  req/s: $grpcmt_reqs"
  Write-Host "ratio        : $ratio"
}