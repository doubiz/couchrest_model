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

        # Load an array of documents from the database by an arrary of ids
        # No exceptions will be raised if none of the documents were found
        #
        # ==== Returns
        # [Object::] if the document was found
        # or
        # []
        #
        # === Parameters
        # ids<Array>:: Documents IDs
        # db<Database>:: optional option to pass a custom database to use
        def get_bulk(ids, db = database)
          get_bulk!(ids, db)
        rescue CouchRest::Model::DocumentsNotFound
          []
        end
        alias :find_all :get_bulk

        # Load an array of documents from the database by an arrary of ids
        # An exception will be raised if none of the documents were found
        #
        # ==== Returns
        # [Object::] if the document was found
        # or
        # Exception
        #
        # === Parameters
        # ids<Array>:: Documents IDs
        # db<Database>:: optional option to pass a custom database to use
        def get_bulk!(ids, db = database)
          docs = db.all_docs(:keys => ids, :include_docs => true)
          raise CouchRest::Model::DocumentsNotFound if docs.blank?
          docs["rows"].map{|row| build_from_database(row["doc"])}
        end
        alias :find_all! :get_bulk!

      end

    end
  end
end
