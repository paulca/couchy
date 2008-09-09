require 'hpricot'
class TemplateMap
    attr_accessor :template, :record
  def initialize(hash = {})
    self.template = hash[:template] if hash[:template]
    self.record = hash[:record] if hash[:record]
  end
  
  def doc
    doc = Hpricot(template)
    (doc/".example").remove
    doc
  end
  
  def fields
    (doc/".schema").map { |element| element['id'] }
  end
  
  def parsed
    fields.inject(doc) { |doc,field| (doc/"##{field}").inner_html = record[field.to_sym]; doc  }.to_s
  end
end