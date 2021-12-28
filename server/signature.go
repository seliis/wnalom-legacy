package main

import (
	"github.com/gofiber/fiber/v2"
)

func getSignatureMicro() *fiber.App {
	// Declare Signature Micro
	micro := fiber.New()

	// Method: POST
	micro.Post("/save", saveSignature)

	// Return
	return micro
}

func saveSignature(ctx *fiber.Ctx) error {
	if isMember(string(ctx.Body()[:])) {
		ctx.SendString("Saved")
		return ctx.SendStatus(200)
	}
	ctx.SendString("Denied")
	return ctx.SendStatus(401)
}

func isMember(memberId string) bool {
	members := []string{
		"alice", "bob", "eve",
	}
	for _, member := range members {
		if member == memberId {
			return true
		}
	}
	return false
}
