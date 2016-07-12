module LogInspector
  class Encryptor
    def self.api_token enc_token = nil
      key_base = Rails.application.secrets[:secret_key_base][0..20]
      passphrase = ActiveSupport::KeyGenerator.new(key_base).generate_key(key_base)
      encryptor = ActiveSupport::MessageEncryptor.new(passphrase)

      if enc_token
        ret_v = false
        begin
          ret_v = encryptor.decrypt_and_verify(enc_token) == key_base
        rescue => e
        end
        ret_v
      else
        encryptor.encrypt_and_sign(key_base)
      end
    end
  end
end
