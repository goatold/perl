use warnings;
use strict;
use Win32::OLE qw(EVENTS);
use Data::Dumper;
use feature 'say';

my $app = Win32::OLE->GetActiveObject('InternetExplorer.Application') || Win32::OLE->new('InternetExplorer.Application', 'Quit'); 
Win32::OLE->WithEvents($app,\&eventHdl,"DWebBrowserEvents2");
$app->{Visible} = 1;
$app->Navigate('http://www.baidu.com');
my $stat = 0;

Win32::OLE->MessageLoop();
sub eventHdl {
    my ($Obj,$Event,@Args) = @_;
	say "event:$Event, with args: \n". Dumper(\@Args);
	if ($Event eq "DocumentComplete") {
	    if ($stat) {
		    Win32::OLE->QuitMessageLoop();
			return;
		}
		my ($IEObject) = @Args;
		say "Got doc: ". $IEObject->Document->URL;
		my $form = $IEObject->Document->forms->item(0);
		my $element = $form->elements("wd");
	    $element->{value} = "perl";
		$form->submit();
		$stat = 1;
	}
}

sleep 5;
undef $app;