# # **************************************************
# # Your changes for task 3 go in this file (and ./docker-compose.yml).
# #
# # See below.
# #
# # You must have completed task 1 (not 2) before starting on this.
# # **************************************************
FROM node:lts
WORKDIR /app
COPY index.js .
COPY package*.json .
RUN npm install
EXPOSE 8000

CMD ["node", "index.js"]