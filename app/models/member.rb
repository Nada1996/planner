class Member < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :session_invitations
  has_many :auth_services

  validates :auth_services, presence: true
  validates :name, :surname, :email, :about_you, presence: true, if: :can_log_in?
  validates_uniqueness_of :email

  scope :students, -> { joins(:roles).where(:roles => { :name => 'Student' }) }
  scope :coaches, -> { joins(:roles).where(:roles => { :name => 'Coach' }) }
  scope :admins, -> { joins(:roles).where(:roles => { :name => 'Admin' }) }

  attr_accessor :attendance

  def full_name
    [name, surname].join " "
  end

  def avatar size=100
    "http://gravatar.com/avatar/#{md5_email}?s=#{size}"
  end

  def attended_sessions
    session_invitations.attended.map(&:sessions)
  end

  def requires_additional_details?
    can_log_in? && !valid?
  end


  private

  def md5_email
    Digest::MD5.hexdigest(email.strip.downcase)
  end
end
