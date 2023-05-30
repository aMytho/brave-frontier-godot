extends Node

var db: SQLite
#The path to the DB file
var path: String = ""
#Current DB version
var current_version = 5
#Latest db version
var latest_version = 6

func _ready():
	#Creates a new DB instance
	db = SQLite.new()
	db.verbosity_level = SQLite.VERBOSE
	db.path = set_path()
	
	#Connects to the db
	db.open_db()
	
	#Check for migrations
	migration_check()
	print("Database setup complete!")

func set_path() -> String:
	if OS.is_debug_build():
		return "user://dev.db"
	else:
		return "user://main.db" 

func migration_check():
	#get version
	db.query("PRAGMA user_version;")
	current_version = db.query_result[0]["user_version"]

	if current_version != latest_version:
		#Do the next migration
		migrate(current_version)
		#Check if more need to be done
		migration_check()

func migrate(count):
	print("The database needs a migration. Migrating...")
	#Gets the migration file
	var migration_path = str("res://Database/Migrations/", count, ".sql")
	var migration = FileAccess.open(migration_path, FileAccess.READ).get_as_text()
	
	# Make the migration
	db.query(migration)
	
	#Update to the next version
	var new_version = str("PRAGMA user_version = ", count + 1, ";")
	db.query(new_version)

func query(query_str: String) -> Array:
	db.query(query_str)
	print("Query result: ", db.query_result, " Errors?: ", db.error_message)
	
	#handle errors
	if db.error_message == "" or db.error_message == "not an error":
		return db.query_result
	else:
		print("SQL Error")
		return ["Error", db.error_message]
