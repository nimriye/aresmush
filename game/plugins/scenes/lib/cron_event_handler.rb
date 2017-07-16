module AresMUSH
  module Scenes
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("scenes", "room_cleanup_cron")
        if Cron.is_cron_match?(config, event.time)
          clear_rooms
        end
        
        config = Global.read_config("scenes", "unshared_scene_cleanup_cron")
        if Cron.is_cron_match?(config, event.time)
          delete_unshared_scenes
        end
      end

      def clear_rooms
        rooms = Room.all.select { |r| !!r.scene_set || !!r.scene || !r.scene_nag}
        rooms.each do |r|
          if (r.clients.empty?)
            if (r.scene_set)
              r.update(scene_set: nil)
            end
            
            if (!r.scene_nag)
              r.update(scene_nag: true)
            end
            
            if (stop_empty_scene(r))
              Global.logger.debug("Stopping scene in #{r.name}")
              Scenes.stop_scene(r.scene)
            end
          end
        end
      end
      
      def delete_unshared_scenes
        # Completed scenes that haven't been shared are deleted after a few days.
        Scene.all.select { |s| s.completed && !s.shared }.each do |scene|
          elapsed_days = DateTime.now.to_date - scene.date_completed
          if (elapsed_days > 10)
            Global.logger.info "Deleting scene #{scene.id} - #{scene.title} completed #{scene.date_completed}"
            #scene.delete
          elsif (elapsed_days > 5 && !scene.deletion_warned)
            message = t('scenes.scene_delete_warn', :id => scene.id, :title => scene.title)
            #Mail.send_mail(scene.all_participant_names, t('scenes.scene_delete_warn_subject'), message, nil)
            Mail.send_mail([Character.find_one_by_name("Faraday")], t('scenes.scene_delete_warn_subject'), message, nil)
            scene.update(deletion_warned: true)
          end
        end
      end
      
      def stop_empty_scene(room)
        return false if !room.scene
        return true if room.characters.empty?
        return room.scene.temp_room
      end
    end
  end
end