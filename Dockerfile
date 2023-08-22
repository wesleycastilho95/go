FROM golang:1.21 as builder

WORKDIR /usr/src/hellofullcycle

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod ./
RUN CGO_ENABLED=0 GOOS=linux
RUN go mod download && go mod verify

COPY . .
RUN go build -ldflags "-s -w" -v -o /usr/local/bin/hellofullcycle ./...

CMD ["hellofullcycle"]

FROM scratch as production

COPY --from=builder /usr/local/bin/hellofullcycle /usr/local/bin/hellofullcycle

ENTRYPOINT ["hellofullcycle"]


