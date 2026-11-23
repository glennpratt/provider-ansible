FROM python:3.10.13-alpine3.17@sha256:0d288bffed7192d42175235891105f5ac6171d503aea5270c10529fcd31518e5 AS build-base
RUN apk --no-cache add gcc musl-dev libffi-dev
COPY requirements.txt /requirements.txt
RUN python -m pip wheel --require-hashes --no-deps -r /requirements.txt --wheel-dir=/wheels

FROM python:3.10.13-alpine3.17@sha256:0d288bffed7192d42175235891105f5ac6171d503aea5270c10529fcd31518e5
RUN apk --no-cache add ca-certificates bash openssh-client git dumb-init
COPY --from=build-base /wheels/* /wheels/
# Install exactly the wheels built from requirements.txt.
RUN python -m pip install --no-index --no-deps /wheels/*.whl && \
    rm -r /wheels

ARG TARGETOS
ARG TARGETARCH

ADD bin/$TARGETOS\_$TARGETARCH/provider /usr/local/bin/crossplane-ansible-provider

# As of Crossplane v1.3.0 provider controllers run as UID 2000.
# https://github.com/crossplane/crossplane/blob/v1.3.0/internal/controller/pkg/revision/deployment.go#L32
RUN adduser --disabled-password --uid 2000 ansible
RUN passwd -d ansible

RUN mkdir /ansibleDir /.ansible
RUN chown ansible /ansibleDir /.ansible


EXPOSE 8080
USER ansible
ENTRYPOINT ["/usr/bin/dumb-init", "crossplane-ansible-provider"]
