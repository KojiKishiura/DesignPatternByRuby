# -*- encoding: utf-8 -*-

class SimpleWriter
  def initialize(path)
    @file = File.open(path, 'w')
  end
  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end
  def pos
    @file.pos
  end
  def rewind
    @file.rewind
  end
  def close
    @file.close
  end
end

require 'forwardable'
class WriterDecorator
  extend Forwardable
  # メソッドを追加する
  # 第１引数：インスタンスの属性名、それ以降：メソッド名
  # 新しいメソッドは、属性で参照しているオブジェクトに移譲される。
  def_delegators :real_writer, :writer_line, :rewind, :pos, :close

  def initialize(real_writer)
    @real_writer = real_writer
  end
end
# class NumberingWriter < WriterDecorator
#   def initialize(real_writer)
#     super(real_writer)
#     @line_number = 1
#   end

#   def write_line(line)
#     @real_writer.write_line("#{@line_number}: #{line}")
#   end
# end
# class CheckSummingWriter < WriterDecorator
#   attr_reader :check_sum
#   def initialize(real_writer)
#     @real_writer = real_writer
#     @check_sum = 0
#   end
#   def write_line(line)
#     line.each_byte {|byte| @check_sum = (@check_sum + byte) % 256 }
#     @check_sum += "\n"[0].bytesize % 256
#     @real_writer.write_line(line)
#   end
# end
# class TimeStampingWriter < WriterDecorator
#   def write_line(line)
#     @real_writer.write_line("#{Time.new}: #{line}")
#   end
# end

module TimeStampingWriter
  def write_line(line)
    super("#{Time.new}: #{line}")
  end
end
module NumberingWriter
  attr_reader :line_number
  def write_line(line)
    @line_number = 1 unless @line_number
    super("#{@line_number}: #{line}")
    @line_number += 1
  end
end


# writer = NumberingWriter.new(SimpleWriter.new('final.txt'))
# writer.write_line('Hello out there')

# writer = CheckSummingWriter.new(TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new('final.txt'))))
# writer.write_line('Hello out there')

# w = SimpleWriter.new('out1.txt')
# class << w
#   alias old_write_line write_line
#   def write_line(line)
#     old_write_line("#{Time.new}: #{line}")
#   end
# end
# w.write_line('Hello out there')
w = SimpleWriter.new("out2.txt")
w.extend(NumberingWriter)
w.extend(TimeStampingWriter)
w.write_line('Hello')