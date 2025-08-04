
kubectl -n argocd create secret tls argocd-tls-secret --key ssl/key.pem --cert ssl/cert.pem


Two ways to do it, but only worked for me so I'll put it first and the second for reference:

openssl pkcs12 -export -in cert.pem -inkey key.pem -out hostname.p12
openssl pkcs12 -in hostname.p12 -nodes -out hostname.pem
