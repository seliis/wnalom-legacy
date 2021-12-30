package main

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/websocket/v2"

	"github.com/adshao/go-binance/v2"
)

type BroadcastHub struct{}

var (
	receiver = make(map[*websocket.Conn]BroadcastHub)
	register = make(chan *websocket.Conn)
	detacher = make(chan *websocket.Conn)
	messages = make(chan string)
	ipLogger = make(chan string)
)

func getMarketStat() {
	wsHandler := func(event binance.WsAllMarketsStatEvent) {
		eventData, err := json.Marshal(event)
		if err != nil {
			fmt.Println(err)
		}
		fmt.Println(string(eventData))
	}

	errHandler := func(err error) {
		fmt.Println(err)
	}

	channel, _, err := binance.WsAllMarketsStatServe(wsHandler, errHandler)
	if err != nil {
		log.Println(err)
		return
	}

	<-channel
}

func getAggregateData() {
	wsHandler := func(event *binance.WsAggTradeEvent) {
		for connection := range receiver {
			connection.WriteJSON(event)
		}
		fmt.Println(event)
	}

	errHandler := func(err error) {
		log.Println(err)
	}

	channel, _, err := binance.WsAggTradeServe("BTCUSDT", wsHandler, errHandler)
	if err != nil {
		log.Println(err)
		return
	}

	<-channel
}

func getWebSocketMicro() *fiber.App {
	micro := fiber.New()

	// go getAggregateData()
	go getMarketStat()

	go openHub()

	micro.Use("/stream", func(ctx *fiber.Ctx) error {
		member := ctx.Get("memberId")
		ctx.Locals("memberId", member)
		return ctx.Next()
	})

	micro.Get("/stream", websocket.New(pushToHub))

	return micro
}

func openHub() {
	for {
		select {
		case connection := <-register:
			receiver[connection] = BroadcastHub{}
		case connection := <-detacher:
			delete(receiver, connection)
		case textString := <-messages:
			log.Println(textString)
		case textString := <-ipLogger:
			log.Println(textString)
		}
	}
}

func pushToHub(connection *websocket.Conn) {
	// get connection informations
	member := fmt.Sprintf("%v", connection.Locals("memberId"))
	ip := connection.LocalAddr().String()

	// regist process
	register <- connection
	ipLogger <- "REGISTED MEMBER ID: " + member + ", IP ADDRESS: " + ip

	// maintain connection
	for {
		_, message, err := connection.ReadMessage()
		if err != nil {
			break
		}
		messages <- string(message)
	}

	// detach process
	defer func() {
		detacher <- connection
		ipLogger <- "DETACHED MEMBER ID: " + member + ", IP ADDRESS: " + ip
		connection.Close()
	}()
}
