ARG BASE_IMAGE=nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04
ARG TF_VERSION=1.13.1
ARG TORCH_VERSION

FROM $BASE_IMAGE
# FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

LABEL io.openshift.s2i.scripts-url="image:///s2i/bin"

RUN apt-get update -y

# RUN apt-get install -y python
# RUN apt-get install -y python3

RUN apt-get install -y python-pip python-dev build-essential
RUN apt-get install -y python3-pip python3-dev

RUN mkdir microservice
WORKDIR /microservice

COPY ./s2i/bin/ /s2i/bin

# keep install of seldon-core after the COPY to force re-build of layer
RUN pip3 install tensorflow-gpu=="$TF_VERSION"
RUN pip3 install seldon-core
RUN if [[ -n "$TORCH_VERSION" ]] ; then pip3 install torch==$TORCH_VERSION ; else echo "No pytorch installed" ; fi


EXPOSE 5000
