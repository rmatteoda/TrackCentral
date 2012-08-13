# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120813130207) do

  create_table "actividads", :force => true do |t|
    t.string   "tipo"
    t.integer  "vaca_id"
    t.integer  "valor"
    t.datetime "registrada"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "alarmas", :force => true do |t|
    t.string   "tipo"
    t.integer  "vaca_id"
    t.integer  "nodo_id"
    t.datetime "registrada"
    t.integer  "horas_de_valides"
    t.string   "mensaje"
    t.boolean  "vista"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "celos", :force => true do |t|
    t.integer  "vaca_id"
    t.datetime "comienzo"
    t.string   "probabilidad"
    t.string   "causa"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "nodos", :force => true do |t|
    t.integer  "bateria"
    t.integer  "vaca_id"
    t.string   "nodo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sucesos", :force => true do |t|
    t.string   "tipo"
    t.integer  "vaca_id"
    t.date     "momento"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "celular"
    t.string   "role"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "vacas", :force => true do |t|
    t.integer  "caravana"
    t.string   "raza"
    t.string   "estado"
    t.string   "nodo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
