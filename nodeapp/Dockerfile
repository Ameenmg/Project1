FROM Node:14
WORKDIR /user/app
COPY package.json .
RUN npm install
COPY . . 
EXPOSE 8080
CMD [ "Node", "app.js" ]