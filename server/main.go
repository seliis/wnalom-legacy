package main

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
)

type Signature struct {
	MemberID string `json:"member_id"`
	APIKEY   string `json:"api_key"`
	SECRET   string `json:"secret_key"`
}

func main() {
	mainServer := fiber.New(fiber.Config{
		AppName: "WNALOM",
	})

	mainServer.Post("/test", func(ctx *fiber.Ctx) error {
		s := new(Signature)
		fmt.Println(ctx.BodyParser(s))
		return ctx.SendString("/test")
	})

	mainServer.Listen(":8000")
}
