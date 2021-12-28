package main

import (
	"github.com/gofiber/fiber/v2"
)

func main() {
	// Declare Main Server Instance
	mainServer := fiber.New(fiber.Config{
		AppName: "WNALOM",
	})

	// Mounting Distributors
	mainServer.Mount("/dashboard", getDashboardMicro())
	mainServer.Mount("/signature", getSignatureMicro())
	mainServer.Mount("/websocket", getWebSocketMicro())

	// Initiate Listening
	mainServer.Listen(":8080")
}
