package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/websocket/v2"
)

type Auditorium struct{}

var audience = make(map[*websocket.Conn]Auditorium)
var register = make(chan *websocket.Conn)
var decouple = make(chan *websocket.Conn)

// var delivery = make(chan string)

func runHub() {
	for { // Infinite Loop
		select {
		case connection := <-register:
			audience[connection] = Auditorium{}
			log.Println("registered")
		case connection := <-decouple:
			delete(audience, connection)
			log.Println("de-coupled")
		}
	}
}

func getWebSocketMicro() *fiber.App {
	micro := fiber.New()
	go runHub()

	micro.Use("/stream", func(ctx *fiber.Ctx) error {
		if websocket.IsWebSocketUpgrade(ctx) {
			ctx.Locals("allowed", true)
			return ctx.Next()
		}
		return ctx.SendStatus(426)
	})

	micro.Get("/stream", websocket.New(func(connection *websocket.Conn) {
		defer func() {
			decouple <- connection
			connection.Close()
		}()

		register <- connection

		for i := 0; i < 10; i++ {
			connection.WriteMessage(websocket.TextMessage, []byte("hello, world!"))
		}
	}))

	return micro
}
