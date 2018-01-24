require 'open-uri'

module AresMUSH
  module Website
    
    class FileUpdateRequestHandler
      def handle(request)
        enactor = request.enactor
        path = request.args[:path]
        name = (request.args[:new_name] || "").downcase
        folder = request.args[:new_folder]
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: "You must be approved to update files." }
        end
        
        name = AresMUSH::Website::FilenameSanitizer.sanitize name
        folder = AresMUSH::Website::FilenameSanitizer.sanitize folder
        
        path = File.join(AresMUSH.website_uploads_path, path)
        new_folder_path = File.join(AresMUSH.website_uploads_path, folder)
        new_path = File.join(new_folder_path, name)
        
        if (!File.exists?(path))
          return { error: "That file does not exist." }
        end
        
        if (File.exists?(new_path))
          return { error: "That folder/file name is already used." }
        end
        
        if (folder && folder.downcase == "theme_images" && !enactor.is_admin?)
          return { error: "Only admins can update the theme images folder." }
        end
        
        if (!Dir.exist?(new_folder_path))
          Dir.mkdir(new_folder_path)
        end
        
        FileUtils.mv(path, new_path)
        
        {
          path: new_path.gsub(AresMUSH.website_uploads_path, ''),
          name: name
        }
      end
    end
  end
end