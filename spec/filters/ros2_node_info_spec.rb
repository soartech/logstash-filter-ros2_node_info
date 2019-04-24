# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/ros2_node_info"

describe LogStash::Filters::Ros2NodeInfo do
  describe "Parse valid message" do
    let(:config) do <<-CONFIG
      filter {
        ros2_node_info {
          source => "message"
        }
      }
    CONFIG
    end

    sample("message" => "/talker
  Subscribers:
    /parameter_events: rcl_interfaces/ParameterEvent
  Publishers:
    /chatter: std_msgs/String
  Services:
    /talker/set_parameters_atomically: rcl_interfaces/SetParametersAtomically") do
      expect(subject.get("node")).to eq("/talker")
      expect(subject.get("services")).to eq([{"topic"=>"/talker/set_parameters_atomically",
                                              "type"=>"rcl_interfaces/SetParametersAtomically"}])
      expect(subject.get("publishers")).to eq([{"topic"=>"/chatter",
                                                "type"=>"std_msgs/String"}])
      expect(subject.get("subscribers")).to eq([{"topic"=>"/parameter_events",
                                                 "type"=>"rcl_interfaces/ParameterEvent"}])
    end
  end
end
