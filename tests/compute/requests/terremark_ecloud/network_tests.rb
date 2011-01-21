Shindo.tests('TerremarkEcloud::Compute | network requests', ['terremark_ecloud']) do

  @network_format = {
    'Configuration' => {
      'Gateway' => String,
      'Netmask' => String
    },
    'Features' => {
      'FenceMode' => String
    },
    'href' => String,
    'Link' => {
      'href' => String,
      'name' => String,
      'rel'  => String,
      'type' => String
    },
    'name' => String
  }

  tests('success') do

    tests("#get_network").formats(@network_format) do
      TerremarkEcloud[:compute].get_network(TerremarkEcloud::Compute.preferred_network['href']).body
    end

  end

end
