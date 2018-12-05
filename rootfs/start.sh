#!/bin/bash

##
## Create the SSH directory and give it the right permissions
##
mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ ! -z "$SSH_PRIVATE_KEY" ]; then

    ##
    ## Run ssh-agent (inside the build environment)
    ##
    eval $(ssh-agent -s -a /builds/ssh_agent)

    ##
    ## Add the SSH key stored in SSH_PRIVATE_KEY variable to the agent store
    ## We're using tr to fix line endings which makes ed25519 keys work
    ## without extra base64 encoding.
    ## https://gitlab.com/gitlab-examples/ssh-private-key/issues/1#note_48526556
    ##
    ssh-add <(echo "$SSH_PRIVATE_KEY")
    unset SSH_PRIVATE_KEY
fi

if [ ! -z "$SSH_KNOWN_HOSTS" ]; then
    echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
    chmod 644 ~/.ssh/known_hosts
else
    ##
    ## You can optionally disable host key checking. Be aware that by adding that
    ## you are susceptible to man-in-the-middle attacks.
    ## WARNING: Use this only with the Docker executor, if you use it with shell
    ## you will overwrite your user's SSH config.
    ##
    [[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
fi

exec /bin/bash
