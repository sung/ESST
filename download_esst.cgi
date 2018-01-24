#!/usr/bin/perl -w
#-------------------------------------------------------------------------------
# Title    :    download_esst.cgi
# Usage    :
# Function :
# Example  :
# Keywords :
# Options  :
# Author   :    Sungsam Gong <ssgong@bio.cc>
# Category :
# Reference:
# Returns  :
# Version  :    20080306
#------------------------------------------------------------------------------

# CGI config
use CGI;
my $q = new CGI();
my $ali=$q->param('alignment'); #S:SCOP, H:HOMSTRAD
my $matrix_type=$q->param('matrix_type');	#all: ALL, enz:ENZ, no_enz:NOENZ, old:OLD
my $masking_type=$q->param('masking_type');	#A:all-masking, B:no-ppi, C:no-act, D:act-only, R:random, X:no-masking

#HTML config
my $root='/data/Serve/Web/ESST';
my $css='/ESST/style/bioinfo.css';
my $local_js='/ESST/bioinfo.js';
my $tlb_logo='/ESST/images/bioinfo.jpg';

MAIN :{

	&print_header();

	&print_body();

	&print_footer();
}

sub print_header{
    print $q->header(-type=>"text/html");

    print $q->start_html(
            -title=>"Download ESST",
            -style=>{'type'=>"text/css",'src'=>"$css"},
            -script=>{'type'=>'text/javascript','language'=>'javascript','src'=>"$local_js"},
            -author=>"ssgong\@bio.cc",
            -bgcolor=>"#000000" );

	#print head-box
	my $head_box=`cat template/head_box.html`;
	print $head_box.'<hr>';

    #print_navigation;
	my $navi_panel=`cat template/navi_panel.html`;
	print $navi_panel;
}

sub print_body{
	print qq~
		<!-- main body -->
		<div style="border-style: solid; border-color: rgb(0, 102, 170); border-width: 1px 2px 2px 1px; padding: 0em 1em 0.5em; margin-top: 0.3em; background-color: rgb(255, 255, 255);">
			<table style="border-collapse: collapse;" border="0" bordercolor="#111111" cellpadding="0" cellspacing="0" width="90%">
			<tbody>
			<tr>
			  <td bordercolor="#FFFFFF" width="90%">
			  <br>
			  <h2><font size=4>Download</font></h2>
			  <dl>
				<dd>
			  	<h4>Your Selection:</h4>
				<b>Alignment Source</b>:$ali<br>
				<b>Matrix Type</b>:$matrix_type<br>
				<b>Masking Type</b>:$masking_type<br><br>
		~;

	my $esst_p;	#probability format
	my $esst_l;	#log odd ratio format
	my $ali_zip;	#zipped alignments
	#SCOP-based
	if($ali eq 'SCOP'){
		$esst_p="esst/Result.$ali/$matrix_type/Mask$masking_type"."p.dat";
		$esst_l="esst/Result.$ali/$matrix_type/Mask$masking_type.dat";
		$ali_zip="esst/Result.$ali/$matrix_type/Mask$masking_type.tgz";

		#error processing
		print "$matrix_type belongs to HOMSTRAD<br>" and &back_to_search if $matrix_type=~/Sub/;
		print "J belongs to HOMSTRAD<br>" and &back_to_search if $masking_type eq 'J';

		if($matrix_type eq 'NON_ACT'){
			print "$matrix_type only supports non-masking type<br>" unless $masking_type eq 'X';
			$esst_p="esst/Result.$ali/$matrix_type/MaskX"."p.dat";
			$esst_l="esst/Result.$ali/$matrix_type/MaskX.dat";
		}

	#HOMSTRAD-based
	}else{
		$esst_p="esst/Result.$ali/$matrix_type/$masking_type"."p.dat";
		$esst_l="esst/Result.$ali/$matrix_type/$masking_type.dat";
		$ali_zip="esst/Result.$ali/$matrix_type/Mask$masking_type.tgz";

		#error processing
		print "HOMSTRAD supports Sub177 and Sub371 only.<br>" and &back_to_search unless $matrix_type=~/Sub/;
	}

	unless (-e "$root/$esst_p"){
		print "can't find $esst_p<br>";
	}else{
		print "<div>";
		print "<a href=$esst_p>[Probability format]</a><br>";
		#print `cat $esst_p`;
	}

	unless (-e "$root/$esst_l"){
		print "can't find $esst_l<br>";
	}else{
		print "<div>";
		print "<a href=$esst_l>[Log-Odd ratio format]</a><br>";
		print "</div>";
	}

	unless (-e "$root/$ali_zip"){
		print "can't find $ali_zip<br>";
	}else{
		print "<div>";
		print "<a href=$ali_zip>[Alignment Files]</a><br>";
		print "</div>";
	}
	print qq~
		  	</dl>
		  	</td>
			</tr>
			</tbody>
			</table>
		</div>
		<hr>
		~;

}


sub	back_to_search{
	print qq~
		<p align="center">
		<br>
		<div align="center">
		<font color="#9999FF" face="Times New Roman, Times, serif" size="3"><b>
		<a href="/ESST/download_main.html">Back to Search</a> </b>
		</font></div>
	   ~;
}


sub print_footer{
    #print_foot;
	my $foot=`cat template/foot.html`;
	print $foot;
    print $q->end_html();
}

