FROM node:boron
LABEL contributor.1="@nicxvan nlightened Development LLC <nic@nlighteneddevelopment.com>"


### Build project
USER root
#COPY ../../../package.json /var/www/package.json
#WORKDIR /var/www/nodeapp
#RUN npm install --prefix /var/www/node_modules

COPY ./entrypoint.bash /bin/entrypoint.bash

RUN chmod +x /bin/entrypoint.bash

ENTRYPOINT ["/bin/entrypoint.bash"]
