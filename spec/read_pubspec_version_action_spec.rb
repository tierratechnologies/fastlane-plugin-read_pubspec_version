describe Fastlane::Actions::ReadPubspecVersionAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The read_pubspec_version plugin is working!")

      Fastlane::Actions::ReadPubspecVersionAction.run(nil)
    end
  end
end
