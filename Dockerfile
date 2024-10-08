FROM golang:1.22.1 AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

ENV CGO_ENABLED=1 GOOS=linux

RUN go build -o /todo

FROM alpine:latest

ENV TODO_PORT=7540
ENV TODO_DBFILE=scheduler.db

WORKDIR /app

COPY --from=builder /web .
COPY --from=builder /todo .

EXPOSE ${TODO_PORT}

CMD ["/app/todo"]