FROM node:boron
LABEL contributor.1="@nicxvan nlightened Development LLC <nic@nlighteneddevelopment.com>"


### Build project
WORKDIR /var/www/nodeapp

RUN npm install

COPY ./entrypoint.bash /bin/entrypoint.bash

RUN chmod +x /bin/entrypoint.bash

ENTRYPOINT ["/bin/entrypoint.bash"]
