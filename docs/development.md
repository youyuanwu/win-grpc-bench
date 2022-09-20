* check http cert binding:
```ps1
netsh http show sslcert

netsh http show sslcert hostnameport=localhost:12356

netsh http delete sslcert ipport=0.0.0.0:12356

netsh http delete sslcert hostnameport=localhost:12356

netsh http add sslcert hostnameport=localhost:12356 appid='{4DBFB575-E1EF-4239-9A1D-E94CF84DC22D}' certhash=F5F37DB9023210DAE10D1E10247B7BA31ADD26FF certstorename=MY
```

Add the test cert.
```
netsh http add sslcert hostnameport=localhost:12356 appid='{4DBFB575-E1EF-4239-9A1D-E94CF84DC22D}' certhash=34E727880B9706A00C2B1BB290E8605B7FA09511 certstorename=MY
```

* generate key:
```ps1
New-SelfSignedCertificate -Type Custom -Subject "CN=win_grpc_test" `
    -KeyExportPolicy NonExportable -KeyUsage DigitalSignature -KeyAlgorithm RSA -KeyLength 2048 -CertStoreLocation "Cert:\LocalMachine\My" `
    -Provider "Microsoft Platform Crypto Provider"

# get thumbprint
$thumbprint = Get-ChildItem Cert:\LocalMachine\My | Where-Object -Property Subject -eq CN=win_grpc_test | select -ExpandProperty Thumbprint

netsh http add sslcert hostnameport=localhost:12356 appid='{4DBFB575-E1EF-4239-9A1D-E94CF84DC22D}' certhash=$thumbprint certstorename=MY

# remove key
Remove-Item Cert:\LocalMachine\My\34E727880B9706A00C2B1BB290E8605B7FA0951
```

* find process
```ps1
Get-Process -Name win_grpc_main
Stop-Process -Id 10152
```