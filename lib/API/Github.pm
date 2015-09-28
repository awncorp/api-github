# ABSTRACT: Github.com API Client
package API::Github;

use namespace::autoclean -except => 'has';

use Data::Object::Class;
use Data::Object::Class::Syntax;
use Data::Object::Signatures;

use Data::Object qw(load);
use Data::Object::Library qw(Str);

extends 'API::Client';

# VERSION

our $DEFAULT_URL = "https://api.github.com";

# ATTRIBUTES

has username => rw;
has token    => rw;

# CONSTRAINTS

req username => Str;
req token    => Str;

# DEFAULTS

def identifier => 'API::Github (Perl)';
def url        => method { load('Mojo::URL')->new($DEFAULT_URL) };
def version    => 1;

# CONSTRUCTION

after BUILD => method {
    my $identifier = $self->identifier;
    my $username   = $self->username;
    my $token      = $self->token;
    my $version    = $self->version;

    my $userinfo   = "$username:$token";
    my $agent      = $self->user_agent;
    my $url        = $self->url;

    $agent->transactor->name($identifier);
    $url->userinfo($userinfo);

    return $self;
};

method PREPARE ($ua, $tx, %args) {
    my $headers = $tx->req->headers;
    my $url     = $tx->req->url;

    # default headers
    $headers->header('Content-Type' => 'application/json');

    return $self;
}

method resource (@segments) {
    # build new resource instance
    my $instance = __PACKAGE__->new(
        debug      => $self->debug,
        fatal      => $self->fatal,
        retries    => $self->retries,
        timeout    => $self->timeout,
        user_agent => $self->user_agent,
        identifier => $self->identifier,
        username   => $self->username,
        token      => $self->token,
        version    => $self->version,
    );

    # resource locator
    my $url = $instance->url;

    # modify resource locator if possible
    $url->path(join '/', $self->url->path, @segments);

    # return resource instance
    return $instance;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use API::Github;

    my $github = API::Github->new(
        username   => 'USERNAME',
        token      => 'TOKEN',
        identifier => 'APPLICATION NAME',
    );

    $github->debug(1);
    $github->fatal(1);

    my $user = $github->users('h@x0r');
    my $results = $user->fetch;

    # after some introspection

    $user->update( ... );

=head1 DESCRIPTION

This distribution provides an object-oriented thin-client library for
interacting with the Github (L<http://github.com>) API. For usage and
documentation information visit L<https://developer.github.com/v3>.
API::Github is derived from L<API::Client> and inherits all of it's
functionality. Please read the documentation for API::Client for more usage
information.

=cut

=attr identifier

    $github->identifier;
    $github->identifier('IDENTIFIER');

The identifier attribute should be set to a string that identifies your
application.

=cut

=attr token

    $github->token;
    $github->token('TOKEN');

The token attribute should be set to the API user's personal access token.

=cut

=attr username

    $github->username;
    $github->username('USERNAME');

The username attribute should be set to the API user's username.

=cut

=attr debug

    $github->debug;
    $github->debug(1);

The debug attribute if true prints HTTP requests and responses to standard out.

=cut

=attr fatal

    $github->fatal;
    $github->fatal(1);

The fatal attribute if true promotes 4xx and 5xx server response codes to
exceptions, a L<API::Client::Exception> object.

=cut

=attr retries

    $github->retries;
    $github->retries(10);

The retries attribute determines how many times an HTTP request should be
retried if a 4xx or 5xx response is received. This attribute defaults to 0.

=cut

=attr timeout

    $github->timeout;
    $github->timeout(5);

The timeout attribute determines how long an HTTP connection should be kept
alive. This attribute defaults to 10.

=cut

=attr url

    $github->url;
    $github->url(Mojo::URL->new('https://api.github.com'));

The url attribute set the base/pre-configured URL object that will be used in
all HTTP requests. This attribute expects a L<Mojo::URL> object.

=cut

=attr user_agent

    $github->user_agent;
    $github->user_agent(Mojo::UserAgent->new);

The user_agent attribute set the pre-configured UserAgent object that will be
used in all HTTP requests. This attribute expects a L<Mojo::UserAgent> object.

=cut

=method action

    my $result = $github->action($verb, %args);

    # e.g.

    $github->action('head', %args);    # HEAD request
    $github->action('options', %args); # OPTIONS request
    $github->action('patch', %args);   # PATCH request


The action method issues a request to the API resource represented by the
object. The first parameter will be used as the HTTP request method. The
arguments, expected to be a list of key/value pairs, will be included in the
request if the key is either C<data> or C<query>.

=cut

=method create

    my $results = $github->create(%args);

    # or

    $github->POST(%args);

The create method issues a C<POST> request to the API resource represented by
the object. The arguments, expected to be a list of key/value pairs, will be
included in the request if the key is either C<data> or C<query>.

=cut

=method delete

    my $results = $github->delete(%args);

    # or

    $github->DELETE(%args);

The delete method issues a C<DELETE> request to the API resource represented by
the object. The arguments, expected to be a list of key/value pairs, will be
included in the request if the key is either C<data> or C<query>.

=cut

=method fetch

    my $results = $github->fetch(%args);

    # or

    $github->GET(%args);

The fetch method issues a C<GET> request to the API resource represented by the
object. The arguments, expected to be a list of key/value pairs, will be
included in the request if the key is either C<data> or C<query>.

=cut

=method update

    my $results = $github->update(%args);

    # or

    $github->PUT(%args);

The update method issues a C<PUT> request to the API resource represented by
the object. The arguments, expected to be a list of key/value pairs, will be
included in the request if the key is either C<data> or C<query>.

=cut

=resource emojis

    $github->emojis;

The emojis method returns a new instance representative of the API
I<emojis> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/emojis>.

=cut

=resource events

    $github->events;

The events method returns a new instance representative of the API
I<events> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/activity/events>.

=cut

=resource feeds

    $github->feeds;

The feeds method returns a new instance representative of the API
I<feeds> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/activity/feeds>.

=cut

=resource gists

    $github->gists;

The gists method returns a new instance representative of the API
I<gists> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/gists>.

=cut

=resource gitignore

    $github->gitignore;

The gitignore method returns a new instance representative of the API
I<gitignore> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/gitignore>.

=cut

=resource issues

    $github->issues;

The issues method returns a new instance representative of the API
I<issues> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/issues>.

=cut

=resource licenses

    $github->licenses;

The licenses method returns a new instance representative of the API
I<licenses> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/licenses>.

=cut

=resource markdown

    $github->markdown;

The markdown method returns a new instance representative of the API
I<markdown> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/markdown>.

=cut

=resource meta

    $github->meta;

The meta method returns a new instance representative of the API
I<meta> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/meta>.

=cut

=resource notifications

    $github->notifications;

The notifications method returns a new instance representative of the API
I<notifications> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/activity/notifications>.

=cut

=resource orgs

    $github->orgs;

The orgs method returns a new instance representative of the API
I<orgs> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/orgs>.

=cut

=resource rate_limit

    $github->rate_limit;

The rate_limit method returns a new instance representative of the API
I<rate_limit> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/rate_limit>.

=cut

=resource repos

    $github->repos;

The repos method returns a new instance representative of the API
I<repos> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/repos>.

=cut

=resource search

    $github->search;

The search method returns a new instance representative of the API
I<search> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/search>.

=cut

=resource users

    $github->users;

The users method returns a new instance representative of the API
I<users> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://developer.github.com/v3/users>.

=cut

