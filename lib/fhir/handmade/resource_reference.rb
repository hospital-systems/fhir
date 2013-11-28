class Fhir::ResourceReference < Fhir::DataType
  attribute :type, String
  attribute :reference, String
  attribute :display, String

  def self.build(resource_class, uuid)
    new(type: resource_class.name, reference: "#{resource_class.name.demodulize}/#{uuid}")
  end

  def self.for(resource)
    build(resource.class, resource.uuid)
  end

  def reference
    Fhir::URI.new(super)
  end
end
