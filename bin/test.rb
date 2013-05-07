#!/usr/bin/env ruby

require 'pp'

pp "$: is --> " 
pp $LOAD_PATH

pp "__FILE__ is: #{__FILE__}"
t = File.expand_path(__FILE__)
pp "expanded __FILE__ is: #{__FILE__}"
t = File.expand_path("../../lib",__FILE__)
pp t
