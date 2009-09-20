require File.dirname(__FILE__) + '/../spec_helper'

describe Imagetastic::Parameters do
  
  describe "initializing" do
    it "should allow initializing without a hash" do
      parameters = Imagetastic::Parameters.new
      parameters.uid.should be_nil
    end
    it "should allow initializing with a hash" do
      parameters = Imagetastic::Parameters.new(:uid => 'b')
      parameters.uid.should == 'b'
    end
    it "should raise an error if initialized with a bad hash key" do
      lambda{
        Imagetastic::Parameters.new(:fridge => 'cold')
      }.should raise_error(ArgumentError)
    end
  end
  
  describe "accessors" do
    before(:each) do
      @parameters = Imagetastic::Parameters.new
    end
    it "should give the accessors the correct defaults" do
      @parameters.uid.should be_nil
      @parameters.processing_method.should be_nil
      @parameters.mime_type.should be_nil
      @parameters.processing_options.should == {}
      @parameters.encoding.should == {}
    end
    it "should provide writers too" do
      @parameters.uid = 'hello'
      @parameters.uid.should == 'hello'
    end
  end
  
  describe "array style accessors" do
    before(:each) do
      @parameters = Imagetastic::Parameters.new(:uid => 'hello')
    end
    it "should be the same as calling the corresponding reader" do
      @parameters[:uid].should == @parameters.uid
    end
    it "should be the same as calling the corresponding writer" do
      @parameters[:uid] = 'goodbye'
      @parameters.uid.should == 'goodbye'
    end
  end
  
  describe "comparing" do
    before(:each) do
      attributes = {
        :uid => 'a',
        :processing_method => 'b',
        :mime_type => 'image/gif',
        :processing_options => {:a => 'b'},
        :encoding => {:c => 'd'}
      }
      @parameters1 = Imagetastic::Parameters.new(attributes)
      @parameters2 = Imagetastic::Parameters.new(attributes)      
    end
    it "should return true when two have all the same attributes" do
      @parameters1.should == @parameters2
    end
    %w(uid processing_method mime_type processing_options encoding).each do |attribute|
      it "should return false when #{attribute} is different" do
        @parameters2[attribute.to_sym] = 'fish'
        @parameters1.should_not == @parameters2
      end
    end
  end
  
  describe "to_hash" do
    it "should return the attributes as a hash" do
      attributes = {
        :uid => 'a',
        :processing_method => 'b',
        :mime_type => 'image/gif',
        :processing_options => {:a => 'b'},
        :encoding => {:c => 'd'}
      }
      parameters = Imagetastic::Parameters.new(attributes)
      parameters.to_hash.should == attributes
    end
  end
  
  describe "custom parameters classes" do
    
    before(:each) do
      @parameters_class = Class.new(Imagetastic::Parameters)
    end
    
    describe "when defaults are not set" do
      it "should return the standard defaults" do
        parameters = @parameters_class.new
        parameters.processing_method.should be_nil
        parameters.processing_options.should == {}
        parameters.mime_type.should be_nil
        parameters.encoding.should == {}
      end
    end
    
    describe "when defaults are set" do
      before(:each) do
        @parameters_class.configure do |c|
          c.default_processing_method = :resize
          c.default_processing_options = {:scale => '0.5'}
          c.default_mime_type = 'image/png'
          c.default_encoding = {:bit_rate => 24}
        end
      end
      it "should return the default if not set on parameters" do
        parameters = @parameters_class.new
        parameters.processing_method.should == :resize
        parameters.processing_options.should == {:scale => '0.5'}
        parameters.mime_type.should == 'image/png'
        parameters.encoding.should == {:bit_rate => 24}
      end
      it "should return the correct parameter if set" do
        parameters = @parameters_class.new(
          :processing_method => :yo,
          :processing_options => {:a => 'b'},
          :mime_type => 'text/plain',
          :encoding => {:ah => :arg}
        )
        parameters.processing_method.should == :yo
        parameters.processing_options.should == {:a => 'b'}
        parameters.mime_type.should == 'text/plain'
        parameters.encoding.should == {:ah => :arg}
      end
    end
    
  end
  
end