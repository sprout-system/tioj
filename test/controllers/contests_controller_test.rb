require "test_helper"

class ContestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contest = contests(:one)
    @problem_one = problems(:one)
    @problem_invisible = problems(:invisible)
    [@problem_one, @problem_invisible].each do |problem|
      ContestProblemJoint.create!(contest: @contest, problem: problem)
    end
  end

  def task_tags(problem)
    Problem.find(problem.id).tag_list
  end

  test "admin can add a tag to every task in the contest" do
    sign_in users(:adminOne)
    post batch_update_tags_contest_url(@contest), params: {tag_name: 'dp', operation: 'add'}

    assert_redirected_to contest_path(@contest)
    assert_equal "Successfully added tag 'dp' to all tasks in the contest.", flash[:notice]
    assert_includes task_tags(@problem_one), 'dp'
    assert_includes task_tags(@problem_invisible), 'dp'
  end

  test "admin can remove a tag from every task in the contest" do
    sign_in users(:adminOne)
    [@problem_one, @problem_invisible].each do |problem|
      problem.tag_list.add('dp')
      problem.save
    end

    post batch_update_tags_contest_url(@contest), params: {tag_name: 'dp', operation: 'remove'}

    assert_redirected_to contest_path(@contest)
    assert_equal "Successfully removed tag 'dp' to all tasks in the contest.", flash[:notice]
    assert_not_includes task_tags(@problem_one), 'dp'
    assert_not_includes task_tags(@problem_invisible), 'dp'
  end

  test "tag name is trimmed before being applied" do
    sign_in users(:adminOne)
    post batch_update_tags_contest_url(@contest), params: {tag_name: '  graph  ', operation: 'add'}

    assert_redirected_to contest_path(@contest)
    assert_includes task_tags(@problem_one), 'graph'
    assert_not_includes task_tags(@problem_one), '  graph  '
  end

  test "blank tag name is rejected and leaves tasks unchanged" do
    sign_in users(:adminOne)
    post batch_update_tags_contest_url(@contest), params: {tag_name: '   ', operation: 'add'}

    assert_redirected_to contest_path(@contest)
    assert_equal 'Tag name cannot be blank.', flash[:alert]
    assert_empty task_tags(@problem_one)
    assert_empty task_tags(@problem_invisible)
  end

  test "normal user cannot batch update tags" do
    sign_in users(:userOne)
    post batch_update_tags_contest_url(@contest), params: {tag_name: 'dp', operation: 'add'}

    assert_no_permission
    assert_not_includes task_tags(@problem_one), 'dp'
  end

  test "guests must sign in to batch update tags" do
    post batch_update_tags_contest_url(@contest), params: {tag_name: 'dp', operation: 'add'}

    assert_login_needed
    assert_not_includes task_tags(@problem_one), 'dp'
  end
end
