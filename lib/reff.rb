require 'reff/spreadsheet_manager'

class Reff

  #TODO: argument --> file or file.path (tengo que cambiar el metodo que abre los archivos por el tema de la extension) ?????????????????

  def self.import(file, attributes)
    response = {}
    response[:rows] = [] 
    response[:errors] = {}
    errors = {}
    if !file.nil? and !attributes.empty?
      if file.class == File
        response = SpreadsheetManager.import(file, attributes)
      else   
        response[:errors][:file] = "Invalid file argument"
      end
    else
      errors[:file] = "Not present file" unless file.nil?
      errors[:attributes] = "Not present attributes" unless file.empty?
      response[:errors] = errors
    end
    response
  end

  #def self.import(file)
  #  response = {}
  #  if !file.nil?
  #    response = SpreadsheetManager.import(file)
  #  else
  #    errors = {}
  #    errors[:file] = "Not present file" unless file.nil?
  #    response[:rows] = []
  #    response[:errors] = errors
  #  end
  #  response
  #end

end