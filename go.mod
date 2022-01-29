module github.com/rockosocko/voice-cert-checker

go 1.16

replace github.com/genkiroid/cert => github.com/mogensen/cert v0.0.0-20210323130005-10d4e73883d5

require (
	github.com/genkiroid/cert v0.0.0-20210323130005-10d4e73883d5
	github.com/kr/pretty v0.2.1 // indirect
	github.com/prometheus/client_golang v1.10.0
	github.com/sirupsen/logrus v1.8.1
	github.com/spf13/cobra v1.1.3
	github.com/stretchr/testify v1.6.1 // indirect
	golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1 // indirect
	google.golang.org/protobuf v1.25.0 // indirect
	gopkg.in/yaml.v2 v2.4.0
)
