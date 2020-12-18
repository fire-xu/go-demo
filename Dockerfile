FROM golang:1.14

WORKDIR /go/src/app
COPY . .
#RUN export GOPROXY=https://goproxy.cn
RUN go env -w GOPROXY=https://goproxy.cn
RUN go mod init
RUN go mod vendor
RUN go build -o api
EXPOSE 8080

CMD ["./api"]


