FROM jenkins:alpine
LABEL contributor.1="@nicxvan nlightened Development LLC <nic@nlighteneddevelopment.com>" \
      contributor.2="@aloyr HID Global" \
      contributor.4="@bariman HID Global" \
      contributor.4="@thepolyglot HID Global" \
      contributor.5="@chrisoconnor001 Hearts of Oak, LLC"

RUN install-plugins.sh sonar ssh cloudbees-folder timestamper workflow-aggregator subversion ldap antisamy-markup-formatter ws-cleanup github-organization-folder ssh-slaves email-ext build-timeout ant pipeline-stage-view matrix-auth mailer credentials-binding gradle git pam-auth

COPY jenkins.install.UpgradeWizard.state /var/jenkins_home/jenkins.install.UpgradeWizard.state

COPY jenkins.install.InstallUtil.lastExecVersion /var/jenkins_home/jenkins.install.InstallUtil.lastExecVersion

COPY basic-security.groovy /var/jenkins_home/init.groovy.d/basic-security.groovy

RUN mkdir -p /var/jenkins_home/jobs/Update_Unit_Tests_SonarQube

COPY ./Update_Unit_Tests_SonarQube/config.xml /var/jenkins_home/jobs/Update_Unit_Tests_SonarQube/config.xml

ADD ./id_rsa_insecure /tmp/id_rsa

USER root

RUN rm -f /etc/service/sshd/down && \
    mkdir /root/.ssh && \
    cat /tmp/id_rsa >> /root/.ssh/id_rsa \
      && rm -f /tmp/id_rsa* \
      && chmod 400 /root/.ssh/id_rsa

RUN { \
  echo 'Host utility-container'; \
  echo '    StrictHostKeyChecking no'; \
} > /root/.ssh/config

COPY ./hudson.plugins.sonar.SonarGlobalConfiguration.xml /var/jenkins_home/hudson.plugins.sonar.SonarGlobalConfiguration.xml
COPY ./hudson.plugins.sonar.SonarRunnerInstallation.xml /var/jenkins_home/hudson.plugins.sonar.SonarRunnerInstallation.xml

COPY ./tokenReplace.bash /bin/tokenReplace.bash

RUN chmod +x /bin/tokenReplace.bash

ENTRYPOINT ["/bin/tokenReplace.bash"]