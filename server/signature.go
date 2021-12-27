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
		ctx.SendString("Internal Server Error")
		fmt.Println(err)
		return ctx.SendStatus(500)
	}

	// Processing
	fmt.Println(signatureForm.Member, signatureForm.APIKey, signatureForm.Secret)

	if isMember(signatureForm.Member) {
		ctx.SendString("Saved")
		return ctx.SendStatus(200)
	} else {
		ctx.SendString("Denied")
		return ctx.SendStatus(401)
	}
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
