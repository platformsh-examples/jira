#!/bin/sh

# Load header
. ./header.inc

# Extract database configuration from enviroment
export JIRA_DB_PATH=$(bin/discovery PLATFORM_RELATIONSHIPS database.db.path)
export JIRA_DB_PORT=$(bin/discovery PLATFORM_RELATIONSHIPS database.db.port)
export JIRA_DB_USER=$(bin/discovery PLATFORM_RELATIONSHIPS database.db.username)
export JIRA_DB_PASS=$(bin/discovery PLATFORM_RELATIONSHIPS database.db.password)
export JIRA_DB_HOST=$(bin/discovery PLATFORM_RELATIONSHIPS database.db.host)

# Build JIRA specific database variabes
export JIRA_DB_TYPE=postgresql
export JIRA_DB_DRIVER=postgres72
export JIRA_DB_CLASS="org.postgresql.Driver"
export JIRA_DB_URL="jdbc:${JIRA_DB_TYPE}://${JIRA_DB_HOST}:${JIRA_DB_PORT}/${JIRA_DB_PATH}"

# Generate a databse configuration
cat << EOF > ${JIRA_HOME}/dbconfig.xml
<?xml version="1.0" encoding="UTF-8"?>

<jira-database-config>
  <name>defaultDS</name>
  <delegator-name>default</delegator-name>
  <database-type>${JIRA_DB_DRIVER}</database-type>
  <schema-name>public</schema-name>
  <jdbc-datasource>
    <url>${JIRA_DB_URL}</url>
    <driver-class>${JIRA_DB_CLASS}</driver-class>
    <username>${JIRA_DB_USER}</username>
    <password>${JIRA_DB_PASS}</password>
    <pool-min-size>20</pool-min-size>
    <pool-max-size>20</pool-max-size>
    <pool-max-wait>30000</pool-max-wait>
    <validation-query>select 1</validation-query>
    <min-evictable-idle-time-millis>60000</min-evictable-idle-time-millis>
    <time-between-eviction-runs-millis>300000</time-between-eviction-runs-millis>
    <pool-max-idle>20</pool-max-idle>
    <pool-remove-abandoned>true</pool-remove-abandoned>
    <pool-remove-abandoned-timeout>300</pool-remove-abandoned-timeout>
    <pool-test-on-borrow>false</pool-test-on-borrow>
    <pool-test-while-idle>true</pool-test-while-idle>
  </jdbc-datasource>
</jira-database-config>
EOF

