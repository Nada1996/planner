require 'spec_helper'

describe 'reminders:workshop' do
  include_context 'rake'

  its(:prerequisites) { should include('environment') }
  let!(:workshop) { Fabricate(:workshop, date_and_time: Time.zone.now + 29.hours) }

  before do
    allow(STDOUT).to receive(:puts)
  end

  it 'should gracefully run' do
    expect { subject.invoke }.to_not raise_error
  end

  it 'sends out reminders' do
    invitation_manager = InvitationManager.new
    expect(InvitationManager).to receive(:new).and_return(invitation_manager)
    expect(invitation_manager).to receive(:send_workshop_attendance_reminders).with(workshop)

    expect(InvitationManager).to receive(:new).and_return(invitation_manager)
    expect(invitation_manager).to receive(:send_workshop_waiting_list_reminders).with(workshop)

    subject.invoke
  end
end
