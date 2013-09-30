class Fhir::ValueSet
  class_attribute :sets
  self.sets = []

  class << self
    def identifier
      self.name.sub(/ValueSet$/, '')
    end

    def define(system, &block)
      set = Fhir::ValueSet::DefinedSet.new(system)
      Fhir::ValueSet::CodingBuilder.new(set).instance_exec(&block)
      self.sets += [set]
    end

    def compose(&block)
      self.sets += Fhir::ValueSet::CompositeBuilder.new.tap do |builder|
        builder.instance_exec(&block)
      end.sets
    end

    def get_display(code)
      find_coding_by(code: code).try(:display)
    end

    def find_coding_by(search_opts)
      matching_sets(search_opts).reduce(nil) do |coding, set|
        coding || set.find_coding_by(search_opts)
      end
    end

    def find_all_coding_by(search_opts)
      matching_sets(search_opts).reduce([]) do |coding, set|
        coding + set.find_all_coding_by(search_opts.reverse_merge(limit: 100, offset: 0))
      end
    end

    def find_all_coding
      find_all_coding_by(limit: nil, offset: nil)
    end

    private

    def matching_sets(search_opts)
      (system = search_opts[:system]) ? self.sets.select { |set| set.system == system } : self.sets
    end
  end
end
