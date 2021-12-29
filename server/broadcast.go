package main

import (
	"fmt"
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
	messages = make(chan string)
	ipLogger = make(chan string)
)

func getWebSocketMicro() *fiber.App {
	micro := fiber.New()

	go openHub()
	streamData()

	micro.Use("/stream", func(ctx *fiber.Ctx) error {
		member := ctx.Get("memberId")
		ctx.Locals("memberId", member)
		return ctx.Next()
	})

	micro.Get("/stream", websocket.New(pushToHub))

	return micro
}

func openHub() {
	for {
		select {
		case connection := <-register:
			receiver[connection] = BroadcastHub{}
		case connection := <-detacher:
			delete(receiver, connection)
		case textString := <-messages:
			log.Println(textString)
		case textString := <-ipLogger:
			log.Println(textString)
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

func pushToHub(connection *websocket.Conn) {
	// get connection informations
	member := fmt.Sprintf("%v", connection.Locals("memberId"))
	ip := connection.LocalAddr().String()

	// regist process
	register <- connection
	ipLogger <- "REGISTED MEMBER ID: " + member + ", IP ADDRESS: " + ip

	// maintain connection
	for {
		_, message, err := connection.ReadMessage()
		if err != nil {
			break
		}
		messages <- string(message)
	}

	// detach process
	defer func() {
		detacher <- connection
		ipLogger <- "DETACHED MEMBER ID: " + member + ", IP ADDRESS: " + ip
		connection.Close()
	}()
}
