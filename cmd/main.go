package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/rockosocko/voice-cert-checker/cmd/app"
	"github.com/sirupsen/logrus"
)

func main() {
	ctx := signalHandler()

	cmd := app.NewCommand(ctx)
	cmd.PersistentFlags().StringP("config", "c", "config.yaml", "config file (default is config.yaml)")

	if err := cmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}

func signalHandler() context.Context {
	ctx, cancel := context.WithCancel(context.Background())
	ch := make(chan os.Signal, 2)
	signal.Notify(ch, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		sig := <-ch

		cancel()

		for i := 0; i < 3; i++ {
			logrus.Infof("received signal %s, shutting down gracefully...", sig)
			sig = <-ch
		}

		logrus.Errorf("received signal %s, force closing", sig)

		os.Exit(1)
	}()

	return ctx
}
