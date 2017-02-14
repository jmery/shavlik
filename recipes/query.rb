require 'dbi'
# Replace MY_DSN with the name of your ODBC data
# source. Replace and dbusername with dbpassword with
# your database login name and password.

puts 'Connectiong to database.....'

DBI.connect("DBI:ODBC:Driver={SQL Server};Server=shavlik;Database=Protect;Trusted_Connection=Yes") do |dbh|
  puts 'Connected.  Querying....'
  dbh.select_all('select * from Reporting.Machine') do |row|
    puts "Result:  #{row}"
  end
end
