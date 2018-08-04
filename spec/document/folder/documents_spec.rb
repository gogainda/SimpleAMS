require "spec_helper"

RSpec.describe SimpleAMS::Document::Folder do
  describe "with various options for both collection/resource" do
    before do
      @setup_helper = SetupHelper.new
      @setup_helper.set_collection_allowed_options! #probably not needed
      @setup_helper.set_resource_allowed_options!

      @collection = 10.times.map{User.new}

      @folder = SimpleAMS::Document::Folder.new(
        SimpleAMS::Options.new(@collection, {
          injected_options: @setup_helper.injected_options
        })
      )
    end

    it "returns correct documents" do
      expect(@folder.documents.count).to eq @collection.count
      @folder.documents.each do |document|
        expect(document.name).to eq @collection.first.class.to_s.downcase.to_sym

        expect(document.type.name).to eq @collection.first.class.to_s.downcase.to_sym

        expect(document.adapter.name).to eq @setup_helper.injected_options[:adapter].first
        expect(document.adapter.options).to eq @setup_helper.injected_options[:adapter].last

        expect(document.fields.members).to eq @setup_helper.injected_options[:fields]

        expect(document.relations.map(&:name)).to eq @setup_helper.expected_relations_names
        expect(document.relations.count).to eq @setup_helper.expected_relations_count

        expect(document.links.map(&:name)).to eq @setup_helper.injected_options[:links].map(&:first)
        expect(document.links.map(&:value)).to eq @setup_helper.injected_options[:links].map{|l| l[1]}
        expect(document.links.map(&:options)).to eq @setup_helper.injected_options[:links].map(&:last)

        expect(document.metas.map(&:name)).to eq @setup_helper.injected_options[:metas].map(&:first)
        expect(document.metas.map(&:value)).to eq @setup_helper.injected_options[:metas].map{|l| l[1]}
        expect(document.metas.map(&:options)).to eq @setup_helper.injected_options[:metas].map(&:last)

      end
    end
  end
end