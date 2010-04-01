module Fog
  module AWS
    module EC2
      class Real

        require 'fog/aws/parsers/ec2/terminate_instances'

        # Terminate specified instances
        #
        # ==== Parameters
        # * instance_id<~Array> - Ids of instances to terminates
        #
        # ==== Returns
        # # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'instancesSet'<~Array>:
        #       * 'instanceId'<~String> - id of the terminated instance
        #       * 'previousState'<~Hash>: previous state of instance
        #         * 'code'<~Integer> - previous status code
        #         * 'name'<~String> - name of previous state
        #       * 'shutdownState'<~Hash>: shutdown state of instance
        #         * 'code'<~Integer> - current status code
        #         * 'name'<~String> - name of current state
        def terminate_instances(instance_id)
          params = AWS.indexed_param('InstanceId', instance_id)
          request({
            'Action' => 'TerminateInstances',
            :parser  => Fog::Parsers::AWS::EC2::TerminateInstances.new
          }.merge!(params))
        end

      end

      class Mock

        def terminate_instances(instance_id)
          response = Excon::Response.new
          instance_id = [*instance_id]
          if (@data[:instances].keys & instance_id).length == instance_id.length
            for instance_id in instance_id
              response.body = {
                'requestId'     => Fog::AWS::Mock.request_id,
                'instancesSet'  => []
              }
              instance = @data[:instances][instance_id]
              @data[:deleted_at][instance_id] = Time.now
              response.status = 200
              # TODO: the codes are mostly educated guessing, not certainty
              code = case instance['state']
              when 'pending'
                0
              when 'running'
                16
              when 'shutting-down'
                32
              when 'terminated'
                64
              when 'rebooting'
                128
              end
              state = { 'name' => 'shutting-down', 'code' => 32}
              response.body['instancesSet'] << {
                'instanceId'    => instance_id,
                'previousState' => instance['instanceState'],
                'currentState'  => state
              }
              instance['instanceState'] = state

              describe_addresses.body['addressesSet'].each do |address|
                if address['instanceId'] == instance_id
                  disassociate_address(address['publicIp'])
                end
              end

              describe_volumes.body['volumeSet'].each do |volume|
                if volume['instanceId'] == instance_id
                  detach_volume(volume['volumeId'])
                end
              end

            end
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end
end
