# drop the header and the footer
/^    <div id="header">$/,/^    <\/div>$/ { next }
/^    <div id="footer">$/,/^    <\/div>$/ { next }
# print everything else
                                          { print }
