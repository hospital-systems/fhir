# A reference to a code defined by a terminology system.
class Fhir::Coding < Fhir::DataType
  # Identity of the terminology system
  attribute :system, Fhir::URI

  #The version of the code system
  attribute :version, String

  # Symbol in syntax defined by the system
  attribute :code, Fhir::Code

  # Representation defined by the system
  attribute :display, String

  #Indicates that this code was chosen by a user directly
  attribute :primary, Boolean

  #The set of possible coded values this coding was chosen from or constrained by.
  attribute :value_set, Fhir::URI

  def initialize(raw_attrs)
    attrs = raw_attrs.dup
    system = attrs[:system]

    attrs[:system] = if system.respond_to?(:uri)
                       system.uri
                     elsif system.is_a?(Symbol)
                       Fhir::CodeSystem[system].uri
                     else
                       system
                     end

    super(attrs)
  end

  def system_oid
    self.system.sub(/^urn\:oid\:/, '')
  end

  def get_system
    Fhir::CodeSystem.find_by_uri(self.system)
  end

  def to_concept
    Fhir::CodeableConcept.new(
      text: self.display,
      codings: [self]
    )
  end
end
