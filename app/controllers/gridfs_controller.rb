class GridfsController < ActionController::Metal
        def serve
                doc_id = params[:fid]
                puts "ffffffffffffffffffffffffffffffffffffffffff"
                begin
                        document = ProjectAsset.find(doc_id)

                        if document.nil? || document.attachment.nil?
                                raise Exception.new("Unable to find document with id #{doc_id}")
                        end

                        filename = Pathname.new(env['PATH_INFO']).basename.to_s
                        version = filename.include?('_') ? filename.split('_')[0] : nil

                        gridfs_file = document.attachment.file_version(version)
                        gridfs_file = document.attachment.file if gridfs_file.nil? || gridfs_file.length.nil?

                        self.headers['Content-Length'] = gridfs_file.content_length.to_s
                        self.headers['Expires'] = 1.year.from_now.httpdate
                        self.response_body = gridfs_file.read
                        self.content_type = gridfs_file.content_type
                rescue Exception => e
                        self.status = :file_not_found
                        self.content_type = 'text/plain'
                        self.response_body = e.message
                end
        end
end