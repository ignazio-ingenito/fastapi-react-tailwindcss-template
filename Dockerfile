FROM python:3.7.9-slim

ENV ENV debug
ENV LC_ALL C.UTF-8
ENV TERM xterm-256color
ENV PYTHONUNBUFFERED True

EXPOSE 8080

# copy the files
COPY ./web /web
COPY requirements.txt /web/requirements.txt

# update the image
RUN apt-get update && \
    apt-get upgrade -y


# install libsndfile1
RUN apt-get install libsndfile1 -y

# install node - Node.js LTS (v14.x)
# from https://github.com/nodesource/distributions 
RUN apt-get install curl -y
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# install the React app
WORKDIR /web/js
RUN npm install && \
    npm audit fix && \
    npm run build

# the the working dir
WORKDIR /web

# install the python dependencies
RUN pip install -r /web/requirements.txt

# setup gsutil
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y      

# PRODUCTION
CMD exec gunicorn --bind 0.0.0.0:8080 --workers 1 --worker-class uvicorn.workers.UvicornWorker --timeout 180  --threads 8 app:app

# - DEVELOPMENT
#   - gunicorn
#       CMD exec gunicorn --reload --bind 0.0.0.0:8080 --workers 1 --worker-class uvicorn.workers.UvicornWorker  --threads 8 app:app
#   - uvicorn
#       CMD exec uvicorn --reload --host 0.0.0.0 --port 8080 app:app

# - COMANNDS
#   - build
#       docker build -t tagger:latest .
#   - run
#       docker run -p 8080:8080 tagger:latest
#       docker run -p 8080:8080 -v `pwd`/web:/web tagger:latest
#   - sh into if running
#       docker exec -it tagger:latest /bin/bash
#   - sh into if not running
#       docker run -it -p 8080:8080 tagger:latest /bin/bash


# - DOCKER
#   - build image
#       docker build -t tagger:latest .
# - google cloud 
#   - to deploy
#       gcloud builds submit --tag eu.gcr.io/bling-movetocloud/miner:latest
#       gcloud beta run deploy --image eu.gcr.io/bling-movetocloud/miner:latest --platform managed --region europe-west1 
