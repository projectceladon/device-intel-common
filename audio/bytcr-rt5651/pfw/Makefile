# See README.md
all: AudioConfigurableDomains-bytcr-rt5651-default.xml RouteConfigurableDomains-bytcr-rt5651-default.xml 

audiopfw_bytcr-rt5651-default_files := ParameterFrameworkConfiguration-bytcr-rt5651-default.xml criterions.mcg.txt AudioConfigurableDomains-bytcr-rt5651-default.Tuning.xml routing_scalpe_common.pfw bytcr-rt5651-default.pfw
AudioConfigurableDomains-bytcr-rt5651-default.xml: $(audiopfw_bytcr-rt5651-default_files) AudioClass-bytcr-rt5651-default.xml CodecSubsystem-bytcr-rt5651-default.xml LpeSubsystem-bytcr-rt5651-default.xml SysfsPmdownTimeBytcrSubsystem.xml ConfigurationSubsystem.xml
	hostDomainGenerator.sh $(audiopfw_bytcr-rt5651-default_files) > $@

routepfw_bytcr-rt5651-default_files := ParameterFrameworkConfigurationRoute-bytcr-rt5651-default.xml RouteCriterion.txt /dev/null routes-bytcr-rt5651-default.pfw routes-common.pfw parameters.pfw
RouteConfigurableDomains-bytcr-rt5651-default.xml: $(routepfw_bytcr-rt5651-default_files) RouteClass-bytcr-rt5651-default.xml RouteSubsystem-bytcr-rt5651-default.xml RouteSubsystem-common.xml
	hostDomainGenerator.sh $(routepfw_bytcr-rt5651-default_files) > $@

