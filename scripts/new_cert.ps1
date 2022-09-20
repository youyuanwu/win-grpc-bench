# this should only be used in CI

$ErrorActionPreference = "Stop";

# create with default provider

New-SelfSignedCertificate -Type Custom -Subject "CN=win_grpc_test" `
    -KeyExportPolicy NonExportable -KeyUsage DigitalSignature -KeyAlgorithm RSA -KeyLength 2048 -CertStoreLocation "Cert:\LocalMachine\My"

# get thumbprint
$thumbprint = Get-ChildItem Cert:\LocalMachine\My | Where-Object -Property Subject -eq CN=win_grpc_test | Select-Object -ExpandProperty Thumbprint

netsh http add sslcert hostnameport=localhost:12356 appid='{4DBFB575-E1EF-4239-9A1D-E94CF84DC22D}' certhash=$thumbprint certstorename=MY

Write-Host "Successfully set ssl binding with thumbprint $thumbprint"