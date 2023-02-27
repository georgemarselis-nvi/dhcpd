% dhcpd.conf(5) 1.0 | The ISC dhcpd configuration file

# Name

dhcpd.conf - The ISC dhcpd configuration file. 

## Description

The dhcpd.conf file contains configuration information for the dhcpd daemon, the Internet Systems Consortium DHCP Server. This man page also describes several DHCP concepts, along with dhcpd redundancy and Dynamic DNS updates

## File format

The file is comprised of comments, parameters and declarations. Comments start with a pound sign ('#') and end at newline. You can use whitespaces (tabs and newlines) for formating anywhere outside a parameter and/or declaration. 

Comments, parameters and declarations can appear either at the beginning of the line or anywhere with the same line, regardless of preceeding whitespace. You can have comments at the beginninig of a line or the end of a parameter, after you place the semicolon, like this:

	# Section about ldap
	ldap-port 389; # LDAP port

Since dhcpd.conf can be a long file, please remember to indent your parameters and declarations, appropriatel. Terminate any parameter with a semicolon. In declarations, place parameters and nested declerations inside curly/brace brackets, much like a C program. 

	subnet 192.168.10.0 netmask 255.255.255.0 {
		range 192.168.10.100 192.168.10.200;
		option routers 192.168.10.1;
	}

Nested declarations look like this: 

	shared-network 224-29 {
		subnet 192.168.10.0 netmask 255.255.255.0 {
			option routers 192.168.10.1;
		}
	}

Parameters and declarations can be on the same line, as long as you use the semicolons (';') to declare the end of a parameter and remember to start and close the body of the decleration with curly/brace brackets. But since a company dhcpd can be quite long, it is really not worth the trouble: 

	subnet 192.168.10.0 netmask 255.255.255.0 { range 192.168.10.100 192.168.10.200; option routers 192.168.10.1; }

You might have already guessed what these declarations might do. We will explain in more details further below. If you wish to read ahead, see ***dhcpd.conf-declarations(5)***

### Parameters

Parameters are variables for various dhcpd options. Examples of parameters are the dhcp lease duration, wheather or not to provide addresses to unknown/not-pre-registered clients or the IP address of a gateway a client should use. The format of dhcpd.conf allows most parameters to be both global or local to a subnet and/or group, depending on the needs of the administrator. As we mentioned earlier, all declarations must end with a semicolon.

Parameters must be stated before any actual use in a decleration, both globally and/or in a subnet/group decleration. DHCPD has either sane settings or does not require any parameter which is not already declared. Any options not specifically stated, are either inherited from ( reasonably reasonable) global parameters (MTU, for example) or ignored and not passed to the client. For example, if you do not include a ```option routers``` statement in your subnet decleration, it will create a router-less network declaration. Multiple declarations of the same parameter can be applied, but the effect depends on the scope. For example while there can be a global ```option routers``` parameter which can be overriden by a more specific-to-the-network instance, like so: 

	option routers 192.168.1.1;

	subnet 192.168.10.0 netmask 255.255.255.0 {
		range 192.168.10.100 192.168.10.200;
		option routers 192.168.10.1;
	}
   
The clients which will not match any subnet described/declared(?) will inherit the global option. Otherwise any client on the 192.168.10.0/24 subnetwork will receive ```192.168.10.1``` as the network gateway.

For a complete list of dhcpd parameters see ***dhcpd.conf-parameters(5)***.

### Declarations

Declarations are similar to a line of code in a program: They describe the parameters of the network (gateway, broadcast, MTU etc ) or the parameters the clients ( assigned IP for the client, assigned DNS, etc ). All declerations are comprised of two elements: the statement and the body, e.g.: 

	subnet 192.168.10.0 netmask 255.255.255.0 {
		...
	}

A statement describes the topology of the network. The body is mostly comprised of options we would like to apply for the specific network. The body is being differenciated by the statment via curly/brace brackets. Declaration bodys start with an opening curly/brace bracket ( '{' ) can have zero or more parameters in them. Declaration bodies must end with a closing curly/brace bracket ('}') . We will talk about the most common statements later on.

Declarations can be nested: a decleration can apply to a group of parameters and/or a group of other declarations. For example, you can group declarations that apply a lease to multiple networks in a single decleration and then use that decleration in subsequent network statements. Or, you can nest declarations to provide exeptions to speficic category of clients and/or network. 

More examples in the relevant section ( **[Examples](#Examples-declarations)** ) . For a complete list and more advanced examples see ***dhcpd.conf-declarations(5)***

#### Client assignments

Before we go into the details of declarations, we have to talk about client assignments. The assignments come in two flavors, dynamic and static assignment:

1. Dynamic assignment is an IP/parameters assignment for the host that gets periodically refreshed, according to the lease duration parameter.
2. Static assignments, are hosts who have a known *characteristic*. Such characteristic can be the mac address (```hardware ethernet ``` parameter), or other details passed on by the client, such as booting in UEFI or BIOS. Static assignments are always included in specific declaration.


#### Order of client assignments

When dhcpd tries to find a host declaration for a client, it first looks for a host declaration which has a fixed-address declaration that lists an IP address that is valid for the subnet or shared network on which the client is booting. If it doesn't find any such entry, it tries to find an entry which has no fixed-address declaration

Additionally, boot parameters are determined by 
1. The client's host declaration (if any) 
2. Consulting any class declarations matching the client
3. Consulting any pool declarations matching the client
4. Subnet matching and finally
5. Shared-network declarations for the IP address assigned to the client

Examples for the above will be given, after we explore the lexical scope of the file. 

	host ncd1 { hardware ethernet 08:52:27:C4:8B:18; }

Each of these declarations itself appears within a lexical scope, and all declarations at less specific lexical scopes are also consulted for client option declarations.

### Syntax / EBNF / Lexical Scope

Scopes are never considered twice.

	If parameters are declared in more than one scope, the parameter declared in the most specific scope is the one that is used.
The fuck this means? what is specific, in this case.

## Most often used declarations

#### Declaration: Host decleration
The most often used declaration is the ```subnet``` decleration. We have already used it a couple of times already. 

#### Declaration: Class decleration

#### Declaration: Pool decleration

#### Declaration: Subnet decleration

#### Declaration: Shared-network decleration


### DHCP assignment and Lease resolution

#### Ip Address Conflic Prevention

An unknown client is a client requesting a lease, but has no host declaration defined in the configuration file.

### Files

### Bugs

### Author

### Most frequent mistakes

Semicolons. Use dhcpd -T to test your setup, but the error messages provided can be less than stelar.

### Concepts that you should be aware of

**Shared network**: ```shared-network``` What is a "shared network" ? https://support.microfocus.com/kb/doc.php?id=7004091 . Why should we care? How do you configure a shared nework with dhcpd? https://serverfault.com/questions/1014741/isc-dhcpd-how-to-assign-different-dhcp-settings-even-if-request-originated-from

For a complete list of dhcpd declarations see ***dhcpd.conf-declarations(5)***. For a more complete and expanded list of examples see 
* **[Examples](#Examples)** in this man page
* ***dhcpd.conf-examples(5)***
* ***dhcpd.conf-advanced-examples(5)***

### See Also

***dhcpd.conf-examples(5)***, ***dhcpd.conf-advanced-examples(5)*** ***dhcpd.conf-ldap(5)***, ***dhcpd(8)***, ***dhcpd.leases(5)***, ***dhcp-options(5)***, ***dhcp-eval(5)***, RFC2132, RFC2131.
