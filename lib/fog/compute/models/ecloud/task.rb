module Fog
  module Ecloud
    class Compute
      class Task < Fog::Ecloud::Model

        identity :href, :aliases => :Href

        ignore_attributes :xmlns, :xmlns_i, :xmlns_xsi, :xmlns_xsd

        attribute :status
        attribute :type
        attribute :result, :aliases => :Result
        attribute :owner, :aliases => :Owner
        attribute :start_time, :aliases => :startTime, :type => :time
        attribute :end_time, :aliases => :endTime, :type => :time
        attribute :error, :aliases => :Error

      end
    end
  end
end
