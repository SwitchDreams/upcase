Then 'I see the course resource page for "$course_name"' do |course_name|
  page.should have_content(course_name)
  page.should have_content('Resources')
end

Then 'I see the admin listing include a course named "$course_name"' do |course_name|
  page.should have_content(course_name)
end

Then 'I see the course named "$course_name"' do |course_name|
  course = Course.find_by_name!(course_name)
  page.should have_css("##{dom_id(course)}")
end

When 'I fill in the required course fields' do
  steps %{
    When I fill in the course name with "Test-Driven Haskell"
    And I fill in the course description with "Learn Haskell the thoughtbot way"
    And I fill in the course price with "1900"
    And I fill in the start time with "09:00"
    And I fill in the end time with "17:00"
    And I fill in the location with "41 Winter St 02108"
  }
end

Then 'I see the following questions:' do |question_table|
  question_table.hashes.each_with_index do |question_hash, index|
    number = index + 1
    steps %{
      Then the question #{number} field should contain "#{question_hash['question']}"
      And the answer #{number} field should contain "#{question_hash['answer']}"
    }
  end
end

World(ActionController::RecordIdentifier)

