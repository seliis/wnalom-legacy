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

func GetSignature() *fiber.App {
	// Declare Signature Micro
	Signature := fiber.New()

	// Method: POST
	Signature.Post("/save", saveSignature)

	// Return Micro
	return Signature
}

func saveSignature(ctx *fiber.Ctx) error {
	signatureForm := new(SignatureForm)

	// Parsing
	if err := ctx.BodyParser(signatureForm); err != nil {
		fmt.Println(err)
		return ctx.SendStatus(500)
	}

	// Processing
	fmt.Println(signatureForm.Member, signatureForm.APIKey, signatureForm.Secret)

	// Responsing
	ctx.SendString("Received")
	return ctx.SendStatus(200)
}
