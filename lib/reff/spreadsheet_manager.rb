class SpreadsheetManager
  def self.import file, attributes
    result = {}
    result[:rows] = []
    result[:errors] = {}

    spreadsheet = open_spreadsheet(file)
    
    begin
      header = spreadsheet.row(1)
    #rescue StandardError => e 
    #  puts e.message
    #  raise InvalidFileException, "Invalid file format. Could not read file"
    end

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row.present?
        begin
          result = model_attributes(row, attributes)
          if result.present?
            result[:rows].push("#{i}": result)
          else
            raise InvalidFileHeaderException, "Invalid file header. Could not read header"
          end
        #rescue => ex
        #  raise UnreadableRowException, "Wrong number of arguments. Could not read content"
        end
      else
        raise UnreadableRowException, "Wrong number of arguments. Could not read content"
      end
    end
    
    result
  end

  def self.open_spreadsheet file
    case File.extname(file.original_filename)
    when '.xls' then Roo::Spreadsheet.open(file.path, extension: :xls)
    when '.xlsx' then Roo::Spreadsheet.open(file.path, extension: :xlsx)
    else raise "Unknown file type: #{file.original_filename}"
    end 
  end

  def self.model_attributes row, arguments
    attributes = row.slice(*valid_attributes(attributes))
    errors = []
    if attributes.length == valid_attributes(attributes).length
      arguments.each do |argument|
        if !attributes[argument].present?
          errors.push "Attribute #{argument} is not present"
        end
      end
    else
      raise "Wrong number of arguments: expected #{valid_attributes(attributes).length} and get #{attributes.length}"
    end
    {attributes: attributes, errors: errors}
  end

  def self.valid_attributes attributes
    #TODO: process atributes
    return attributes
  end

end

class InvalidFileException < Exception; end
class InvalidFileHeaderException < Exception; end
class UnreadableRowException < Exception; end
