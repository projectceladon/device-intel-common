# See README.md
all: AudioConfigurableDomains-bytrt5640.xml RouteConfigurableDomains-bytrt5640.xml

audiopfw_bytrt5640_files := ParameterFrameworkConfiguration-bytrt5640.xml criteria.txt AudioConfigurableDomains-bytrt5640.Tuning.xml bytrt5640.pfw
AudioConfigurableDomains-bytrt5640.xml: $(audiopfw_bytrt5640_files) AudioClass-bytrt5640.xml Realtek_RT5640Subsystem.xml SysfsPmdownTimeBytcrSubsystem.xml
	hostDomainGenerator.sh $(audiopfw_bytrt5640_files) > $@

routepfw_bytrt5640_files := ParameterFrameworkConfigurationRoute-bytrt5640.xml RouteCriterion.txt /dev/null routes.pfw parameters.pfw
RouteConfigurableDomains-bytrt5640.xml: $(routepfw_bytrt5640_files) RouteClass-bytrt5640.xml RouteSubsystem-bytrt5640.xml RouteSubsystem-common.xml
	hostDomainGenerator.sh $(routepfw_bytrt5640_files) > $@
