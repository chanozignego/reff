class SpreadsheetManager
  def self.import file, attributes
    result = {}
    result[:rows] = []
    result[:errors] = {}
    begin
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
    rescue Exception => e 
      puts e.message
      result[:errors][:file] = "Invalid file. Could not read file"
      return result
    end
    #TODO: hay que agregar un rescue por si tiene solo el header
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row.present?
        begin
          result = model_attributes(row, attributes)
          if result.present?
            result[:rows].push("#{i}": result) #TODO: el formato tiene que ser 1: {attributes: {}, errors: {}}
          else
            result[:rows].push("#{i}": {attributes: {}, errors: {file: "Invalid file header. Could not read header"}})
          end
        rescue => ex
          result[:rows].push("#{i}": {attributes: {}, errors: {file: "Wrong number of arguments"}}) #????????? seguro??
        end
      else
        result[:rows].push("#{i}": {attributes: {}, errors: {row: "Invalid row. Could not read row"}}) #????????? seguro??
      end
    end
    
    result
  end

  #def self.import file
  #  result = {}
  #  result[:rows] = []
  #  result[:errors] = {}
  #end

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