require 'yaml'
require 'bcrypt'

config = YAML::load_file(File.join(__dir__, 'users-prod.yml'))

config.each do |k, v|
    # sort each group (development, production) and remove duplicates
    users = config[k]['users'] = config[k]['users'].sort_by{|hsh| hsh["username"]}.uniq {|e| e["username"]}

    # hash their passwords and store it on a field called password_digest
    users.each do |e|
        e["password_digest"] = BCrypt::Password.create(e["password"]).to_s#[1..-1]
	e.delete("password")
    end
end

File.open(File.join(__dir__, "mod.yaml"), "w+") {|f| YAML.dump(config, f)}
#File.open(File.join(__dir__, "mod.yaml"), "w+") {|f| f.write(config.to_yaml)}
