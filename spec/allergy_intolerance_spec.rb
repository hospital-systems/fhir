require 'spec_helper'

describe 'AllergyIntolerance' do
  example do
    attrs = {
      criticality: 'fatal',
      sensitivity_type: 'allergy',
      recorded_date: Time.now,
      status: 'status',
      subject_ref: {
        _type: "Fhir::ResourceReference",
        type: 'Patient',
        reference: 'patient/@3123123'
      },
      substance: {
        _type: "Fhir::Substance",
        type: {
          text: 'aspirin',
          coding: [
            {
              system: 'RxNorm',
              code: '123456',
              display: 'aspirin'
            }
          ]
        },
        description: 'substance description',
        status: { text: 'active' },
      },
      reaction: [{
        _type: "Fhir::AdverseReaction",
        reaction_date: Time.now,
        did_not_occur_flag: false,
        symptom: [{
          code: {text: 'pain'},
          severity: 'over 9000'
        }],
          subject_ref: {
            _type: "Fhir::ResourceReference",
            type: 'Patient',
            reference: 'patient/@3123123'
          },
        exposure: [{
          exposure_date: Time.now,
          exposure_type: 'exposure type',
          causality_expectation: 'expectation code',
        }]
      }]
    }

    allergy = Fhir::AllergyIntolerance.new(attrs)

    allergy.criticality.should == 'fatal'
    allergy.sensitivity_type.should == 'allergy'
    allergy.status.should == 'status'
    allergy.substance.type.coding.first.system.should == 'RxNorm'
  end
end
