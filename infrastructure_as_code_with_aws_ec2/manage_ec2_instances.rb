require 'aws-sdk'
require 'optparse'
require 'yaml'

# get the configuration from the yaml file
config = YAML.load_file('config.yaml')

# Segment to parse the command line for options
options = {}
opts_parser = OptionParser.new do |opts|
	opts.separator " "
    opts.separator "Specific options:"
	opts.banner = "Usage: manage_ec2_instances.rb [options]"
	opts.on("-a", "--action ACTION", [:launch, :stop, :start, :terminate], "comment") do |action|
		if action == launch
			# TODO
		end
	end
	opts.on() do ||
		# TODO
	end
end

def initialize instance_id

end
