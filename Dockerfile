FROM debian

# Install depndencies
RUN apt-get update && apt-get install -y curl bzip2 libsdl1.2debian libsdl-image1.2 libsdl-ttf2.0-0 libgtk2.0-0 libopenal1 libsndfile1 libncursesw5 vim libglu1-mesa unzip rsync

# Install Dwarf Fortress
RUN curl http://www.bay12games.com/dwarves/df_47_04_linux.tar.bz2 -o /tmp/df.tar.bz2 && \
    mkdir /DF && \
    tar xvjf /tmp/df.tar.bz2 -C /DF && \
    mv /DF/df_linux/* /DF && rmdir /DF/df_linux && \
    rm /DF/libs/libstdc++.so.6

# Copy custom config
COPY init.txt /DF/data/init/init.txt

# Install dfhack
RUN curl -L https://github.com/DFHack/dfhack/releases/download/0.47.04-r1/dfhack-0.47.04-r1-Linux-64bit-gcc-4.8.tar.bz2 -o /tmp/dfhack.tar.bz2 && \
    tar xvjf /tmp/dfhack.tar.bz2 -C /DF

# Apply a hack to the dfhack script to disable disabling randomizing the virtual address space
RUN sed -i 's/setarch "$setarch_arch" -R/setarch $setarch_arch/g' /DF/dfhack

RUN curl -L https://github.com/white-rabbit-dfplex/dfplex/releases/download/v0.2.1-dfplex/dfplex-v0.2.1-Linux64.zip -o /tmp/dfplex.zip && \
    unzip /tmp/dfplex.zip -d /tmp/dfplex && \
    rsync -avz /tmp/dfplex/dfplex-v0.2.1-Linux64/ /DF/

WORKDIR /DF
CMD ["/DF/dfhack"]
