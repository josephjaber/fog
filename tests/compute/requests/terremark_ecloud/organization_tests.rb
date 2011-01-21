Shindo.tests('TerremarkEcloud::Compute | organization requests', ['terremark_ecloud']) do

  @organization_format = {
    'name'  => String,
    'href'  => String,
    'Link'  => [{
      'href'  => String,
      'name'  => String,
      'rel'   => String,
      'type'  => String
    }],
  }

  tests('success') do

    tests("#get_organization").formats(@organization_format) do
      TerremarkEcloud[:compute].get_organization.body
    end

  end

end
