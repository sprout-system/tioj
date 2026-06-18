class AddColorToContestProblemJoint < ActiveRecord::Migration[7.0]
  def change
    add_column :contest_problem_joints, :color, :string, default: '#34495E'
  end
end
