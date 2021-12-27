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
	mainServer.Mount("/dashboard", GetDashboardMicro())
	mainServer.Mount("/signature", GetSignatureMicro())

	// Initiate Listening
	mainServer.Listen(":8080")
}
