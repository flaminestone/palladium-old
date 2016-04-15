require 'testing_shared'
describe 'Multiplication' do
  (1..10).to_a.each do |i|
    describe 'Correct' do
      (1..100).to_a.each do |current_element_second|
        it "#{current_element_second}" do
          @palladium = PalladiumApiShell.new(product_name: 'CDE',
                                             plan_name: 'plan_6',
                                             run_name: "Multiplication Tests_#{i}",
                                             host: StaticData::HOST,
                                             login: StaticData::LOGIN,
                                             token: StaticData::TOKEN)
          expect(current_element_second*2).to eq(current_element_second*2)
        end
      end
      after :each do |example|
        AfterTests.new(@palladium, example).set_result
      end
    end
  end
end