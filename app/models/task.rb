class Task < ActiveRecord::Base
  attr_accessor :no_stop_from_previous_on_now
  validates_datetime :start, :on_or_after => '2000-01-01T08:00:00-0600'
  validates_datetime :stop,  :on_or_before => 3.months.from_now #, :allow_blank => true
  validate :valid_stop

  def initial
    self.no_stop_from_previous_on_now = false  
  end

  def now
    self.stop = Time.now
    if self.start.blank?
#      previous_task = Task.first(:order => "start DESC", :conditions => ["stop <= ? AND stop IS NOT NULL", Time.zone.now])
      previous_task = Task.first(:order => "start DESC", :conditions => ["stop <= ?", Time.now])
    end
    if previous_task && !previous_task.stop.blank?
      self.start = previous_task.stop
      self.no_stop_from_previous_on_now = false
    else
      self.start = Time.now
      self.no_stop_from_previous_on_now = true
    end
  end

  def valid_stop
    if !stop.blank? && Time.parse(stop.to_s) < Time.parse(start.to_s)
#    if !stop.blank? && stop < start
      errors.add :stop, 'needs to be greater than start.'
    end
  end

end
