require 'spec'
require 'template_map'
require 'rio'
require 'hpricot'

describe TemplateMap do
  before(:each) do
    rio('demo_template.html') >> (template ||= "")
    @template = TemplateMap.new(:template => template, :record => {:title => 'yo ho ho!', :body => 'and a merry ho ho', :date => '2007'})
  end
  
  it "should be ok" do
    (Hpricot(@template.parsed)/"#title").inner_html.should == 'yo ho ho!'
  end

  it "should be ok" do
    @template.fields.should == ['title', 'date', 'body']
  end
  
  it "should have removed all example elements" do
    (@template.doc/".example").length.should == 0
  end
  
end