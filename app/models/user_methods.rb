RSA_KEY_BITS = 2048

def current_user
  @current_user ||= session[:access_token] && User.find_by(token: session[:access_token])
end

def create_new_user(about_user, auth_token)
  user = User.find_or_create_by(name: about_user.login,
                                token: auth_token,
                                email: about_user.user[:email])
end

def generate_user_token(access_token)
  rsa_private = OpenSSL::PKey::RSA.generate RSA_KEY_BITS
  rsa_public = rsa_private.public_key
  @auth_token = JWT.encode access_token, rsa_private, 'RS256'
end

def decode_token(access_token)
  decoded_token = JWT.decode access_token, rsa_public
end

def get_octokit_user(auth_token)
  client = Octokit::Client.new(access_token: auth_token)
end
