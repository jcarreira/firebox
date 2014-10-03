 #!/usr/bin/perl -w
 # # a fun, imaginary wednesdayuse strict;
use Project::Gantt;
use Project::Gantt::Skin;

my $skin= new Project::Gantt::Skin(
    doTitle         =>      0);

my $day = new Project::Gantt(
    file            =>      'hourly.png',
    skin            =>      $skin,
    mode            =>      'hours',
    description     =>      'A day in the life');

my $al = $day->addResource(
    name            =>      'Alex');        

$day->addTask(
    description     =>      'Finish sleep',
    resource        =>      $al,
    start           =>      '2004-07-21 00:00:00',
    end             =>      '2004-07-21 08:30:00');

$day->addTask(
    description     =>      'Breakfast/Wakeup',
    resource        =>      $al,
    start           =>      '2004-07-21 08:30:00',
    end             =>      '2004-07-21 10:00:00');

my $sub = $day->addSubProject(
    description     =>      'Important Stuff');
$sub->addTask(
    description     =>      'Contemplate my navel',
    resource        =>      $al,
    start           =>      '2004-07-21 10:00:00',
    end             =>      '2004-07-21 11:00:00');

$day->addTask(
    description     =>      'Lunch',
    resource        =>      $al,
    start           =>      '2004-07-21 11:00:00',
    end             =>      '2004-07-21 12:30:00');
$sub->addTask(
    description     =>      'Wonder about life',
    resource        =>      $al,
    start           =>      '2004-07-21 11:00:00',
    end             =>      '2004-07-21 11:22:00');

$day->addTask(
    description     =>      'Code for a while',
    resource        =>      $al,
    start           =>      '2004-07-21 12:30:00',
    end             =>      '2004-07-21 17:00:00');

$day->addTask(
    description     =>      'Sail',
    resource        =>      $al,
    start           =>      '2004-07-21 17:00:00',
    end             =>      '2004-07-21 20:30:00');
$day->display();
