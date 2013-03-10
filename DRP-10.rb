# -*- encoding: utf-8 -*-
class BankAccount
  attr_reader :balance

  def initialize(starting_balance=0)
    @balance = starting_balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end

require 'etc'
class BankAccountProxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end
  def deposit(amount)
    check_access
    return @subject.deposit(amount)
  end

  def withdraw(amount)
    check_access
    return @subject.withdraw(amount)
  end

  def balance
    check_access
    return @subject.balance
  end
  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access acount."
    end
  end
end
class VirtualAccountProxy
  def initialize(&creation_block)
    @creation_block = creation_block
  end
  def deposit(amount)
    s = subject
    return s.deposit(amount)
  end
  def withdraw(amount)
    s = subject
    return s.withdraw(amount)
  end
  def balance
    s = subject
    return s.balance
  end
  def subject
    @subject || (@subject = @creation_block.call)
  end
end

class AccountProxy
  def initialize(real_account)
    @subject =real_account
  end
  def method_missing(name, *args)
    puts("Delegating #{name} message to subject.")
    @subject.send(name, *args)
  end
end

class AccountProtectionProxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end
  def method_missing(name, *args)
    check_access
    @subject.send(name, *args)
  end
  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access acount."
    end
  end
end

account = VirtualAccountProxy.new {BankAccount.new(10)}
account.deposit(100)
account.withdraw(50)
p account.balance

ap = AccountProxy.new(BankAccount.new(100) )
ap.deposit(25)
ap.withdraw(50)
puts("account blance is now: #{ap.balance}")

s = AccountProtectionProxy.new("a simple string", 'fred')
puts("The length of the string is #{s.length}")