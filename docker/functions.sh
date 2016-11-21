db_host=postgres
db_user=postgres

# Function to wait for a service
function wait_for_service () {
	until nc -z $1 $2 >/dev/null 2>&1; do
	    echo "$(date) - waiting for $1:$2..."
	    sleep 2
	done
}

# Check if a DB exists
function db_exists () {
	return `psql --host=${db_host} --username=${db_user} --dbname=$1 -tAc '' >/dev/null 2>&1`
}

# Create a DB
function create_db () {
	psql --host=${db_host} --username=${db_user} -c "CREATE DATABASE \"$1\"" >/dev/null 2>&1
	
	if [ "$1" == "spindle" ]; then
	  echo "$(date) - create hstore extension for spindle"
	  psql --host=${db_host} --username=${db_user} --dbname=$1 -c "CREATE EXTENSION \"hstore\"" >/dev/null 2>&1
	fi
}

# Function to wait for a schema to be ok
function wait_for_schema () {
	echo "$(date) - waiting for the schema version $3 for $1"
	until db_exists $1; do
		echo "$(date) - waiting for the DB $1"
		sleep 2
	done
	until psql --host=${db_host} --username=${db_user} --dbname=$1 -q -c "SELECT \"version\" FROM \"_version\" WHERE \"ident\"='$2';" | grep "$3" >/dev/null 2>&1; do
		echo "$(date) - waiting for the schema version $3 for $1"
		sleep 2
	done	
}
