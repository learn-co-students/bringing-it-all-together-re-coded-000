class Dog
attr_accessor :name , :breed
attr_reader :id
def initialize(id: nil, name:, breed:)
@id=id
@name=name
@breed=breed
end
# **********************************
def self.create_table
sql =  <<-SQL
CREATE TABLE IF NOT EXISTS dogs (
id INTEGER PRIMARY KEY,
name TEXT,
breed TEXT
)
SQL
DB[:conn].execute(sql)
end
# **********************************
def self.drop_table
quri="DROP TABLE dogs"
DB[:conn].execute(quri)
end
# **********************************
def save
if self.id
self.update
else
quri= <<-SQL
INSERT INTO dogs(name,breed)
VALUES (?,?)
SQL
DB[:conn].execute(quri,self.name,self.breed)
@id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
self
end
end
# **********************************
def self.create(name:, breed:)
dog=self.new(name:name, breed:breed)
dog.save
dog
end
# **********************************
def self.find_by_id(id)
quri = "SELECT * FROM dogs WHERE id = ? "
dog = DB[:conn].execute(quri,id)[0]
new_from_db(dog)
end
# **********************************
def self.find_or_create_by(name:,breed:)
dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
if !dog.empty?
dog_data = dog[0]
dog = self.new_from_db(dog_data)
else
dog = self.create(name: name, breed: breed)
end
dog
end
# **********************************
def self.new_from_db(row)
dog = self.new(id: row[0], name: row[1], breed: row[2])
end
# **********************************
def self.find_by_name(name)
quri = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? LIMIT 1", name)[0]
new_from_db(quri)
end
# **********************************
def update
DB[:conn].execute("UPDATE dogs SET name = ?, breed = ? WHERE id = ?", self.name, self.breed, self.id)
end
# **********************************
end
