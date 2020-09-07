class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    return new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    array_of_rows = DB[:conn].execute(sql)

    array_of_rows.map { |row|
      self.new_from_db(row)
    }
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"

    array_of_rows = DB[:conn].execute(sql)
    self.many_from_db(array_of_rows)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade <= 11"
    array_of_rows = DB[:conn].execute(sql)
    self.many_from_db(array_of_rows)
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10
    LIMIT ?
    SQL
    array_of_rows = DB[:conn].execute(sql, x)
    self.many_from_db(array_of_rows)
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL
    array_of_rows = DB[:conn].execute(sql,grade)
    self.many_from_db(array_of_rows)
  end

  def self.many_from_db(array_of_rows)
    array_of_rows.map { |row|
      self.new_from_db(row)
    }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    LIMIT 1
    SQL

    # self.new_from_db(DB[:conn].execute(sql, name))
    array_of_rows = DB[:conn].execute(sql, name)
    self.new_from_db(array_of_rows[0])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
