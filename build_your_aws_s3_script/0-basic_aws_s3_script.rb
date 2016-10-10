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
    opts.on('-a', '--action=ACTION', [:list, :upload, :delete, :download], 'Select action to perform [list, upload, delete, download]') do |action|
        if !action
            puts 'Error: Not enough arguments'
        else
            options[:action] = action # puts whatever the action chosen in the options array.
        end
    end
    #
    opts.on('-f', '--filepath=FILEPATH', 'Path to the file to upload') do |filepath|
        options[:filepath] = filepath
    end
	#
	opts.on('-b', '--bucketname=BUCKET_NAME', 'Name of the bucket to perform the action on') do |bucketname|
		options[:bucketname] = bucketname
	end
    #
    opts.on('-v', '--verbose', 'Run verbosely') do |verb|
        options[:verbose] = verb
    end
    #
    opts.on_tail('-h', '--help', 'Returns the help menu') do
        puts opts
        exit
    end
    # an extra to try later.
    opts.on_tail('--version', 'Show version') do
        puts OptionParser::Version.join('.')
        exit
    end
end
opts_parser.parse!

# get the configuration from the yaml file.
config = YAML.load_file('config.yaml')

# setting up the s3 instance from the config file
s3 = Aws::S3::Client.new(
	region: 'us-west-2',
	access_key_id: config['access_key_id'],
	secret_access_key: config['secret_access_key']
)

# launching a new s3 bucket
if options[:action] == :list
	puts 'listing contents of bucket' if options[:verbose]
	unless options[:bucketname]
		puts 'Error: please put a bucket name ie: --action=list -b<NAME>'
		exit
	end
	r = s3.
	puts ''
end
