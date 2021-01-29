require "json"

class TpLinkRouer
  def initialize(_routerip, _passwd)
    @routerip = _routerip
    @passwd = _passwd
    @acl_cache = {}
    update_acl_cache
  end

  def entry_index(target_mac)
    target_mac = normalize_mac(target_mac)
    read_acl_json["data"].each_with_index do |entry, index|
      entry_mac = entry["mac"].downcase
      puts "mac cpmpare"
      puts entry_mac
      puts target_mac
      if entry_mac == target_mac
        return index
      end
    end
    return -1
  end

  def in_acl?(target_mac)
    acl = @acl_cache
    return false unless acl["data"]
    acl["data"].each do |entry|
      entry_mac = entry["mac"].downcase
      if entry_mac == target_mac
        return true
      end
    end
    return false
  end

  def read_acl_json
    return JSON.parse(read_acl)
  end

  def update_acl_cache
    @acl_cache = read_acl_json
  end

  def read_acl
    `curl --trace tracelog_read_acl -b cokkiejar -XPOST -d "operation=load" "http://#{routerip}/cgi-bin/luci/;stok=#{stok}/admin/access_control?form=black_list"`
  end

  def add_entry(name, target_mac)
    target_mac = normalize_mac(target_mac)
    `curl --trace tracelog_add -b cokkiejar -XPOST -d "operation=insert&key=add&index=0&old=add&new=%7B%22name%22%3A%22%22%2C%22mac%22%3A%22#{target_mac}%22%7D" "http://#{routerip}/cgi-bin/luci/;stok=#{stok}/admin/access_control?form=black_list"`
  end

  def delete_entry_with_index(index)
    if index == -1 
      puts "ERROR: with index is -1"
      return
    end
    `curl --trace tracelog_add -b cokkiejar -XPOST -d "operation=remove&key=key-#{index}&index=#{index}" "http://#{routerip}/cgi-bin/luci/;stok=#{stok}/admin/access_control?form=black_list"`
  end

  def delete_entry(target_mac)
    delete_entry_with_index(entry_index(target_mac))
  end

protected

  def normalize_mac(target_mac)
    target_mac.downcase.gsub(/:/, "-")
  end

  def stok
    login_and_stok
  end

  def login_and_stok
    return `curl -c cokkiejar -XPOST -d "operation=login&password=#{passwd}" "http://#{routerip}/cgi-bin/luci/;stok=/login?form=login" | jq -r 'select(has("data")) | .data.stok'`.chomp
  end

  def routerip
    @routerip
  end

  def passwd
    @passwd
  end
end

