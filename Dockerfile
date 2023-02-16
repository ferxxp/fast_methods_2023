
FROM ubuntu:22.10 AS compiler
RUN apt update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential\
        cmake\
        git\
        imagemagick\
        libboost-all-dev\
        cimg-dev

COPY . /fast_methods
RUN mkdir /fast_methods/build &&\
    cmake -S /fast_methods/ -B /fast_methods/build/  &&\
    make -C /fast_methods/build/
CMD /fast_methods/build/fm_benchmark /fast_methods/data/benchmark.cfg

FROM ubuntu:22.10 AS release
COPY --from=compiler /fast_methods/build /bin/* /fast_methods/build
CMD /fast_methods/build/fm_benchmark /fast_methods/data/benchmark.cfg
