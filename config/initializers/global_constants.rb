KEYS_DEFAULT = 10
KEYS_LIMIT = 100
SHARES_LIMIT = 9
DEFAULT_SSSN = 5
DEFAULT_SSSK = 3
MYENV = `hostname`[0..-2] 
PI = (MYENV == 'raspberrypi')
DEV = (Rails.env=='development')
PROD = (Rails.env=='production')
TEST = (Rails.env=='test')
HEROKU = (Rails.root.to_path=="/app")
COPY = PI || TEST
AJAXON = true
DEBUG = false
HOT = ConnectionHelper::internet_connection?
PBKDF2_ITERATIONS = (if PI && PROD then 1000000 else 10 end)
ENCRYPTION_LIBRARY = CryptoHelper::check_pbkdf2
ID = rand(100000..999999)
FLASH_DELAY_SECONDS = (if PI then 5 else 3 end)
FLASH_FADE_SECONDS = 2
PBKDF_ALERT_DELAY_SECONDS = (if PI then 3 else 1 end)
VERSION = 10