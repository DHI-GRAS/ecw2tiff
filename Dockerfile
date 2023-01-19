FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    g++ build-essential autoconf automake m4 libtool gcc make unzip wget swig ant \
    python3 python3-pip python3-dev

RUN apt install -y libpq-dev gdal-bin libgdal-dev

# Install libecwj2 (ECW driver)
RUN wget https://github.com/bogind/libecwj2-3.3/raw/master/libecwj2-3.3-2006-09-06.zip \
    && wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3366/libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch \
    && wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3162/libecwj2-3.3-msvc90-fixes.patch \
    && unzip libecwj2-3.3-2006-09-06.zip \
    && patch -p0< libecwj2-3.3-msvc90-fixes.patch \
    && patch -p0< libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch \
    && cd libecwj2-3.3 \
    && ./configure \
    && make \
    && make install \
    && cd ..

# Install gdal 2.2.2
RUN wget http://download.osgeo.org/gdal/2.2.2/gdal-2.2.2.tar.gz \
    && tar -xvf gdal-2.2.2.tar.gz \
    && cd gdal-2.2.2 \
    && ./configure --with-ecw=/usr/local --with-python \
    && make \
    && make install

RUN echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> ~/.profile \
    && echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> ~/.bashrc \
    && ldconfig

RUN echo 'GDAL_DATA="/usr/local/share/gdal"' > /etc/environment \
    && echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"' >> /etc/environment

RUN gdalinfo --version && gdalinfo --formats | grep ECW

CMD ["/bin/bash"]