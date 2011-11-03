maintainer       "Dale-Kurt Murray"
maintainer_email "dalekurt.murray@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures Postfix for Amazon Simple Email Service"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.5"

recipe            "amazon_ses","Configures Postfix to relay mail to Amazon Simple Email Service"
depends           "postfix", ">= 0.0.0"

%w{ ubuntu debian }.each do |os|
  supports os
end