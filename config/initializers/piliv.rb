require "piliv2"

access_key = "gsXF8d-OUYS0B0vLz9fJQ18zf6e-na0GQhG5VGVQ" # 替换成自己 Qiniu 账号的 AccessKey.
secret_key = "FGrqfTpulZYKQEb7sNJgDMaTTVHcSwbA58OoYdsU" # 替换成自己 Qiniu 账号的 SecretKey.
$hub_name   = "qingyuncaizheng-kongjian"    # Hub 必须事先存在.

$mac = Pili::Mac.new(access_key, secret_key)
client = Pili::Client.new($mac)
$hub = client.hub($hub_name)