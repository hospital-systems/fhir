require 'spec_helper'

describe 'Fhir::Virtus::Coercer' do
  class Quantity
    include Virtus.value_object

    attribute :value, Float
    attribute :units, String
  end

  class Coding
    include Virtus.value_object

    attribute :code, String
    attribute :system, String
  end

  class SomeType
    include Virtus.value_object
    attribute :value, String
  end

  class Observation
    include Virtus.model
    attribute :name, String
    attribute :value,  *Fhir::Type[Float, Quantity, Coding]
    attribute :values, *Fhir::Collection[Float, Quantity, Coding]
  end

  class Patient
    include Virtus.model
    attribute :multiple_birth, *Fhir::Type[Boolean, Integer]
  end

  it "hash in constructor"  do
    obs = Observation.new(name: "BP",
                          value: {
                            _type: "Quantity",
                            value: 120,
                            units: "hgmm"
                          })

    obs.value.should be_instance_of(Quantity)
    obs.value.value.should == 120
    obs.value.units.should == 'hgmm'
  end

  it "should do type checking"  do
    lambda do
      Observation.new(name: "BP",
                      value: {
                        _type: "SomeType",
                        value: 120
                      })
    end.should raise_error(/Unexpected value/)
  end

  it "should preserve primitive types"  do
    Observation.new(name: "BP",
                    value: "120").value.should == 120.0

    Observation.new(name: "BP",
                    value: "120.4").value.should == 120.4
  end

  it "should support multitype arrays" do
    obs = Observation.new(name: "example",
                          values: [
                            12.2,
                            { _type: "Quantity", value: 30, units: "bpm" },
                            { _type: "Coding", code: "34521", system: "loinc" }
                          ])

    obs.values.first.should == 12.2

    obs.values.second.class.should == Quantity
    obs.values.second.value.should == 30

    obs.values.third.class.should == Coding
    obs.values.third.code.should == "34521"
  end

  it "should support multitype arrays that contain Booleans" do
    pat_bool = Patient.new(multiple_birth: true)
    pat_bool.multiple_birth.should == true
    pat_bool.multiple_birth.class.should == TrueClass

    pat_bool.multiple_birth = "false"
    pat_bool.multiple_birth.should == false
    pat_bool.multiple_birth.class.should == FalseClass

    pat_int = Patient.new(multiple_birth: 2)
    pat_int.multiple_birth.should == 2
    pat_int.multiple_birth.should be_an Integer

    pat_int.multiple_birth = "3"
    pat_int.multiple_birth.should == 3
    pat_int.multiple_birth.should be_an Integer
  end
end
