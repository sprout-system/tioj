class AddSoftDeadlineSettingToContestProblemJoint < ActiveRecord::Migration[7.0]
  def change
    add_column :contest_problem_joints, :soft_deadline, :datetime, default: '1970-01-01 00:00:00+00:00'
    add_column :contest_problem_joints, :regular_multiplier, :decimal, default: '1.0'
    add_column :contest_problem_joints, :soft_deadline_multiplier, :decimal, default: '1.0'
  end
end
