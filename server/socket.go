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

func getWebSocketMicro() *fiber.App {
	micro := fiber.New()

	var number int // for socket testing
	scheduler := gocron.NewScheduler(time.UTC)
	scheduler.Every(1).Second().Do(func() {
		number = rand.Intn(100)
	})
	scheduler.StartAsync()

	micro.Get("/stream", websocket.New(func(connection *websocket.Conn) {
		for {
			err := connection.WriteMessage(1, []byte(strconv.Itoa(number)))
			time.Sleep(1 * time.Second)
			if err != nil {
				break
			}
		}
		defer connection.Close()
		log.Println("closed")
	}))

	return micro
}
