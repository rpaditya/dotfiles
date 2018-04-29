#
# $Id: ip_lib.pl,v 1.4 2000/07/08 07:45:09 aditya Exp aditya $
#
# collected and assorted IP address manipulation routines
# by R.P. Aditya (aditya@dnai.com) 
#
# None of the following routines handle illegal specified lengths, so
# make sure you have a similar check on the mask $len before you pass it
#
#  if ( ( $len > 32 ) || ( $len < 0 )){
#    print "Error:  "/length" must be between 0 and 32 (not $len)";
#    exit (1) ;
#  }
#
#  likewise, make sure the ipaddress you pass to range_ips
#  is on a CIDR boundry by using something like the following
#  where $ipaddr is a dotted-quad ip address and $len is the /length
#
#  my($mask) = &mask_of_len( $len );
#  my($ip) = &dotted2decimal($ipaddr);
# 
#  my($adjusted_ip) = $ip & $mask ;
#  if ( $adjusted_ip != $ip ){
#    die "$ipaddr not aligned for CIDR block size of $len\n";
#  }
#


#  These subroutines are from aggis.pl from Merit
#  This is in a subroutine only because the algorithm is so obscure:
#
#  For $len = 8,
#      32 - $len = 24
#      1 << $len = 0x01000000
#      negative of that = 0xff000000
#
sub mask_of_len {
  my ($len) = @_ ;
  return(-( 1 << (32 - $len )));
}

# dotted2decimal takes an ipaddr in dotted-quad form and 
# transforms it into decimal
sub dotted2decimal {
  my($ipaddr) = @_;
  my(@ip_addr) = split( '\.', $ipaddr );
  my($ip) = ($ip_addr[0] * 16777216) + ($ip_addr[1] * 65536) +
     ($ip_addr[2] * 256) + $ip_addr[3];
  return $ip;
}

# printip takes a decimal ip and prints it in dotted-quad form
# same as if it were called decimal2dotted
sub printip {
  my($ip) = @_ ;

  my($byte0) = ($ip >> 24) & 0x000000ff ;
  my($byte1) = ($ip & 0x00ff0000) >> 16 ;
  my($byte2) = ($ip & 0x0000ff00) >>  8 ;
  my($byte3) = ($ip & 0x000000ff) ;

  my($s)=sprintf ("%d.%d.%d.%d", $byte0, $byte1, $byte2, $byte3 );
  return($s);
}

# range_ips takes an ipaddr in dotted-quad and a mask $len in CIDR-slash format
# as arguments and returns an array of the first and last ip addresses in
# that subnet in dotted-quad form
sub range_ips {
  my($ipaddr, $len) = @_;
  my($ip) = &dotted2decimal($ipaddr);
  my($first) = &printip( $ip, 32 );
  my($last) = &printip( $ip + ( 1 << (32-$len) )-1 , 32 );
  return ($first, $last);
}
#
# The following are from http://peer-sa.senet.com.au/archive/msg00886.html
# apparently by Ivan Brawley of Communica
#
# netmask takes a CIDR-slash format mask 
# and returns the dotted-quad equivalent
sub netmask {
  my($len) = @_;
  my($netmask) = join(".",unpack("C4",pack("B*x4","1"x$len)));
  return $netmask;
}

# inverse_mask takes a CIDR-slash format mask
# and returns the dotted-quad "inverse" mask
# useful for Cisco ACLs
sub inverse_mask {
  my($len) = @_;
  my($inverse) = join(".",unpack("C4",pack("B*","0"x$len."1"x(32-$len))));
  return $inverse;
}

# this subroutine returns the ipblock $ip_block of length $mask
# which contains the ip address $ipaddr
# ie.
# my($blk) = which_block($ip, $mask);
# print "$blk\n";
# ----
# which_block(216.15.13.0, 19)
# returns 216.15.0.0
#
sub which_block {
  my($ipaddr, $mask) = @_;
  my($ip) = dotted2decimal($ipaddr);
  my($len) = mask_of_len($mask);
  my($block) = $ip & $len;
  my($ip_block) = printip($block);
  return $ip_block;
}

#
# this is essentially the same thing as which_block
# just slightly different for backward compatibility
# ----
# in_block(207.181.250.88, "216.15.0.0/30")
# will return 0 signifying that 207.181.250.88 is NOT in 216.15.0.0/30
#
sub in_block {
  my($ip, $block) = @_;
  my($ip_block, $slash) = split('\/', $block);

  my($mask) = &mask_of_len( $slash );

  my($ip_addr) = dotted2decimal($ip);
  my($ip_dblock) = dotted2decimal($ip_block);

  my($adjusted_ip) = $ip_addr & $mask ;

  if ( $adjusted_ip != $ip_dblock ){
    return(0);
  } else {
    return(1);
  }
}


sub usable_ips {
  my($ipaddr, $len, $type_co) = @_;
  my($mask) = mask_of_len( $len );

  my($ip) = dotted2decimal($ipaddr);
  my($adjusted_ip) = $ip & $mask;
  $ip = $adjusted_ip;
  my($network) = printip( $ip, 32 );
  my($router) = $network;
  my($first) = $network;
  my($broadcast) = printip( $ip + ( 1 << (32-$len) )-1, 32 );
  my($last) = $broadcast;
  my($first_use) = $first;
  my($last_use) = $last;

  if ($len < 31){
    $first = printip($ip + 1, 32);
    $last = printip( $ip + ( 1 << (32-$len) )-2, 32 );
    my($second) = printip($ip + 2, 32);
    $router = $first;
    $first_use = $second;
    $last_use = $last;
  }
  return ($router, $first_use, $last_use);
}

1;
