require 'aws-sdk'
require 'optparse'
require 'yaml'

# get the configuration from the yaml file
config = YAML.load_file('config.yaml')

# Segment to parse the command line for options
options = {}
opts_parser = OptionParser.new do |opts|
	opts.separator ""
    opts.separator "Specific options:"
	opts.banner = "Usage: manage_ec2_instances.rb [options]"
	#
	opts.on("-a", "--action ACTION", [:launch, :stop, :start, :terminate], "Takes an action: launch, stop, start, terminate with a server_id") do |action|
		if not action then
			puts "Error: Not enought arguments"
		else
			options[:actions] = action
		end
	end
	#
	opts.on("-i", "--server_id SERVER_ID", "provides the server id when required") do |id|
		options[:server_id] = id
	end
	#
	opts.on("-v", "--verbose", "Provides extra information while the script is running") do |verb|
		options[:verbose] = verb
	end
end
