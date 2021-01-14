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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210113133704) do

  create_table "notices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "title",                                       comment: "标题"
    t.text     "doc",              limit: 65535,              comment: "公告内容"
    t.integer  "status",                                      comment: "状态"
    t.boolean  "is_first",                                    comment: "是否置顶"
    t.integer  "order_no",                                    comment: "排序"
    t.integer  "create_user_id",                              comment: "创建人"
    t.integer  "create_user_name",                            comment: "创建时间"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "opinions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "title",                                       comment: "标题"
    t.text     "doc",              limit: 65535,              comment: "公告内容"
    t.integer  "status",                                      comment: "状态"
    t.boolean  "is_first",                                    comment: "是否置顶"
    t.integer  "order_no",                                    comment: "排序"
    t.integer  "create_user_id",                              comment: "建议人ID"
    t.integer  "create_user_name",                            comment: "建议人"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "stream_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "stream_id"
    t.string   "live_name",                 comment: "直播名称"
    t.integer  "start_time",                comment: "开始时间"
    t.integer  "end_time",                  comment: "结束时间"
    t.string   "client_iP",                 comment: "客户端IP"
    t.string   "server_iP",                 comment: "服务端IP"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "fname",                     comment: "直播保存的文件的名称"
    t.string   "persistentID",              comment: "直播保存的文件的ID"
  end

  create_table "streams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",                    comment: "流名字"
    t.string   "live_name",               comment: "直播名称"
    t.datetime "start_time",              comment: "开始时间"
    t.datetime "end_time",                comment: "结束时间"
    t.string   "push_url",                comment: "推流地址"
    t.string   "pull_url",                comment: "拉流地址"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "login_name",                        comment: "登录名"
    t.string   "real_name",                         comment: "实际名称"
    t.string   "openid",                            comment: "微信ID"
    t.string   "wx_name"
    t.string   "authentication_token"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

end
