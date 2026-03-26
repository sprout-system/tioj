# == Schema Information
#
# Table name: contest_problem_joints
#
#  id             :bigint           not null, primary key
#  contest_id     :bigint
#  problem_id     :bigint
#  soft_deadline  :string
#  created_at     :datetime
#  updated_at     :datetime
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
    match = str_to_date_array(soft_deadline).find do |timestamp, _|
      timestamp >= submit_time
    end
    match ? match[1] : 0
  end

  def str_to_date_array(s)
    s.delete(" \t\r\n").scan(/(\d{14}):(\d+(?:\.\d+)?)/).map do |ts_str, val_str|
      [
        DateTime.strptime(ts_str, '%Y%m%d%H%M%S').new_offset('+08:00'),
        val_str.to_f
      ]
    end
  end

end
