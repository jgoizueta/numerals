module RepeatDetector

  # detec digitss repetitions
  def self.detect(digits, min_repetitions=1)
    n = min_repetitions + 1
    for l in 1..(digits.size/n)
      l = digits.size/n + 1 - l
      # l loops from digits.size/n to 1
      # l is the length of the trailing repetition to be check
      # the longest possible repetition to occur at least n times
      # is 1/n of the digits,
      # and the shortest is 1 digit long.
      # Longest repetitions are found first.

      # check the last l digits for n repetitions
      repeating = true
      (2..n).each do |i|
        if digits[-l..-1] != digits[-i*l...-(i-1)*l]
          repeating = false
          break
        end
      end

      if repeating
        # found n-1 repetitions of length l;
        # remove them:
        digits = digits[0...-(n-1)*l]
        # keap index of repetition beginning
        repeat = digits.size - l

        # now iterate over the divisors of l
        # to find sub-repetitions
        for m in 1..l
          if l.modulo(m) == 0
            # m is a divisor of l
            # check if the l-digit repeating sequence
            # is composed of m-digit sub-repetitions
            reduce_l = true
            for i in 2..l/m
              if digits[-m..-1] != digits[-i*m...-i*m+m]
                reduce_l = false
                break
              end
            end
            if reduce_l
              # found an m-digit sub-repetition
              l = m
              repeat = digits.size - l
              break
            end
          end
        end

        # now remove innecesary repetitions
        while digits.size >= 2*l && digits[-l..-1] == digits[-2*l...-l]
          repeat -= l
          digits = digits[0...-l]
        end

        break
      end
    end

    if repeat
      # remove zero repetition
      if digits.size == repeat+1 && digits[repeat]==0
        repeat = nil
        digits.pop
      end
    end
    # and remove trailing zeros that may be exposed
    # TODO: review: this may not be needed
    digits.pop while digits[-1]==0 && !digits.empty?

    [digits, repeat]
  end

  # Compute the miniumum number of times the repeated part must
  # apper in a digit sequence so that it is correctly detected
  # with detect_min_rep repeatitions
  def self.min_repeat_count(digits, repeat, detect_min_rep=1)
    if repeat
      n = detect_min_rep
      loop do
        n += 1
        _detected_digits, detected_repeat = detect(
          digits + digits[repeat..-1]*(n-1), detect_min_rep
        )
        if repeat == detected_repeat # && detected_digits == digits
          break
        end
      end
      n
    else
      0
    end
  end

end
