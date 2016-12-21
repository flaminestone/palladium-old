include ActiveRecord::Tasks
namespace :generate_random_items do

  task :all => :environment do
    Rake::Task['generate_random_items:products'].invoke
    Rake::Task['generate_random_items:plans'].invoke
    Rake::Task['generate_random_items:runs'].invoke
    Rake::Task['generate_random_items:result_sets'].invoke
    Rake::Task['generate_random_items:results'].invoke
  end

  task :products => :environment do
    10.times do |i|
      Product.create(name: "Product#{i}", status: "Status#{i}", version: "Version#{i}")
    end
  end

  task :plans => :environment do
    Product.all.each do |product|
      2.times do |i|
        product.plans << Plan.create(name: "Plan#{i}", version: "Version#{i}")
      end
    end
  end

  task :runs => :environment do
    Plan.all.each do |plan|
      3.times do |i|
        plan.runs << Run.create(name: "Plan#{i}", version: "Version#{i}")
      end
    end
  end

  task :result_sets => :environment do
    Run.all.each do |run|
      5.times do |i|
        run.result_sets << ResultSet.create(name: "Plan#{i}", version: "Version#{i}")
      end
    end
  end

  task :results => :environment do
    ResultSet.all.each do |result_sets|
      2.times do |i|
        result_sets.results << Result.create(message: "Message#{i}", author: "Author#{i}")
        # if Status.find_by_main_status(true)
      end
    end
  end

  task :series => :environment do
    product = Product.create(name: 'Product_series', status: 'Status_series', version: 'Version_series')

    plan1 = Plan.create(name: 'Plan_series1', version: 'Version_series1')
    plan2 = Plan.create(name: 'Plan_series2', version: 'Version_series2')
    product.plans << plan1
    product.plans << plan2

    run1 = Run.create(name: 'Run_series1', version: 'Version_series1')
    run2 = Run.create(name: 'Run_series2', version: 'Version_series2')
    run3 = Run.create(name: 'Run_series3', version: 'Version_series3')
    run4 = Run.create(name: 'Run_series4', version: 'Version_series4')
    plan1.runs << run1
    plan1.runs << run2
    plan2.runs << run3
    plan2.runs << run4
    result_set1 = ResultSet.create(name: 'ResultSet_series1', version: 'Version_series1')
    result_set2 = ResultSet.create(name: 'ResultSet_series2', version: 'Version_series2')
    result_set3 = ResultSet.create(name: 'ResultSet_series3', version: 'Version_series3')
    result_set4 = ResultSet.create(name: 'ResultSet_series4', version: 'Version_series4')
    result_set5 = ResultSet.create(name: 'ResultSet_series5', version: 'Version_series5')
    result_set6 = ResultSet.create(name: 'ResultSet_series6', version: 'Version_series6')
    result_set7 = ResultSet.create(name: 'ResultSet_series7', version: 'Version_series7')
    result_set8 = ResultSet.create(name: 'ResultSet_series8', version: 'Version_series8')
    run1.result_sets << result_set1
    run1.result_sets << result_set2
    run2.result_sets << result_set3
    run2.result_sets << result_set4
    run3.result_sets << result_set5
    run3.result_sets << result_set6
    run4.result_sets << result_set7
    run4.result_sets << result_set8

    result1 = Result.create(message: 'Message_series1', author: 'Author_series1')
    result2 = Result.create(message: 'Message_series2', author: 'Author_series2')
    result3 = Result.create(message: 'Message_series3', author: 'Author_series3')
    result4 = Result.create(message: 'Message_series4', author: 'Author_series4')
    result5 = Result.create(message: 'Message_series5', author: 'Author_series5')
    result6 = Result.create(message: 'Message_series6', author: 'Author_series6')
    result7 = Result.create(message: 'Message_series7', author: 'Author_series7')
    result8 = Result.create(message: 'Message_series8', author: 'Author_series8')
    result9 = Result.create(message: 'Message_series9', author: 'Author_series9')
    result10 = Result.create(message: 'Message_series10', author: 'Author_series10')
    result11 = Result.create(message: 'Message_series11', author: 'Author_series11')
    result12 = Result.create(message: 'Message_series12', author: 'Author_series12')
    result13 = Result.create(message: 'Message_series13', author: 'Author_series13')
    result14 = Result.create(message: 'Message_series14', author: 'Author_series14')
    result15 = Result.create(message: 'Message_series15', author: 'Author_series15')
    result16 = Result.create(message: 'Message_series16', author: 'Author_series16')
    status = Status.create(name: 'Failed', color: '#FFAAAA')
    status1 = Status.create(name: 'Passed', color: '#00FF00')

    status.results << result1
    status1.results << result2
    status.results << result3
    status1.results << result4
    status.results << result5
    status1.results << result6
    status.results << result7
    status1.results << result8
    status.results << result9
    status1.results << result10
    status.results << result11
    status1.results << result12
    status.results << result13
    status1.results << result14
    status1.results << result14
    status1.results << result15
    status.results << result16


    result_set1.results << result1
    result_set1.results << result2
    result_set2.results << result3
    result_set2.results << result4
    result_set3.results << result5
    result_set3.results << result6
    result_set4.results << result7
    result_set4.results << result8
    result_set5.results << result9
    result_set5.results << result10
    result_set6.results << result11
    result_set6.results << result12
    result_set7.results << result13
    result_set7.results << result14
    result_set8.results << result15
    result_set8.results << result16
  end

  task :only_one => :environment do
    result1 = Result.create(message: 'Message_series1only_one', author: 'Author_series1only_one')
    result2 = Result.create(message: 'Message_series1only_one', author: 'Author_series1only_one')
    result3 = Result.create(message: 'Message_series1only_one', author: 'Author_series1only_one')
    main_status = Status.find_by_main_status(true)
    main_status.results << result1
    main_status.results << result2
    main_status.results << result3
    result_set1 = ResultSet.create(name: 'ResultSet_series1', version: 'Version_series1')
    result_set1.results << result1
    result_set1.results << result2
    result_set1.results << result3
    Run.last.result_sets << result_set1
  end

  task :new_result_to_last_set => :environment do
    result1 = Result.create(message: 'Message_series1only_one', author: 'Author_series1only_one')
    Status.last.results << result1
    ResultSet.last.results << result1
  end

  task :new_result_set_to_last_run => :environment do
    result1 = Result.create(message: 'Message_series1only_one', author: 'Author_series1only_one')
    Status.find(3).results << result1
    result_set = ResultSet.create(name: 'ResultSet_series1', version: 'Version_series1')
    Run.last.result_sets << result_set
    result_set.results << result1
  end

  task :new_run_to_last_plan => :environment do
    result1 = Result.create(message: 'Message_series1only_one', author: 'Author_series1only_one')
    Status.last.results << result1
    result_set = ResultSet.create(name: 'ResultSet_series1', version: 'Version_series1')
    run1 = Run.create(name: 'Run_series1', version: 'Version_series1')
    run1.result_sets << result_set
    result_set.results << result1
    Plan.last.runs << run1
  end

  task :new_plan_to_last_product => :environment do

    plan = Plan.create(name: 'Plan_series1', version: 'Version_series1')
    Product.last.plans << plan
    run1 = Run.create(name: 'Run_series1', version: 'Version_series1')
    plan.runs << run1
    result_set = ResultSet.create(name: 'ResultSet_series1', version: 'Version_series1')
    run1.result_sets << result_set
    result1 = Result.create(message: 'Message_series1only_one', author: 'Author_series1only_one')
    Status.find(1).results << result1
    result_set.results << result1
  end


  task :delete_last_result => :environment do
    Result.last.delete
  end
end

namespace :delete_all do
  task :all => :environment do
    Product.delete_all
    Plan.delete_all
    Run.delete_all
    ResultSet.delete_all
    Result.delete_all
    # Status.delete_all
  end
end
