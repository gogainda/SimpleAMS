require "spec_helper"

RSpec.describe SimpleAMS::Options, 'type' do
  context "with no type is specified" do
    before do
      @options = SimpleAMS::Options.new(
        User.new,
        Helpers.random_options_with({
          serializer: UserSerializer,
        }).tap{|h| h.delete(:type)}
      )
    end

    it "returns the default type" do
      expect(@options.type.name).to eq nil
    end
  end

  context "with no injected type" do
    before do
      @type = Elements.type(value: :a_type, options: {foo: :bar})
      UserSerializer.type(*@type.as_input)

      @options = SimpleAMS::Options.new(
        User.new,
        Helpers.random_options_with({
          serializer: UserSerializer,
        }).tap{|h| h.delete(:type)}
      )
    end

    it "returns the type specified" do
      expect(@options.type.name).to eq :a_type
      expect(@options.type.options).to eq({foo: :bar})
    end
  end

  context "with injected type" do
    before do
      #TODO: add as_options method
      type = Elements.type(value: :a_type, options: {foo: :bar})
      UserSerializer.type(*type.as_input)

      @type = Elements.type(value: :another_type, options: {bar: :foo})
      @options = SimpleAMS::Options.new(
        User.new,
        Helpers.random_options_with({
          serializer: UserSerializer,
          type: @type.as_input
        })
      )
    end

    it "returns the injected type specified" do
      expect(@options.type.name).to eq @type.value
      expect(@options.type.options).to eq(@type.options)
    end
  end
end
