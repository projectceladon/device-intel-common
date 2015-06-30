#!/usr/bin/env python

import os
import json
from optparse import OptionParser
from lxml import etree

# main Class to generate xml file from json configuration file
class FlashFileXml:

    def __init__(self, config, platform):
        self.xmlfile = os.path.join(options.directory, config['filename'])
        self.flist = []
        flashtype = config['flashtype']
        self.xml = etree.Element('flashfile')
        self.xml.set('version','1.0')
        self.add_sub(self.xml, 'id', flashtype)
        self.add_sub(self.xml, 'platform', platform)

    def add_sub(self, parent, name, text):
        sub = etree.SubElement(parent, name)
        sub.text = text

    def add_file(self, filetype, filename, version):
        if filename in self.flist:
            return
        cg = etree.SubElement(self.xml, 'code_group')
        cg.set('name', filetype)
        fl = etree.SubElement(cg, 'file')
        fl.set('TYPE', filetype)
        self.add_sub(fl, 'name', filename)
        self.add_sub(fl, 'version', version)

        self.flist.append(filename)

    def add_buildproperties(self, buildprop):
        if not os.path.isfile(buildprop):
            return
        bp = etree.SubElement(self.xml, 'buildproperties')
        with open(buildprop, 'r') as f:
            for line in f.readlines():
                if not line.startswith("#") and line.count("=") == 1:
                    name, value = line.strip().split("=")
                    pr = etree.SubElement(bp, 'property')
                    pr.set('name', name)
                    pr.set('value', value)

    def add_command(self, command, description, (timeout, retry, mandatory)):
        command = ' '.join(command)
        mandatory = {True: "1", False: "0"}[mandatory]
        cmd = etree.SubElement(self.xml, 'command')
        self.add_sub(cmd, 'string', command)
        self.add_sub(cmd, 'timeout', str(timeout))
        self.add_sub(cmd, 'retry', str(retry))
        self.add_sub(cmd, 'description', description)
        self.add_sub(cmd, 'mandatory', mandatory)

    def parse_command(self, commands):
        for cmd in commands:
            if cmd['type'] in ['fflash', 'fboot', 'apush']:
                fname = os.path.basename(t2f[cmd['target']])
                shortname = fname.split('.')[0]
                self.add_file(shortname, fname, options.btag)
                cmd['pftname'] = '$' + shortname.lower() + '_file'

        for cmd in commands:
            params = (cmd.get('timeout', 120000), cmd.get('retry', 2), cmd.get('mandatory', True))

            if cmd['type'] == 'prop':
                self.add_buildproperties(t2f[cmd['target']])
                continue
            elif cmd['type'] == 'fflash':
                desc = cmd.get('desc', 'Flashing ' + cmd['partition'] + ' image')
                command = ['fastboot', 'flash', cmd['partition'], cmd['pftname']]
            elif cmd['type'] == 'ferase':
                desc = cmd.get('desc', 'Erase ' + cmd['partition'] + ' partition')
                command = ['fastboot', 'erase', cmd['partition']]
            elif cmd['type'] == 'fboot':
                desc = cmd.get('desc', 'Uploading fastboot image.')
                command = ['fastboot', 'boot', cmd['pftname']]
            elif cmd['type'] == 'foem':
                desc = cmd.get('desc', 'fastboot oem ' + cmd['arg'])
                command = ['fastboot', 'oem', cmd['arg']]
            elif cmd['type'] == 'fcontinue':
                desc = cmd.get('desc', 'Rebooting now.')
                command = ['fastboot', 'continue']
            elif cmd['type'] == 'freboot':
                desc = cmd.get('desc', 'Rebooting now.')
                command = ['fastboot', 'reboot']
            elif cmd['type'] == 'sleep':
                desc = cmd.get('desc', 'Sleep for ' + str(params[0] / 1000) + ' seconds.')
                command = ['sleep']
            elif cmd['type'] == 'adb':
                desc = cmd.get('desc', 'adb ' + cmd['arg'])
                command = ['adb', cmd['arg']]
            elif cmd['type'] == 'apush':
                desc = cmd.get('desc', 'Push ' + cmd['dest'])
                command = ['adb', 'push', cmd['pftname'], cmd['dest']]
            else:
                continue
            self.add_command(command, desc, params)

    def finish(self):
        print 'writing ', self.xmlfile

        tree = etree.ElementTree(self.xml)
        tree.write(self.xmlfile, xml_declaration=True, encoding="utf-8", pretty_print=True)

# class to generate installer .sh file from json configuration file.
# .sh files are used for flashing a board in one single command.
class FlashFileSh:

    def __init__(self, config):
        self.sh = "#/bin/sh\n\n"
        self.shfile = os.path.join(options.directory, config['filename'])

    def parse_command(self, commands):
        for cmd in commands:
            if cmd['type'] == 'fflash':
                self.sh += 'fastboot flash ' + cmd['partition'] + ' ' + os.path.basename(t2f[cmd['target']]) + '\n'
            elif cmd['type'] == 'ferase':
                self.sh += 'fastboot erase ' + cmd['partition'] + '\n'
            elif cmd['type'] == 'foem':
                self.sh += 'fastboot oem ' + cmd['arg'] + '\n'
            elif cmd['type'] == 'fcontinue':
                self.sh += 'fastboot continue\n'
            elif cmd['type'] == 'freboot':
                self.sh += 'fastboot reboot\n'

    def finish(self):
        print 'writing ', self.shfile
        with open(self.shfile, "w") as f:
            f.write(self.sh)
# class to generate installer .cmd file from json configuration file.
# .cmd files are used by droidboot to flash target without USB device.
class FlashFileCmd:

    def __init__(self, config):
        self.cmd = ""
        self.cmdfile = os.path.join(options.directory, config['filename'])

    def parse_command(self, commands):
        for cmd in commands:
            if cmd['type'] == 'fflash':
                self.cmd += 'flash:' + cmd['partition'] + '#/installer/' + os.path.basename(t2f[cmd['target']]) + '\n'
            elif cmd['type'] == 'ferase':
                self.cmd += 'erase:' + cmd['partition'] + '\n'
            elif cmd['type'] == 'foem':
                self.cmd += 'oem:' + cmd['arg'] + '\n'
            elif cmd['type'] == 'fcontinue':
                self.cmd += 'continue\n'
            elif cmd['type'] == 'freboot':
                self.cmd += 'reboot\n'

    def finish(self):
        print 'writing ', self.cmdfile
        with open(self.cmdfile, "w") as f:
            f.write(self.cmd)

# main Class to generate json file from json configuration file
class FlashFileJson:

    def __init__(self, config):
        self.jsonfile = os.path.join(options.directory, config['filename'])
        self.flist = []
        self.flash = {'version': '2.0',
		      'groups': {},
		      'osplatform': 'android',
                      'parameters': {},
		      'configurations': {},
		      'commands': []}
        self.prop = {}

    def add_file(self, shortname, filename):
        if filename in self.flist:
            return
        self.flist.append(filename)
        new = {'type': 'file', 'name': shortname, 'value': filename, 'description': filename}
        self.flash['parameters'][shortname] = new

    def add_configuration(self, config_name, brief, description, groupsState, name, parameters, startState, default):
        new = {config_name: {'brief': brief,
                            'description': description,
                            'groupsState': groupsState,
                            'name': name,
                            'parameters': parameters,
                            'startState': startState,
                            'default': default
                            }
              }
        self.flash['configurations'].update(new)


    def add_command(self, tool, args, description, restrict, (timeout, retry, mandatory)):
        new = {'tool': tool,
               'args': args,
               'description': description,
               'timeout': 600000,
               'retry': retry,
               'mandatory': mandatory,
               'restrict': restrict}
        self.flash['commands'].append(new)

    def add_buildproperties(self, buildprop):
        if not os.path.isfile(buildprop):
            return

        with open(buildprop, 'r') as f:
            for line in f.readlines():
                if not line.startswith("#") and line.count("=") == 1:
                    name, value = line.strip().split("=")
                    self.prop[name] = value

    def parse_command(self, commands):

        up_args = ''
        smp_args = ''

        for cmd in commands:
            if cmd['type'] in ['fls']:
                if (cmd['core'] in ['up,smp']) or (cmd['core'] in ['up']):
                    fname = os.path.basename(t2f[cmd['target']])
                    shortname = fname.split('.')[0].lower()
                    self.add_file(shortname, fname)
                    cmd['pftname'] = '${' + shortname + '}'
                    up_args = up_args + ' ' + cmd['pftname']

                if (cmd['core'] in ['up,smp']) or (cmd['core'] in ['smp']):
                    fname = os.path.basename(t2f[cmd['target']])
                    shortname = fname.split('.')[0].lower()
                    self.add_file(shortname, fname)
                    cmd['pftname'] = '${' + shortname + '}'
                    smp_args = smp_args + ' ' + cmd['pftname']

            if cmd['type'] == 'prop':
                self.add_buildproperties(t2f[cmd['target']])
                continue

        params = (cmd.get('timeout', 60000), cmd.get('retry', 2), cmd.get('mandatory', True))
        tools = 'flsDownloader'
        up_desc = cmd.get('desc', 'Flashing ' + 'UP' + 'FLS' + ' image')
        smp_desc = cmd.get('desc', 'Flashing ' + 'SMP' + 'FLS' + ' image')
        self.add_command(tools, up_args, up_desc, 'up_fls_config', params)
        self.add_command(tools, smp_args, smp_desc, 'smp_fls_config', params)
        smp_erase_desc = cmd.get('desc', 'Erase & Flashing ' + 'SMP' + 'FLS' + ' image')
        self.add_command(tools, '--erase-mode=2 ' + smp_args, smp_desc, 'smp_fls_erase_config', params)


    def parse_configuration(self, configurations):
        for config in configurations:
            if config['config_name'] in ['smp_fls_config']:
                default = True
            else:
                default = False

            self.add_configuration(config['config_name'], config['brief'], config['description'], config['groupsState'], config['name'], config['parameters'], config['startState'], default)

    def finish(self):
        print 'writing ', self.jsonfile
        self.json = {'flash': self.flash,
                     'build_info': self.prop}
        print self.json
        with open(self.jsonfile, "w") as f:
            json.dump(self.json, f, indent=4, sort_keys=True)

def parse_config(conf):
    for c in conf['config']:
        if c['filename'][-4:] == '.xml':
            f = FlashFileXml(c, options.platform)
        elif c['filename'][-4:] == '.cmd':
            f = FlashFileCmd(c)
        elif c['filename'][-5:] == '.json':
            f = FlashFileJson(c)
        elif c['filename'][-3:] == '.sh':
            f = FlashFileSh(c)

        commands = conf['commands']
        commands = [cmd for cmd in commands if not 'target' in cmd or cmd['target'] in t2f]
        commands = [cmd for cmd in commands if not 'restrict' in cmd or c['name'] in cmd['restrict']]

        f.parse_command(commands)

        if c['filename'][-5:] == '.json':
            configurations = conf['configurations']
            f.parse_configuration(configurations)

        f.finish()


# dictionnary to translate Makefile "target" name to filename
def init_t2f_dict():
    d = {}
    for l in options.t2f.split():
        target, fname = l.split(':')
        if fname == '':
            print "warning: skip missing target %s" % target
            continue
        d[target] = fname
    return d

if __name__ == '__main__':

    global options
    global t2f
    usage = "usage: %prog [options] flash.xml"
    description = "Tools to generate flash.xml"
    parser = OptionParser(usage, description=description)
    parser.add_option("-c", "--config", dest="infile", help="read configuration from file")
    parser.add_option("-p", "--platform", dest="platform", default='default', help="platform refproductname")
    parser.add_option("-b", "--buildtag", dest="btag", default='notag', help="buildtag")
    parser.add_option("-d", "--dir", dest="directory", default='.', help="directory to write generated files")
    parser.add_option("-t", "--target2file", dest="t2f", default=None, help="dictionary to translate makefile target to filename")
    (options, args) = parser.parse_args()

    with open(options.infile, 'rb') as f:
        conf = json.loads(f.read())

    t2f = init_t2f_dict()

    parse_config(conf)
