class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def approve_deny
    if params[:approved]
      PetApplication.where(      application_id: params[:id],       pet_id: params[:pet_id]).first.update(      status: "Approved")
    elsif params[:rejected]
      PetApplication.where(      application_id: params[:id],       pet_id: params[:pet_id]).first.update(      status: "Rejected")
      # Application.first.status = "Rejected"
      # require 'pry';binding.pry
    end

    redirect_to("/admin/applications/#{params[:id]}")
  end
end
