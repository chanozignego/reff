require 'reff/spreadsheet_manager'

class Reff

  #TODO: argument --> file or file.path (tengo que cambiar el metodo que abre los archivos por el tema de la extension) ?????????????????
  def self.import(file, attributes)
    response = {}
    response[:rows] = [] 
    response[:errors] = {}
    errors = {}
    if file.present? || attributes.present?
      if file.class == File
        response = SpreadsheetManager.import(file, attributes)
      else   
        raise InvalidFileArgumentException, "Invalid file argument"
      end
    else
      raise NilFileArgumentException, "File argument can not be nil" unless file.nil?
      raise NilAttributesArgumentException, "Attributes argument can not be nil" unless attributes.empty?
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

class InvalidFileArgumentException < Exception; end
class NilFileArgumentException < Exception; end
class NilAttributesArgumentException < Exception; end