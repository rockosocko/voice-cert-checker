package app

import (
	"io/ioutil"
	"time"

	"github.com/rockosocko/voice-cert-checker/pkg/models"
	"gopkg.in/yaml.v2"
)

type options struct {
	IntervalMinutes int                  `yaml:"intervalminutes"`
	Port            int                  `yaml:"port"`
	WebPort         int                  `yaml:"webport"`
	LogLevel        string               `yaml:"loglevel"`
	Certificates    []models.Certificate `yaml:"certificates"`

	// IntervalDuration is computed from IntervalMinutes
	IntervalDuration time.Duration
}

func newOptionsFromFile(fileName string) (*options, error) {
	bytes, err := ioutil.ReadFile(fileName)
	if err != nil {
		return nil, err
	}
	opts := &options{}
	err = yaml.Unmarshal(bytes, opts)
	if err != nil {
		return nil, err
	}
	if opts.Port == 0 {
		opts.Port = 8080
	}
	if opts.WebPort == 0 {
		opts.WebPort = 8081
	}
	opts.IntervalDuration = time.Duration(int64(opts.IntervalMinutes)) * time.Minute
	return opts, nil

}
