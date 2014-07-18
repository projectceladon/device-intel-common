# Parameter-framework configurable domains

## What are they

The files containing the rules for all parameters handled by an instance of the
parameter-framework usually has a name in the form `XyzConfigurableDomains.xml`.

Since writing XML files may be unpractical, we use a language called "Extended
Domain Description" and write `.pfw` files.  These `.pfw` files are then
converted to XML.

## How to build them

For the conversion, you'll need to build `test-platform_host` and all targets
under
`vendor/intel/hardware/audio/parameter-framework/core/tools/xmlGenerator`:

    m test-platform_host remote-process_host
    mmm vendor/intel/hardware/audio/parameter-framework/core/tools/xmlGenerator

Then here are the commands (to be run from the directory where you found that
README) to create the configurable domains:

    # The general syntax is
    # hostDomainGenerator.sh <Pfw Configuration File> <criteria file> <pre-existing file to be amended or /dev/null> <list of .pfw files>
    # The result is printed to stdout

    # For the audio
    hostDomainGenerator.sh ParameterFrameworkConfiguration.xml criteria.txt AudioConfigurableDomains.Tuning.xml bytrt5651.pfw > AudioConfigurableDomains.xml

    # For the routes
    hostDomainGenerator.sh ParameterFrameworkConfigurationRoute.xml RouteCriterion.txt /dev/null routes.pfw parameters.pfw > RouteConfigurableDomains.xml

For convienience, we've added a GNU Makefile which you can use to run the
commands above (`make AudioConfigurableDomains.xml` or `make
RouteConfigurableDomains.xml`).  The generated
files have also been put into git.

## Why have the result been put into git ?

Indeed, it is often considered bad practice to put generated files along their
sources in revision.  However, we have had feedback from Google suggesting that
they're not fond of build-time configuration files generation.

So please, don't modify `AudioConfigurableDomains.xml` nor
`RouteConfigurableDomains.xml` by hand.  Instead, use the provided GNU Makefile
and add both sources and results modifications in your commits.
