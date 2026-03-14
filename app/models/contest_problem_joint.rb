# == Schema Information
#
# Table name: contest_problem_joints
#
#  id                       :bigint           not null, primary key
#  contest_id               :bigint
#  problem_id               :bigint
#  soft_deadline            :datetime
#  regular_multiplier       :decimal
#  soft_deadline_multiplier :decimal
#  created_at               :datetime
#  updated_at               :datetime
#
# Indexes
#
#  contest_task_ix  (contest_id,problem_id) UNIQUE
#

class ContestProblemJoint < ApplicationRecord
  default_scope { order('id ASC') }

  belongs_to :contest
  belongs_to :problem

  def get_multiplier(submit_time)
    submit_time <= soft_deadline ? regular_multiplier : soft_deadline_multiplier
  end

end
