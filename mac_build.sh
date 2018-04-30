#!/usr/bin/env bash

# remove existing directories and create new r_tmp
rm -rf bin/R
mkdir -p bin/R
cd bin/R

# download R source and extract it
wget https://cloud.r-project.org/src/base/R-3/R-3.4.3.tar.gz
tar xzvf R-3.4.3.tar.gz
cd R-3.4.3

# configure and build
mkdir localinstall
./configure --prefix=`pwd`/localinstall \
	--without-tcltk \
	--without-cairo \
	--without-aqua \
	--enable-R-shlib \
	--disable-R-framework
Make

# remove unused / unneeded files
rm -rf m4 po src tests tools configure libtool INSTALL Makeconf Makefile stamp-java \
	SVN-REVISION VERSION VERSION-NICK libconftest.dSYM Makefrag.m config.site config.status \
	configure.ac Makeconf.in Makefile.fw Makefile.in Makefrag.cc_lo Makefrag.cc Makefrag.cxx

# # install R packages
./bin/R -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest', 'jug', 'ncdf4', 'REddyProc', 'phenopix', 'bigleaf'), repos='http://cran.us.r-project.org')"

rm .rsource
touch .rsource
echo "export RSTUDIO_WHICH_R=/Users/adammcquistan/Code/R/RTovi/RTovi/bin/R/R-3.4.3/bin/R" > .rsource
echo "# to open RStudio using this R version: open -na Rstudio after source .rsource" >> .rsource

# ./bin/R -e "devtools::install_github('IRkernel/IRkernel')"

# # replace absolute path in R bin with ${ALEX_R_PATH} variable
# sed -i bak -e "s|`pwd`|\$\{ALEX_R_PATH\}|g" bin/R

# cd ../..

# # copy dylib files necessary for portability
# cp /usr/local/opt/pcre/lib/libpcre.1.dylib lib/
# cp /usr/local/opt/gcc/lib/gcc/7/libgfortran.4.dylib lib/
# cp /usr/local/opt/gcc/lib/gcc/7/libquadmath.0.dylib lib/
# cp /usr/local/opt/xz/lib/liblzma.5.dylib lib/
# cp /usr/local/lib/gcc/7/libgcc_s.1.dylib lib/
# cp /usr/local/opt/llvm/lib/libc++.1.dylib lib/
# cp /usr/local/lib/libjpeg.9.dylib lib/
# cp /usr/local/lib/libnetcdf.13.dylib lib/
# cp /usr/local/lib/libhdf5_hl.100.dylib lib/
# cp /usr/local/lib/libhdf5.101.dylib lib/
# cp /usr/local/lib/libsz.2.dylib lib/

# # copy and remove r_tmp
# cp -r r_tmp/R-3.4.3 alex_notebook/R/
# rm -rf r_tmp