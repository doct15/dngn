#!/usr/bin/perl
#
use GD;
use CGI qw(param);


open (LOGFILE, ">/tmp/LOGFILE");

for $cnt1 (0..4) {
	$row[$cnt1]=param("r$cnt1");
	print LOGFILE "$row[$cnt1]\n";
}

for $cnt1 (0..4) {
        for $cnt2 (0..4) {
                $map[$cnt1][$cnt2]=substr($row[$cnt1],$cnt2,1);
        }
}

$xw = 300;
$yw = 200;
$mx = $xw/2;
$my = $yw/2;

$im = new GD::Image($xw,$yw);

$white = $im->colorAllocate(255,255,255);
$black = $im->colorAllocate(0,0,0);       
$red = $im->colorAllocate(255,0,0);      
$blue = $im->colorAllocate(0,0,255);

$Gray[0]  = $im->colorAllocate( 89 , 84 , 84 ); #40
$Gray[1]  = $im->colorAllocate( 130 , 128 , 126 ); #55
$Gray[2]  = $im->colorAllocate( 143 , 142 , 141 ); #60
$Gray[3]  = $im->colorAllocate( 199 , 199 , 197 ); #80
$Gray[4]  = $im->colorAllocate( 240 , 241 , 240 ); #95

#for $cnt1 (0..4) {
#	for $cnt2 (0..4) {
#		print "$map[$cnt1][$cnt2]";
#	}
#	print "\n";
#}
	
$im->fill($mx,$my,$black);
if ($filledinfloor) {
	print LOGFILE "SHIT FILLEDINFLOOR!\n";
	for $cnt1 (1..4) {
		for $cnt2 (0..4) {
			$temp = get_xy ($cnt2, $cnt1);
                        $ox1=$x1; $oy1=$y1; $ox2=$x2; $oy2=$y2;
                        $temp = get_xy ($cnt2, $cnt1-1);
			
			$poly = new GD::Polygon;
			$poly->addPt($ox1,$oy2);
			$poly->addPt($ox2,$oy2);
			$poly->addPt($x2,$y2);
			$poly->addPt($x1,$y2);
			$poly->addPt($ox1,$oy2);

			$im->filledPolygon($poly,$Gray[$cnt1]);
			$im->polygon($poly,$black);

			$poly = new GD::Polygon;
			$poly->addPt($ox1,$oy1);
			$poly->addPt($ox2,$oy1);
			$poly->addPt($x2,$y1);
			$poly->addPt($x1,$y1);
			$poly->addPt($ox1,$oy1);

			$im->filledPolygon($poly,$Gray[$cnt1]);
			$im->polygon($poly,$black);
		}
	}
}
			
			
for $cnt1 (0..4) {
	for $cnt2 (0..1) {
		$tmpv1=$map[$cnt1][$cnt2];
		if ($tmpv1 >0) {
			$temp = get_xy ($cnt2, $cnt1);
			$ox1=$x1; $oy1=$y1; $ox2=$x2; $oy2=$y2;
			$temp = get_xy ($cnt2, $cnt1-1);
			$im->filledRectangle($x1,$y1,$x2,$y2,$white);

			$poly = new GD::Polygon;
			$poly->addPt($ox2,$oy1);
			$poly->addPt($x2,$y1);
			$poly->addPt($x2,$y2);
			$poly->addPt($ox2,$oy2);
			$poly->addPt($ox2,$oy1);

			$im->filledPolygon($poly,$Gray[$cnt1]);

			$im->line($ox2,$oy1,$x2,$y1,$black);
			$im->line($x2,$y1,$x2,$y2,$black);
			$im->line($x2,$y2,$ox2,$oy2,$black);
			$im->filledRectangle($ox1,$oy1,$ox2,$oy2,$Gray[$cnt1]);
			$im->rectangle($ox1,$oy1,$ox2,$oy2,$black);
			if ($tmpv1 == "Z") {
			
			}
		}
		
		$tmp = 4-$cnt2;
		$tmpv1=$map[$cnt1][$tmp];
		if ($tmpv1 >0) {
			$temp = get_xy ($tmp, $cnt1);
                        $ox1=$x1; $oy1=$y1; $ox2=$x2; $oy2=$y2;
                        $temp = get_xy ($tmp, $cnt1-1);
			$im->filledRectangle($x1,$y1,$x2,$y2,$white);

			$poly = new GD::Polygon;
			$poly->addPt($ox1,$oy1);
			$poly->addPt($x1,$y1);
			$poly->addPt($x1,$y2);
			$poly->addPt($ox1,$oy2);
			$poly->addPt($ox1,$oy1);

			$im->filledPolygon($poly,$Gray[$cnt1]);
			
                        $im->line($ox1,$oy1,$x1,$y1,$black);
                        $im->line($x1,$y1,$x1,$y2,$black);
                        $im->line($x1,$y2,$ox1,$oy2,$black);
                        $im->filledRectangle($ox1,$oy1,$ox2,$oy2,$Gray[$cnt1]);
                        $im->rectangle($ox1,$oy1,$ox2,$oy2,$black);
			if ($tmpv1 == "Z") {

			}
		}
	}
	$tmpv1=$map[$cnt1][2];
	print LOGFILE ":$tmpv1:\n";
	if ($tmpv1 ne 0) {
		$temp = get_xy (2, $cnt1);
		$im->filledRectangle($x1,$y1,$x2,$y2,$Gray[$cnt1]);
		$im->rectangle($x1,$y1,$x2,$y2,$black);
		if ($tmpv1 eq "Z") {
			open (GIF,"logo1f.gif") || die;
			$img2 = newFromGif GD::Image(GIF) || die;
			close GIF;
			($t1x,$t1y)=$img2->getBounds();
			if ($cnt1 == 0) {
				$tmpv2 = 10;
			} elsif ($cnt1 == 1) {
				$tmpv2 = 4;
			} elsif ($cnt1 == 2) {
				$tmpv2 = 2;
			} else {
				$tmpv2 = 1;
			}
			$t2x = $t1x/$tmpv2;
			$t2y = $t1y/$tmpv2;
			print LOGFILE "ZZZ $x1 , $y1 , $t1x , $t1y , $t2x , $t2y , $tmpv2\n";
#			$im->copy($img2,$x1,$y1,0,0,$t1x,$t1y);
			$im->copyResized($img2,$x1,$y1,0,0,$t1x,$t1y,$t2x,$t2y);
		}
	}
			
}
	
	print "Content-type: image/gif\n\n";
	print $im->gif;

sub get_xy {
        my ($tmp);
        $tmp = (1 / 2 ** (4 - $_[1] ));
        $wh = $yw * $tmp;
	$ww = $xw * $tmp;
        $y1 = $my - $wh / 2;
        $y2 = $y1 + $wh;
	$xl = $mx - (($ww * 5) /2);
	$x1 = $xl + $_[0] * $ww;
	$x2 = $x1 + $ww;
}

