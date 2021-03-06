FROM laradock/workspace:1.3
LABEL contributor.1="@nicxvan nlightened Development LLC <nic@nlighteneddevelopment.com>" \
      contributor.2="@aloyr HID Global" \
      contributor.4="@bariman HID Global" \
      contributor.4="@thepolyglot HID Global" \
      contributor.5="@chrisoconnor001 Hearts of Oak, LLC"

#
#--------------------------------------------------------------------------
# Mandatory Software's Installation
#--------------------------------------------------------------------------
#
# Mandatory Software's such as ("php7.0-cli", "git", "vim", ....) are
# installed on the base image 'laradock/workspace' image. If you want
# to add more Software's or remove existing one, you need to edit the
# base image (https://github.com/LaraDock/workspace).
#

#
#--------------------------------------------------------------------------
# Optional Software's Installation
#--------------------------------------------------------------------------
#
# Optional Software's will only be installed if you set them to `true`
# in the `docker-compose.yml` before the build.
# Example:
#   - INSTALL_NODE=false
#   - ...
#

#####################################
# Non-Root User:
#####################################

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g 1000 nodeappdock && useradd -u 1000 -g nodeappdock -m nodeappdock

#####################################
# Set Timezone
#####################################

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#####################################
# ssh:
#####################################
ARG INSTALL_WORKSPACE_SSH=false
ENV INSTALL_WORKSPACE_SSH ${INSTALL_WORKSPACE_SSH}

ADD ./id_rsa_insecure.pub /tmp/id_rsa.pub

USER root

RUN if [ ${INSTALL_WORKSPACE_SSH} = true ]; then \
    rm -f /etc/service/sshd/down && \
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /root/.ssh/authorized_keys \
;fi

#####################################
# User Aliases
#####################################

USER nodeappdock
COPY ./aliases.sh /home/nodeappdock/aliases.sh
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/nodeappdock/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc

USER root
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/nodeappdock/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc

#####################################
# Node / NVM:
#####################################

USER nodeappdock

# Check if NVM needs to be installed
ARG NODE_VERSION=stable
ENV NODE_VERSION ${NODE_VERSION}
ARG INSTALL_NODE=true
ENV INSTALL_NODE ${INSTALL_NODE}
ENV NVM_DIR /home/nodeappdock/.nvm
RUN if [ ${INSTALL_NODE} = true ]; then \
    # Install nvm (A Node Version Manager)
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash && \
        . $NVM_DIR/nvm.sh && \
        nvm install ${NODE_VERSION} && \
        nvm use ${NODE_VERSION} && \
        nvm alias ${NODE_VERSION} && \
        npm install -g gulp \
;fi

# Wouldn't execute when added to the RUN statement in the above block
# Source NVM when loading bash since ~/.profile isn't loaded on non-login shell
RUN if [ ${INSTALL_NODE} = true ]; then \
    echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
;fi

# Add NVM binaries to root's .bashrc
USER root

RUN if [ ${INSTALL_NODE} = true ]; then \
    echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="/home/nodeappdock/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
;fi

#####################################
# YARN:
#####################################

USER nodeappdock

ARG INSTALL_YARN=false
ENV INSTALL_YARN ${INSTALL_YARN}
ARG YARN_VERSION=latest
ENV YARN_VERSION ${YARN_VERSION}

RUN if [ ${INSTALL_YARN} = true ]; then \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
        if [ ${YARN_VERSION} = "latest" ]; then \
            curl -o- -L https://yarnpkg.com/install.sh | bash; \
        else \
            curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version ${YARN_VERSION}; \
        fi && \
        echo "" >> ~/.bashrc && \
        echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bashrc \
    ;fi

    # Add YARN binaries to root's .bashrc
    USER root

    RUN if [ ${INSTALL_YARN} = true ]; then \
        echo "" >> ~/.bashrc && \
        echo 'export YARN_DIR="/home/nodeappdock/.yarn"' >> ~/.bashrc && \
        echo 'export PATH="$YARN_DIR/bin:$PATH"' >> ~/.bashrc \
    ;fi

#####################################
# test structure:
#####################################
ARG DEFAULT_TEST_CONFIG=false

RUN mkdir -p /var/www/tests
COPY ./tests /var/www/tests

RUN if [ ${DEFAULT_TEST_CONFIG} = true ]; then \
#Use Default Config
    mkdir /var/www/tests/config && \
    cp -a /var/www/tests/sample_config/. /var/www/tests/config \
;fi

COPY ./entrypoint.bash /bin/entrypoint.bash

RUN chmod +x /bin/entrypoint.bash

ENTRYPOINT ["/bin/entrypoint.bash"]
