FROM fedora:38
# Set a useful default locale
RUN echo "export LANG=en_US.UTF-8" > /opt/export_LANG.sh
RUN echo "export LANGUAGE=en_US.UTF-8" >> /opt/export_LANG.sh
RUN echo "export LC_ALL=en_US.UTF-8" >> /opt/export_LANG.sh
ENV BASH_ENV=/opt/export_LANG.sh \
    ENV=/opt/export_LANG.sh \
    PROMPT_COMMAND="source /opt/export_LANG.sh"

ARG user
ARG userid
ARG dockergroupid

RUN groupadd -r docker -g$dockergroupid && useradd -d "/home/$user" -u $userid -U -G docker -m -s /bin/bash $user

RUN dnf clean all && \
    dnf install \
    glibc-langpack-en \
    mozilla-fira-mono-fonts \
    fira-code-fonts \
    unzip \
    vim \
    firefox \
    wget \
    git \
    nodejs \
    npm \
    gtk2 \             
    libXScrnSaver \    
    libsecret \        
    libwayland-server \
    libxkbfile \ 
    fish \      
    mesa-libgbm -y &&\
    dnf clean all

RUN npm install npm@latest -g
RUN npm install npm-check-updates@latest -g

RUN mkdir /home/$user/vscodium
RUN mkdir /home/$user/data

COPY ./settings.json /home/$user/data/
COPY ./entrypoint.sh /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh

RUN touch /home/$user/.gitconfig

RUN chown $user:$user /home/$user -R

USER $user

CMD  /home/$user/entrypoint.sh