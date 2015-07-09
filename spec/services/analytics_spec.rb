require "rails_helper"

describe Analytics do
  describe "#track_updated" do
    it "sends updated identify event to backend" do
      user = build_stubbed(:user)
      user_analytics = Analytics.new(user)

      user_analytics.track_updated

      expect(analytics).to have_identified(user).
        with_properties(user_analytics.identify_hash(user))
    end
  end

  describe "#track_status_created" do
    context "with Exercise object" do
      it "does not create analytics event" do
        user = build_stubbed(:user)
        user_analytics = Analytics.new(user)
        exercise = build_stubbed(:exercise)

        user_analytics.track_status_created(exercise, Status::IN_PROGRESS)

        expect(analytics.tracked_events_for(user)).to be_empty
      end
    end

    context "with Video object" do
      it "tracks started video event if state is In Progress" do
        user = build_stubbed(:user)
        user_analytics = Analytics.new(user)
        video = build_stubbed(:video)

        user_analytics.track_status_created(video, Status::IN_PROGRESS)

        expect(analytics).to have_tracked("Started video").
          for_user(user).
          with_properties(video_slug: video.slug)
      end

      it "tracks finished video event if state is Complete" do
        user = build_stubbed(:user)
        user_analytics = Analytics.new(user)
        video = build_stubbed(:video)

        user_analytics.track_status_created(video, Status::COMPLETE)

        expect(analytics).to have_tracked("Finished video").
          for_user(user).
          with_properties(video_slug: video.slug)
      end
    end
  end
end
