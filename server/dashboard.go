package main

import (
	"github.com/gofiber/fiber/v2"
)

func GetDashboardMicro() *fiber.App {
	Micro := fiber.New()

	Micro.Post("/start", startTrade)

	return Micro
}

func startTrade(ctx *fiber.Ctx) error {
	return ctx.SendStatus(200)
}
