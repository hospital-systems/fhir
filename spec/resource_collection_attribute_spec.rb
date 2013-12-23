require 'spec_helper'

describe 'ResourceCollection' do
  class Res3 < Fhir::Resource
    attribute :prop1, String
  end

  class Res4 < Fhir::Resource
    attribute :prop2, String
  end

  class TestRes3 < Fhir::Resource
    resource_references :subject, Res3
  end

  class TestRes4 < Fhir::Resource
    resource_references :subject, [Res3, Res4]
  end

  it "hash in constructor"  do
    res = TestRes3.new(subject: [
      { _type: 'Res3', prop1: 'val1' },
      { _type: 'Res3', prop1: 'val2' }
    ])

    res.subject.size == 2
    subj = res.subject.first
    subj.should be_a(Res3)
    subj.prop1.should == 'val1'
    subj = res.subject.last
    subj.prop1.should == 'val2'
    subj.should be_a(Res3)

    res.subject_refs.size == 2
  end

  it "hash in constructor"  do
    res = TestRes4.new(subject: [
      { _type: 'Res3', prop1: 'val1' },
      { _type: 'Res4', prop2: 'val2' },
      Res3.new(prop1: 'val3')
    ])

    res.subject.size == 2

    subj = res.subject.first
    subj.should be_a(Res3)
    subj.prop1.should == 'val1'

    subj = res.subject.second
    subj.prop2.should == 'val2'
    subj.should be_a(Res4)

    subj = res.subject.last
    subj.should be_a(Res3)
    subj.prop1.should == 'val3'

    res.subject_refs.size == 3
  end
end
