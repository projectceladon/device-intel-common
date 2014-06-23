# See README.md
all: AudioConfigurableDomains-bytcr-rt5642-t100.xml RouteConfigurableDomains-bytcr-rt5642-t100.xml AudioConfigurableDomains-bytcr-rt5640-default.xml RouteConfigurableDomains-bytcr-rt5640-default.xml 

audiopfw_bytcr-rt5642-t100_files := ParameterFrameworkConfiguration-bytcr-rt5642-t100.xml criterions.mcg.txt AudioConfigurableDomains-bytcr-rt5642-t100.Tuning.xml routing_scalpe_common.pfw bytcr-rt5642-t100.pfw
AudioConfigurableDomains-bytcr-rt5642-t100.xml: $(audiopfw_bytcr-rt5642-t100_files) AudioClass-bytcr-rt5642-t100.xml CodecSubsystem-bytcr-rt5642-t100.xml LpeSubsystem-bytcr-rt5642-t100.xml SysfsPmdownTimeBytcrSubsystem.xml ConfigurationSubsystem.xml
	hostDomainGenerator.sh $(audiopfw_bytcr-rt5642-t100_files) > $@

routepfw_bytcr-rt5642-t100_files := ParameterFrameworkConfigurationRoute-bytcr-rt5642-t100.xml RouteCriterion.txt /dev/null routes-bytcr-rt5642-t100.pfw routes-common.pfw parameters.pfw
RouteConfigurableDomains-bytcr-rt5642-t100.xml: $(routepfw_bytcr-rt5642-t100_files) RouteClass-bytcr-rt5642-t100.xml RouteSubsystem-bytcr-rt5642-t100.xml RouteSubsystem-common.xml
	hostDomainGenerator.sh $(routepfw_bytcr-rt5642-t100_files) > $@

audiopfw_bytcr-rt5640-default_files := ParameterFrameworkConfiguration-bytcr-rt5640-default.xml criterions.mcg.txt AudioConfigurableDomains-bytcr-rt5640-default.Tuning.xml routing_scalpe_common.pfw bytcr-rt5640-default.pfw
AudioConfigurableDomains-bytcr-rt5640-default.xml: $(audiopfw_bytcr-rt5640-default_files) AudioClass-bytcr-rt5640-default.xml CodecSubsystem-bytcr-rt5640-default.xml LpeSubsystem-bytcr-rt5640-default.xml SysfsPmdownTimeBytcrSubsystem.xml ConfigurationSubsystem.xml
	hostDomainGenerator.sh $(audiopfw_bytcr-rt5640-default_files) > $@

routepfw_bytcr-rt5640-default_files := ParameterFrameworkConfigurationRoute-bytcr-rt5640-default.xml RouteCriterion.txt /dev/null routes-bytcr-rt5640-default.pfw routes-common.pfw parameters.pfw
RouteConfigurableDomains-bytcr-rt5640-default.xml: $(routepfw_bytcr-rt5640-default_files) RouteClass-bytcr-rt5640-default.xml RouteSubsystem-bytcr-rt5640-default.xml RouteSubsystem-common.xml
	hostDomainGenerator.sh $(routepfw_bytcr-rt5640-default_files) > $@
