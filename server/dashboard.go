package main

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
)

type SignatureForm struct {
	Member string `json:"member"`
	APIKey string `json:"apikey"`
	Secret string `json:"secret"`
}

func GetDashboardMicro() *fiber.App {
	Micro := fiber.New()

	Micro.Post("/start", startTrade)

	return Micro
}

func startTrade(ctx *fiber.Ctx) error {
	signatureForm := new(SignatureForm)
	ctx.BodyParser(signatureForm)
	fmt.Println(signatureForm.Member, signatureForm.APIKey, signatureForm.Secret)
	return ctx.SendStatus(200)
}
