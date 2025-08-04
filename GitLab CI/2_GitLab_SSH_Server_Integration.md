### Setting up communication between GitLab Runner and Deployment Server with SSH

Run some commands inside of remote machine - Gitlab CI

### Prerequisite

1. GitLab account
2. Remote server (I’m using AWS’s Linux VM)
3. OpenSSH client & server installed on runner and deployment server.
    - Private key (~/.ssh/id_rsa)
    - Public key (~/.ssh/id_rsa.pub)
4. Store these keys in Gitlab CI Environment Variables
    - Store both private & public keys by giving them a name (SSH_PRIVATE_KEY/SSH_PUBLIC_KEY)

### Agenda

1. Create your Dockerfile
2. Build locally
3. Create a Gitlab file
4. Create a new GitLab project
5. Create and add SSH keys
6. Create and run GitLab CI/CD pipeline

1. Gitlab CI Environment Variables

Store both private & public key by giving them a name (SSH_PRIVATE_KEY/SSH_PUBLIC_KEY), you can store the keys at the group level and inherit it in your project by selecting from the Environment Scope dropdown.

2. Gitlab Runner Machine (SSH folder) 

Replace gitlab.com with url where you have hosted your Gitlab.

```sh
before_script:
  - eval $(ssh-agent -s)
  - mkdir -p ~/.ssh
  - chmod 700 ~/.ssh
  - echo -e "Host *\n\tStrictHostKeyChecking no\n" > ~/.ssh/config;
  - cat "$SSH_PRIVATE_KEY" | tr -d '\r' > ~/.ssh/id_rsa
  - cat "$SSH_PUBLIC_KEY" | tr -d '\r' > ~/.ssh/id_rsa.pub
  - chmod 600 ~/.ssh/id_rsa;
  - chmod 764 ~/.ssh/id_rsa.pub;
  - ssh-keyscan -H gitlab.com >> ~/.ssh/known_hosts
```

3. Create authorized_keys on the Server

On the server where you will be deploying your application, create a authorized_keys file inside ~/.ssh.

Then, Copy and paste the public key to the end of authorized_keysfile

```sh
~/.ssh/authorized_keys
```
