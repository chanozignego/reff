require 'reff/spreadsheet_manager'
class Reff
  def self.hi
    puts "Hello world!"
  end

  def self.import(file, attributes)
  	response = {}
  	if !file.nil? and !attributes.empty?
  		response = SpreadsheetManager.import(file, attributes)
  	else
  		errors = {}
  		errors[:file] = "Not present file" unless file.nil?
  		errors[:attributes] = "Not present attributes" unless file.empty?
  		response[:errors] = errors
  	end
    response
  end

end