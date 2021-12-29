package main

import (
	"log"
	"math/rand"
	"strconv"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/websocket/v2"

	"github.com/go-co-op/gocron"
)

type BroadcastHub struct{}

var (
	receiver = make(map[*websocket.Conn]BroadcastHub)
	register = make(chan *websocket.Conn)
	detacher = make(chan *websocket.Conn)
)

func getWebSocketMicro() *fiber.App {
	micro := fiber.New()

	go openHub()
	streamData()

	micro.Get("/stream", websocket.New(pushToHub))

	return micro
}

func openHub() {
	for {
		select {
		case connection := <-register:
			receiver[connection] = BroadcastHub{}
			log.Println("registed")
		case connection := <-detacher:
			delete(receiver, connection)
			log.Println("detached")
		}
	}
}

func streamData() {
	scheduler := gocron.NewScheduler(time.UTC)

	scheduler.Every(500).Millisecond().Do(func() {
		num := rand.Intn(1000000)
		for connection := range receiver {
			connection.WriteMessage(websocket.TextMessage, []byte(strconv.Itoa(num)))
		}
	})

	scheduler.StartAsync()
}

func pushToHub(node *websocket.Conn) {
	register <- node

	for { // for maintain connection
		if _, _, err := node.ReadMessage(); err != nil {
			break
		}
	}

	defer func() {
		detacher <- node
		node.Close()
	}()
}
