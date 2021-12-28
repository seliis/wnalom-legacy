package main

import (
	"github.com/gofiber/fiber/v2"
)

type SignatureForm struct {
	Member string `json:"member"`
	APIKey string `json:"apikey"`
	Secret string `json:"secret"`
}

func getDashboardMicro() *fiber.App {
	micro := fiber.New()

	micro.Post("/start", startTrade)

	return micro
}

func startTrade(ctx *fiber.Ctx) error {
	signatureForm := new(SignatureForm)
	ctx.BodyParser(signatureForm)

	if isMember(signatureForm.Member) {
		ctx.SendString("Authorized")
		return ctx.SendStatus(200)
	}

	ctx.SendString("Denied")
	return ctx.SendStatus(401)
}
