class AddSoftDeadlineToContestProblemJoint < ActiveRecord::Migration[7.0]
  def change
    add_column :contest_problem_joints, :soft_deadline, :string
  end
end
