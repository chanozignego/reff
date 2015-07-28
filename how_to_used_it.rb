  collection_action :import_guests, method: :post do 
    file = params[:guest][:file] 
    date = params[:guest][:date]
    event = params[:guest][:rrpp_event_id] 
    if !file.present?
      flash[:error] = I18n.t(".errors.no_file")
      @error_messages = I18n.t(".errors.no_file")
    else
      begin
        result = SpreadsheetManager.import(file, date, event)
        flash[:notice] = I18n.t(".notifications.import_success") + " " + result[:valid_guests].length.to_s + " " + I18n.t(".activerecord.models.guest.other") if result[:valid_guests].length > 0
        if result[:not_valid_guests].length > 0
           errors = []
           error = I18n.t(".errors.import") + " " 
           error += result[:not_valid_guests].length.to_s + " " 
           error += I18n.t(".activerecord.models.guest.other") + ". "
           error += I18n.t(".errors.import_models") + " " + I18n.t(".activerecord.models.guest.other") + ": "
           errors.push(error)
           result[:not_valid_guests].each do |r|
            error = I18n.t(".row") + ": " + r[:row].to_s #r[:user].to_s + " " + I18n.t(".row") + ": " + r[:row].to_s
            error += " " + I18n.t(".reason") + ": " + r[:error]
            errors.push(error)
           end
           error = I18n.t(".errors.import_further_instructions")
           errors.push(error)
          @error_messages = errors.join("<br/>").html_safe
        end
      rescue => e
        flash[:error] = I18n.t(".errors.invalid_file_type")
        render(create_from_archive_admin_guests_path)
        return
      end
    end   
    @error_messages.blank? ? redirect_to(admin_guests_path, notice: I18n.t("active_admin.correct_import")) : render(create_from_archive_admin_guests_path)
  end

  collection_action :template, method: :get do
      @attributes = SpreadsheetManager.valid_attributes
      respond_to do |format|
        format.xlsx{
            response.headers["Content-Disposition"] = 'attachment; filename="template.xlsx"'
          }
      end
    end
