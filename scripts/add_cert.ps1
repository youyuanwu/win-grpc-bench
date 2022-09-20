$ErrorActionPreference = "Stop";

# This script adds the same pem cert for grpc into windows cert store.

# Thumbprint is 34E727880B9706A00C2B1BB290E8605B7FA09511

# This does not import private key
# Import-Certificate -FilePath "win_grpc\test.cert" -CertStoreLocation "Cert:\LocalMachine\My"

# use this to convert pem to pfx. Private key will be automatically picked up
# first pwd is for pem, second is for pfx
certutil -f -p "dummy,hello" -mergepfx .\win_grpc\test.pem .\win_grpc\test.pfx

# The pfx has password hello.
$SecureStr = ConvertTo-SecureString -String "hello" -AsPlainText -Force
Import-PfxCertificate -FilePath "win_grpc\test.pfx" -CertStoreLocation "Cert:\LocalMachine\My" -Password $SecureStr

# This will create 2 entries for now:

# PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\My

# Thumbprint                                Subject
# ----------                                -------
# 34E727880B9706A00C2B1BB290E8605B7FA09511  CN=localhost, O=WinTLS, L=Copenhagen, C=DK
$thumbprint = "34E727880B9706A00C2B1BB290E8605B7FA09511"
netsh http add sslcert hostnameport=localhost:12356 appid='{4DBFB575-E1EF-4239-9A1D-E94CF84DC22D}' certhash=$thumbprint certstorename=MY


