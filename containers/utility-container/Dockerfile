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