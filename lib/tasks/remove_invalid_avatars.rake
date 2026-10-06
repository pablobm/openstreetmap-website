# frozen_string_literal: true

namespace :db do
  desc "Remove invalid avatars from users"
  task :remove_invalid_avatars => :environment do
    chunk_size = ENV["CHUNK_SIZE"]&.to_i || 10_000

    User.joins(:avatar_attachment)
        .in_batches(:of => chunk_size) do |batch|
      ids = batch.ids

      puts "Processing users #{ids.first} to #{ids.last} ..."

      batch.each do |user|
        user.avatar.open do |image|
          unless ImageProcessing::Vips.valid_image?(image)
            puts "Purging invalid image for user #{user.id}"
            user.avatar.purge_later
          end
        end
      end
    end
  end
end
