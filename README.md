# Enabling Email over NYM mixnet

This project allows the transmission of emails over a SOCKS5 proxy and NYM mixnet. It supports both SMTP and IMAP, and has been tailored to work seamlessly with the **Thunderbird** email client. Other solutions such as a webapp with **Protonmail** equivalent e2ee encryption will hopefully come later with enough resources. 

## Features

- Send and receive emails using `nym-socks5-client` or **Nym-Connect** with **Thunderbird** or other clients that let you to set up a *socks5* proxy in 
- Full compatibility with **Thunderbird** email client.
- Connecting to the existing Service Provider from  [Dial0ut](https://dialout.net).

## How to 
To connect to **Dial0ut** email-service-provider, you will have to use the `nym-socks5-client` until **Nym** allows **email-service-providers** on **Nym-Connect**.
It is easy if you follow these steps:

1. Open your Thunderbird client.
2. Navigate to "General > Network" like displayed on the picture:
![2023-06-29 20 18 54](https://github.com/dial0ut/nymstr-email/assets/33793809/6ffbc1ee-aec9-4cd6-9fff-90166987f7c9)


3. Hit the "Manual proxy" button and set it to the address of the nym-socks5-client (at the current version runs at 127.0.0.1 on port 1080) (Substitute with the actual server name or IP).
![2023-06-29 20 19 01](https://github.com/dial0ut/nymstr-email/assets/33793809/82507f0d-01bc-49c1-b7de-b9327122a658)


4. Download or build (with Apple M1 and later this step is needed) your `nym-socks5-client` and connect to email-service-provider of **Dial0ut** as following:

#### Note:
**NYM** does not release binaries for **Apple sillicon (M1, M2 chips)** so you have to compile the client yourself. Follwo the official Nym documentation https://nymtech.net/docs/binaries/building-nym.html

- Download from web without using terminal from official (url)[https://nymtech.net/nym] [Nym releases page](https://github.com/nymtech/nym/releases(
- ####  Assuming you are on Linux or MacOS (Intel)
  - simply use `curl` or `wget`  here is a command to get version v1.1.22 for x86 cpu architechture (Intel or AMD 64-bit)

   #### using `curl`:
```
curl -o nym-socks5-client -sSL https://github.com/nymtech/nym/releases/download/nym-binaries-v1.1.22/nym-socks5-client
  ``` 
  #### using `wget`:
```
wget https://github.com/nymtech/nym/releases/download/nym-binaries-v1.1.22/nym-socks5-client 
```

  - Make the binaries executable `chmod 755 nym-socks5-client`
  - for convenience, move the binary to for example `/usrl/local/bin/` so they are in your PATH (check with  `echo $PATH`)
4. Make sure to `init` your  `nym-socks5-client` first.

```
nym-socks5-clinet init --id email --providerl 4V8euNmD7oBtvQ9RaVGBLK9s2jVDLT7vxkg4iHWfFqza.HGMiWr7zPFohiyFGLzP82jDnVXodLvpjvjKyVvNJ33Uv@Bkq5KLDMRiL9vAaHqwCN7LJ16ecvhU7WsJoeWqk6PYjG
```
- this will connect to **Dial0ut email-service-provider** and you will be able to route most of the top20 emails over **Nym mixnet**.
- for **Protonmail**, if you want to use Protonmail in any desktop client, you have to download their *Protonbridge, which is in fact SMTP/IMAP server sitting on your local machine and relaying all email traffic to Protonmail servers. This will be probably causing issues and is currently not tested because the overall solution would be a bit over-engineered.*
- However; we might add this functionality to Protonbridge if there is large enough demand for it. The protonbridge-cli itself is very complex, large codebase and frontend app is written in Qt when simple widget in Go or even React would be enough ... therefore we have decided not to pursue this solution. 
## Running Your Own Instance of the Service Provider (SP)

#### *Security note/advisor*y
If you want to use extra security layer like we do, create a user `nym` - `useradd -s /sbin/nologin -m nym` and then switch to that user:
`su -s /bin/bash nym` or `sudo -u nym bash` and exit after you `init` the client. 
This provides a tiny bit of extra security and it is certainly better than to run your service-provider as root user! 

Getting your own service provider is easy, follow the same steps as above for nym-socks5-client and `init` it like this:
```
nym-network-requester init --id dialout_sp1 --gateway Bkq5KLDMRiL9vAaHqwCN7LJ16ecvhU7WsJoeWqk6PYjG  --enabled-credentials-mode false
```
If you do not want to use Dial0ut's gateway, just change it to blank or to any other gateway of your choice.

2. run the email-service-provider 
For better results we recommend to run it as an open-proxy and deal with incoming and outgoing traffic yourself rather than relying on `allowed.list` 
```
nohup nym-network-requester run --id dialout_sp1 --open-proxy &
```

If you want you can make a daemon out of it like this: 
1. Create a service file for systemd:
- assuming you have a nym user that is `/usr/sbin/nologin` and binaries are in `/usr/local/bin/` directory and your `--id` chosen for `init` was `email`; then: 
```
 [Unit]
 Description=NYM Client

 [Service]
 User=nym
 ExecStart=/usr/local/bin/nym-service-provider run --id email
 LimitNOFILE=65535
 Restart=on-failure

 [Install]
 WantedBy=multi-user.target
 ```


For more detailed instructions, please refer to the documentation available at [nymtech docs](https://nymtech.net/docs).
MIT License - read the terms
