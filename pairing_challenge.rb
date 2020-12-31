require 'set'

class ClassPairer
  @weeks = []
  @pairs_combinations = []
  @week_combination_result = []
  @week_combination_size = 0
  def initialize(weeks)
    @weeks = weeks
  end

  def display_weeks_pairing
    if @weeks.empty?
      puts 'Weeks is Empty'
      return
    end
    max = @weeks.max
    @pairs_combinations = generate_pair_combinations(max)
    week_combinations = calculate_weeks_paring(0, @pairs_combinations, [], Set.new)
    if week_combinations.nil?
      puts 'It is difficult compute the student pairing combination'
      return
    end
    week_combinations.each_with_index do |week_comb, index|
      puts "Week #{index + 1}: #{week_comb}"
    end
  end

  private

  def generate_pair_combinations(val)
    arr = []
    (1...val).each { |x| arr += generate_pairs(x, val) }
    arr
  end

  def generate_pairs(min, max)
    arr = []
    (min + 1).upto(max) { |val| arr.push([min, val]) }
    arr
  end

  def get_possible_week_combination(pair_array, size, new_students)
    @week_combination_result = []
    @week_combination_size = size
    possible_week_combination(0, pair_array, [], Set.new, new_students)
    @week_combination_result
  end

  def add_combination_to_result(combination, priority_set)
    if priority_set.nil? || priority_set.empty?
      @week_combination_result.push(combination)
      return
    end
    combination_set = Set.new(combination.flatten)
    intersection = combination_set & priority_set
    @week_combination_result.push(combination) if intersection == priority_set
  end

  def possible_week_combination(index, arr, accumulated, set, priority_set)
    add_combination_to_result(accumulated, priority_set) if accumulated.length == @week_combination_size
    index.upto(arr.length - 1) do |x|
      if !set.include?(arr[x][1]) && !set.include?(arr[x][0])
        possible_week_combination(x + 1, arr, [*accumulated, arr[x]], Set[*set, *arr[x]], priority_set)
      end
    end
  end

  def select_week_pairs_and_students(week_index, pairs)
    current_students = Set[]
    filtered = pairs.select do |ele|
      next false unless ele[0] <= @weeks[week_index] && ele[1] <= @weeks[week_index]

      current_students.merge(ele)
      true
    end
    { students: current_students, pairs: filtered }
  end

  def get_new_students(week_index)
    last_week_student = week_index.zero? ? @weeks[week_index] : @weeks[week_index - 1]
    ((last_week_student + 1)..@weeks[week_index]).to_a
  end

  def process_pairs_for_cycle(pairs, new_students, week_index)
    if pairs.all? { |ele| ele[0] >= @weeks[week_index - 1] || ele[1] >= @weeks[week_index - 1] }
      return { pairs: @pairs_combinations, new_students: Set.new }
    end

    { pairs: pairs, new_students: new_students }
  end

  def calculate_weeks_paring(index, possible_pairs, acc, new_students)
    return acc if index >= @weeks.length

    possible_pairs_and_new_student = process_pairs_for_cycle(possible_pairs, new_students, index)
    possible_pairs = possible_pairs_and_new_student[:pairs]
    new_students = possible_pairs_and_new_student[:new_students]
    new_students.merge(get_new_students(index))
    week_pairs_and_students = select_week_pairs_and_students(index, possible_pairs)
    new_students = week_pairs_and_students[:students] & new_students
    combinations = get_possible_week_combination(week_pairs_and_students[:pairs], @weeks[index] / 2, new_students)
    return nil if !(week_pairs_and_students[:pairs]).empty? && combinations.empty?

    (0...combinations.length).each do |i|
      new_possible_pair = pairs.reject { |ele| combinations[i].include?(ele) }
      weeks_pairing = calculate_weeks_paring(
        index + 1,
        new_possible_pair,
        [*accumulaion, combinations[i]],
        new_students
      )
      return weeks_pairing unless weeks_pairing.nil?
    end
    nil
  end
end

p = ClassPairer.new([4, 4, 0, 5])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([4, 4, 0, 2, 3, 4])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([2, 3, 4, 5, 6])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([8, 8, 8, 8, 8, 8, 8])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([4, 5, 5, 5, 5, 5])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([4, 4, 4, 4])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([8, 8, 8, 8, 8, 8, 8, 9, 9, 5])
p.display_weeks_pairing
p '==========================='
p = ClassPairer.new([])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([5, 6, 7, 4, 6, 8])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 6])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([8, 8, 8, 8, 8, 8, 8, 10, 9, 5])
p.display_weeks_pairing
p '=============================='
p = ClassPairer.new([0])
p.display_weeks_pairing
