module CouchRest
  module Model
    module DocumentQueries
      extend ActiveSupport::Concern

      module ClassMethods

        # Wrapper for the master design documents all method to provide
        # a total count of entries.
        def count
          all.count
        end

        # Wrapper for the master design document's first method on all view.
        def first
          all.first
        end

        # Wrapper for the master design document's last method on all view.
        def last
          all.last
        end

        # Load a document from the database by id
        # No exceptions will be raised if the document isn't found
        #
        # ==== Returns
        # Object:: if the document was found
        # or
        # Nil::
        # 
        # === Parameters
        # id<String, Integer>:: Document ID
        # db<Database>:: optional option to pass a custom database to use
        def get(id, db = database)
          get!(id, db)
        rescue CouchRest::Model::DocumentNotFound
          nil
        end
        alias :find :get

        # Load a document from the database by id
        # An exception will be raised if the document isn't found
        #
        # ==== Returns
        # Object:: if the document was found
        # or
        # Exception
        # 
        # === Parameters
        # id<String, Integer>:: Document ID
        # db<Database>:: optional option to pass a custom database to use
        def get!(id, db = database)
          raise CouchRest::Model::DocumentNotFound if id.blank?
          raise CouchRest::Model::DatabaseNotDefined if db.nil?
          doc = db.get(id) or raise CouchRest::Model::DocumentNotFound
          build_from_database(doc)
        end
        alias :find! :get!

      end

    end
  end
end
