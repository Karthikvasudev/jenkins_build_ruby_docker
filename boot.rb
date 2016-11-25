$LOAD_PATH.unshift("./")

require "sequel"
require "dotenv"

Dotenv.load

connection_string = ENV["DATABASE_URL"]

DB = Sequel.connect(connection_string)

require "application"
