FROM alpine:latest

RUN apk update
RUN apk add --no-cache bash build-base git linux-headers upx

RUN git clone https://github.com/lsof-org/lsof

WORKDIR lsof

RUN ./Configure linux

RUN sed -i '1i LDFLAGS="-static"' ./Makefile

RUN sed -i 's/${CC} -o/${CC} ${LDFLAGS} -o/' ./Makefile

RUN make -j$(nproc)

# Strip
RUN strip -s -R .comment -R .gnu.version --strip-unneeded ./lsof

# Compress
# RUN upx --ultra-brute --no-lzma ./lsof
