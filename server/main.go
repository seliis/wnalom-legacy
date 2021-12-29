package main

import (
	"github.com/gofiber/fiber/v2"
)

// ** BINANCE PUBLIC KEY **
// API   : lWTzykapQbvi7kSU6OYHuEYVvbc9f9Bi5fidxJmvYpwFvnDlLPP42fMcgtaPLDtR
// SECRET: IbAZ82BeiFAWtBzTQtefn9FDaVnd3mkOdQXJMkBf5tMeWIMfcDA9Mn6qWvQfbPpM
// Restricted: Reading, Futures

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
