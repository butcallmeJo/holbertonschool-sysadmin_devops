#!/usr/bin/ruby

require 'aws-sdk'
require 'optparse'
require 'yaml'
require 'ostruct'

# Segment to parse the command line for options
ARGV << '-h' if ARGV.empty?
options = {}
opts_parser = OptionParser.new do |opts|
    opts.separator ''
    opts.separator 'Specific options:'
    opts.banner = 'Usage: aws_script.rb [options]'
    # action option with launch, stop, start and terminate of instances
    opts.on('-a', '--action=ACTION', [:launch, :stop, :start, :terminate, :status, :change_name], 'Select action to perform [launch, start, stop, terminate]') do |action|
        if !action
            puts 'Error: Not enough arguments'
        else
            options[:action] = action # puts whatever the action chosen in the options array.
        end
    end
    #
    opts.on('-i', '--instance_id=INSTANCE_ID', 'ID of the instance to perform an action on') do |id|
        options[:instance_id] = id
    end
    #
    opts.on('-v', '--verbose', 'Run verbosely') do |verb|
        options[:verbose] = verb
    end
    #
    opts.on('-s', '--status', 'Status of an instance') do |status|
        options[:status] = status
    end
    #
    opts.on('-n', '--name', 'Change the name of the instance') do |name|
        options[:name] = name
    end
    #
    opts.on_tail('-h', '--help', 'Returns the help menu') do
        puts opts
        exit
    end
    # an extra to try later.
    opts.on_tail('-v', '--version', 'Show version') do
        puts OptionParser::Version.join('.')
        exit
    end
end
opts_parser.parse!

# get the configuration from the yaml file
config = YAML.load_file('config.yaml')

# setting up the ec2 instance from the config file
instance = Aws::EC2::Client.new(
    region: 'us-west-2',
    access_key_id: config['access_key_id'],
    secret_access_key: config['secret_access_key']
)

# launching ec2 instance
if options[:action] == :launch
    puts 'launching a new instance' if options[:verbose]
    r = instance.run_instances(image_id: config['image_id'],
                               min_count: 1,
                               max_count: 1,
                               key_name: config['key_pair'],
                               security_group_ids: config['security_group_ids'],
                               instance_type: config['instance_type'],
                               placement: {
                                   availability_zone: config['availability-zone']
                               })
    instance_id = r.instances[0].instance_id
    r = instance.wait_until(:instance_running, instance_ids: [instance_id])
    puts 'returning in format <instance_id> <public_dns_name>' if options[:verbose]
    puts instance_id, r.reservations[0].instances[0].public_dns_name
# Stop an existing instance
elsif options[:action] == :stop
    unless options[:instance_id]
        puts 'Error: please put a server id'
        exit
    end
    puts "stopping instance with id #{options[:instance_id]}" if options[:verbose]
    r = instance.stop_instances(instance_ids: [options[:instance_id]])
    puts "instance #{options[:instance_id]} stopped" if options[:verbose] && instance.wait_until(:instance_stopped, instance_ids: [options[:instance_id]])

# Start an existing instance
elsif options[:action] == :start
    unless options[:instance_id]
        puts 'Error: please put a server id'
        exit
    end
    r = instance.start_instances(instance_ids: [options[:instance_id]])
    r = instance.wait_until(:instance_running, instance_ids: [options[:instance_id]])
    puts r.reservations[0].instances[0].public_dns_name

# Terminate an existing instance
elsif options[:action] == :terminate
    unless options[:instance_id]
        puts 'Error: please put a server id'
        exit
    end
    r = instance.terminate_instances(instance_ids: [options[:instance_id]])
elsif options[:status] || options[:action] == :status
    unless options[:instance_id]
        puts 'Error: please put a server id'
        exit
    end
    r = instance.describe_instance_status(instance_ids: [options[:instance_id]])
    puts r
elsif options[:name] && options[:action] == :change_name
	unless options[:instance_id]
        puts 'Error: please put a server id'
        exit
    end
	instance.create_tags(:resources => [options[:instance_id]], :tags => [:key => "Name", :value => options[:name]])
end
