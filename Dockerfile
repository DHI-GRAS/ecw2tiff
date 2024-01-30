FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    g++ build-essential autoconf automake m4 libtool gcc make unzip wget swig \
    python3 python3-pip python3-dev

# Run this to install gdal dependencies. Later gdal is being reinstalled from source
RUN apt install -y libpq-dev gdal-bin libgdal-dev

COPY ECWJP2SDKSetup_5.5.0.2268-Update4-Linux.zip ./ECWJP2SDKSetup_5.5.0.2268-Update4-Linux.zip

# Install the official ECW JP2 SDK (ECW 5.5 SDK)
RUN unzip ECWJP2SDKSetup_5.5.0.2268-Update4-Linux.zip \
    && chmod +x ECWJP2SDKSetup_5.5.0.2268.bin \
    && ./ECWJP2SDKSetup_5.5.0.2268.bin --accept-eula=YES --install-type=1  \
    && cp -r ~/hexagon/ERDAS-ECW_JPEG_2000_SDK-5.5.0/Desktop_Read-Only /usr/local/hexagon \
    && rm -r /usr/local/hexagon/lib/x64 \
    && mv /usr/local/hexagon/lib/cpp11abi/x64 /usr/local/hexagon/lib/x64 \
    && cp /usr/local/hexagon/lib/x64/release/libNCSEcw* /usr/local/lib \
    && ldconfig /usr/local/hexagon

# Install gdal 3.5.3
RUN wget http://download.osgeo.org/gdal/3.5.3/gdal-3.5.3.tar.gz \
    && tar -xvf gdal-3.5.3.tar.gz \
    && cd gdal-3.5.3 \
    && ./configure --with-ecw=/usr/local/hexagon --with-python \
    && make \
    && make install

RUN echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> ~/.profile \
    && echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> ~/.bashrc \
    && ldconfig

RUN echo 'GDAL_DATA="/usr/local/share/gdal"' > /etc/environment \
    && echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"' >> /etc/environment

RUN gdalinfo --version && gdalinfo --formats | grep ECW

CMD ["/bin/bash"]