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
    opts.on('-a', '--action=ACTION', [:launch, :stop, :start, :terminate], 'Select action to perform [launch, start, stop, terminate]') do |action|
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
