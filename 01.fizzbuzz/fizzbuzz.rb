def fizzbuzz(nums)
  nums.each do |num|
    case
    when (num % 15) == 0 then puts "FizzBuzz"
    when (num %  5) == 0 then puts "Buzz"
    when (num %  3) == 0 then puts "Fizz"
    else
      puts num
    end
  end
end

numbers = (1..20)
fizzbuzz(numbers)

