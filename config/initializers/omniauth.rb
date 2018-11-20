Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "177737047075-7tdhar82r1423njkurs5jdes3mg77qac.apps.googleusercontent.com", "5pLPP32gmIJ-vT8_G73TIj0Q"
end