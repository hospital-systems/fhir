require 'spec_helper'

describe "Datatypes" do
  example do
    address = Fhir::Address.new(
      use: 'blah',
      text: ['f safsad','f sadf sad'],
      line: ['Spb'],
      city: 'Omsk'
    )

    address.city.should == "Omsk"
  end
end
