$ErrorActionPreference = "Stop";

$proto_file_path = "build\helloworld_proto\helloworld.proto"
$hgz_path = "build\_deps\hgz-src\ghz.exe"
$payload = "scenarios\payload.json"

$wingrpc_process = Start-Process build\win_grpc\Debug\wingrpc-main.exe -PassThru
Start-Sleep -Seconds 5

Write-Host "Start bench"

& $hgz_path `
    		--proto="$proto_file_path" `
    		--call=helloworld.Greeter.SayHello `
        --skipTLS `
            --concurrency=2 `
            --connections=2 `
            --rps=0 `
            --duration 10s `
            --data-file "$payload" `
    		localhost:12356


Stop-Process $wingrpc_process