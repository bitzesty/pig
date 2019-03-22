class Pig::Admin::Manage::AppSettingsController < Pig::Admin::ApplicationController
  respond_to :html
  authorize_resource class: 'Pig::AppSettings'

  def show
    @settings = Pig::AppSettings.first_or_create
  end

  def update
    @settings = Pig::AppSettings.first_or_create
    @settings.attributes = settings_params

    if @settings.save
      flash[:notice] = "Settings successfully updated"
    end

    respond_with @settings, location: [pig, :admin, :manage, :settings]
  end

  private

  def settings_params
    params.require(:app_settings).permit(:google_optimize)
  end
end
