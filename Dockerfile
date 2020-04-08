FROM node:alpine as builder 

# then this entire phase will be called 'builder'

WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . . 

# now we don't need that volume system because we aren't in a dev environment

RUN npm run build

# then by this point, all the built stuff will be in /app/build

# every 'FROM' means the previous phase is done

FROM nginx as runner

# required for beanstalk; this is the default port, typically not needed
EXPOSE 80

# the --from means we are copying from a previous phase
# then the destination folder is nginx default
COPY --from=builder /app/build /usr/share/nginx/html

# don't need to specify a command because the nginx start runs by default as part of nginx image
