FROM --platform=linux/amd64 gcc:latest
# builds for arm in my mac... if you dont set the plataform
# Takes a while to build ... feel free to go get a coffee

RUN gcc --version
RUN mkdir -p /pwiz_build
WORKDIR /pwiz_build
RUN git clone --depth 1 https://github.com/ProteoWizard/pwiz.git
WORKDIR /pwiz_build/pwiz
RUN bash quickbuild.sh -j4 --abbreviate-paths --hash optimization=space address-model=64 pwiz_tools/BiblioSpec toolset=gcc
RUN cp build-linux-x86_64/BiblioSpec/bibliospec-bin-linux-*-release-*.tar.bz2 .

FROM alpine:latest  
WORKDIR /root/
COPY --from=0 /pwiz_build/pwiz/bibliospec-bin-linux-*-release-*.tar.bz2 ./bibliospec-bin-linux--release-.tar.bz2
RUN tar -x --bzip2 -f bibliospec-bin-linux-*-release-*.tar.bz2
RUN mkdir -p /bin
RUN mv Blib* /bin/.

CMD ["/bin/BlibBuild"]
