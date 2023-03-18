# frozen_string_literal: true

module V1
  module Users
    class SessionsController < Devise::SessionsController
      # before_action :configure_sign_in_params, only: [:create]

      # GET /resource/sign_in
      # def new
      #   super
      # end

      # POST /resource/sign_in
      def create
        self.resource = warden.authenticate(auth_options)

        if resource.present? && sign_in(resource_name, resource)
          render json: resource,
                 serializer: V1::UserSerializer,
                 root: "user",
                 status: :created
        else
          render_errors error_message, status: :unauthorized
        end
      end

      # DELETE /resource/sign_out
      # def destroy
      #   super
      # end

      # protected

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_in_params
      #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
      # end

      private

      def error_message
        translation_key = "devise.failure.#{Devise.paranoid ? 'invalid' : 'not_found_in_database'}"

        I18n.t(translation_key, authentication_keys: DEVISE_AUTHENTICATION_KEY)
      end
    end
  end
end
