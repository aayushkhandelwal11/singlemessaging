Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '156999824439494', '37f0e5f37674a94dec2c326689917495'
  provider :twitter, 'pi62ZO29grZw06oOGpufsg', 'DClVRTCauIvYs0XPWCF9KOxZPkkiiEovPACc59kjQ'
  provider :linkedin, 'wxl71pe9mwjl', 'eDRQHAoh1PSeyvku'
  provider :yahoo, 'dj0yJmk9VWdDUGFPTDFZUWtEJmQ9WVdrOVRVeFhXbnAwTkhVbWNHbzlOVEE0TmpBMk9EWXkmcz1jb25zdW1lcnNlY3JldCZ4PWM5', '3fc2de18c4be7499c6543ecf289df0a2d7d13a4b'
  #provider :google, '659783603094-3ivcr3tk5b88mtqlmeoolh266rp4as7q.apps.googleusercontent.com', '8fMqrs-HUot33MzWfgI6Q-Ia'
end