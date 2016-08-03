#!/usr/bin/ruby

require 'aws-sdk'
require 'optparse'
require 'yaml'

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
	opts.on("-h", "--help", "returns the help menu") do
		puts opts
		exit
	end
end
opts_parser.parse!

# get the configuration from the yaml file
config = YAML.load_file('config.yaml')

# setting up the ec2 instance from the config file
instance = Aws::EC2::Client.new(
		region: config['us-west-2'],
		access_key_id: config['access_key_id'],
		secret_access_key: config['secret_access_key']
	)

# launching ec2 instance
if options[:action] == :launch then
	r = instance.run_instances({
		image_id: config["image_id"],
		min_count: 1,
		max_count: 1,
		key_name: config['key_pair'],
		security_group_ids: config["security_group_ids"],
		instance_type: config["instance_type"],
		placement: {
			availability_zone: config["availability-zone"]
		}
	})
	instance_id = r.instances[0].instance_id
	r = ec2.wait_until(:instance_running, instance_ids:[instance_id])
	puts instance_id, r.reservations[0].instances[0].public_dns_name
else
	puts "something else"
end
