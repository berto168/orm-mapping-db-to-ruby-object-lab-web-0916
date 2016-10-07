require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.find_by_name(name)
    student_row = DB[:conn].execute("SELECT * FROM students WHERE students.name = '#{name}';").flatten!
    student = self.new
    student.id = student_row[0]
    student.name = student_row[1]
    student.grade = student_row[2]
    student
  end

  def self.all
    student_array = DB[:conn].execute("SELECT * FROM students")
    student_array.map {|row| self.new_from_db(row)}
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE students.grade = 9;"
    DB[:conn].execute(sql).map {|student_info| self.new_from_db(student_info)}
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE students.grade < 12;"
    DB[:conn].execute(sql).map {|student_info| self.new_from_db(student_info)}
  end

  def self.first_x_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE students.grade = 10 LIMIT #{num};"
    DB[:conn].execute(sql).map {|student_info| self.new_from_db(student_info)}
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE students.grade = 10 LIMIT 1;"
    DB[:conn].execute(sql).map {|student_info| self.new_from_db(student_info)}.first
  end

  def self.all_students_in_grade_x(grade)
    sql = "SELECT * FROM students WHERE students.grade = #{grade};"
    DB[:conn].execute(sql).map {|student_info| self.new_from_db(student_info)}
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
