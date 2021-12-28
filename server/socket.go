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
		case node := <-register:
			audience[node] = Auditorium{}
			log.Println("registered")
		case node := <-decouple:
			delete(audience, node)
			log.Println("de-coupled")
		default:
			for node := range audience {
				if err := node.WriteMessage(websocket.TextMessage, []byte("hello, world!")); err != nil {
					node.WriteMessage(websocket.CloseMessage, []byte{})
					delete(audience, node)
					log.Println(err)
					node.Close()
				}
			}
		}
	}
}

func openSocket() {
	micro := fiber.New()
	go runHub()

	micro.Use("/websocket", func(ctx *fiber.Ctx) error {
		if websocket.IsWebSocketUpgrade(ctx) {
			ctx.Locals("allowed", true)
			return ctx.Next()
		}
		return fiber.ErrUpgradeRequired
	})

	micro.Get("/websocket", websocket.New(func(connection *websocket.Conn) {
		defer func() {
			decouple <- connection
			connection.Close()
		}()

		register <- connection
	}))
}
