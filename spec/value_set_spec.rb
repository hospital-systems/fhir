require 'spec_helper'

describe Fhir::ValueSet do
  KNOWN_CONCEPT_ID = 36692007.to_s
  KNOWN_ABSENT_CONCEPT_ID = 410516002.to_s

  subject do
    class TestValueSet < Fhir::ValueSet
      define 'http://example.com/test' do
        concept 'TC1', 'Test Concept 1'
      end
      compose do
        include 'http://snomed.info/id', is_a: KNOWN_CONCEPT_ID
      end
    end
  end

  it 'should convert coding to attributes' do
    Fhir::Coding.new(system: 'system', code: 'code', display: 'display')
      .serialize
      .should == {
      system: 'system',
      code: 'code',
      display: 'display',
      _type: "Fhir::Coding"
    }
  end

  its(:identifier) { should == 'Test' }

  it 'should have defined coding' do
    coding = subject.find_coding_by(system: 'http://example.com/test', code: 'TC1')
    expect(coding.code).to be_eql 'TC1'
    expect(coding.display).to be_eql 'Test Concept 1'
    expect(coding.system).to be_eql 'http://example.com/test'
  end

  it 'should have included snomed subset' do
    coding = subject.find_coding_by(system: 'http://snomed.info/id', code: KNOWN_ABSENT_CONCEPT_ID)
    expect(coding.display).to be_eql('Known absent (qualifier value)')
    expect(coding.system).to be_eql('http://snomed.info/id')
    expect(coding.code).to be_eql(KNOWN_ABSENT_CONCEPT_ID.to_s)
  end

  it 'should search by code' do
    expect(subject.find_coding_by(code: 'TC1')).to_not be_nil
    expect(subject.find_coding_by(system: 'http://example.com/test', code: 'TC1')).to_not be_nil
    expect(subject.find_coding_by(system: 'http://snomed.info/id', code: 'TC1')).to be_nil
    expect(subject.find_coding_by(code: KNOWN_ABSENT_CONCEPT_ID)).to_not be_nil
    expect(subject.find_coding_by(system: 'http://example.com/test', code: KNOWN_ABSENT_CONCEPT_ID)).to be_nil
    expect(subject.find_coding_by(system: 'http://snomed.info/id', code: KNOWN_ABSENT_CONCEPT_ID)).to_not be_nil
  end

  it 'should search by display name' do
    expect(subject.find_coding_by(term: 'te co 1')).to_not be_nil
    expect(subject.find_coding_by(term: 'te co 2')).to be_nil
    expect(subject.find_coding_by(term: 'know abs')).to_not be_nil
    expect(subject.find_coding_by(term: 'know pres')).to_not be_nil
    expect(subject.find_coding_by(term: 'know unk')).to be_nil
  end

  it 'should find all by term' do
    expect(subject.find_all_coding_by(term: 'know')).to have_at_least(3).items
    expect(subject.find_all_coding_by(term: 'test con')).to have(1).item
  end

  it 'should search by exact name' do
    expect(subject.find_all_coding_by(display: 'Known absent (qualifier value)')).to have(1).item
    expect(subject.find_all_coding_by(display: 'Known absent')).to have(0).items
  end

  it 'should limit search results' do
    expect(subject.find_all_coding_by(term: 'know', limit: 1)).to have_at_least(1).item
  end

  it 'should return all coding' do
    coding = subject.find_all_coding
    expect(coding.find { |c| c.code == 'TC1' }).to_not be_nil
    expect(coding.find { |c| c.code == KNOWN_ABSENT_CONCEPT_ID }).to_not be_nil
  end
end
