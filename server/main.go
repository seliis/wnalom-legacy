package main

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
)

func main() {
	mainServer := fiber.New()

	mainServer.Get("/connect", func(ctx *fiber.Ctx) error {
		fmt.Println("I said hello to flutter")
		ctx.SendString("Hello, Flutter!")
		return ctx.SendStatus(200)
	})

	mainServer.Listen(":8000")
}
