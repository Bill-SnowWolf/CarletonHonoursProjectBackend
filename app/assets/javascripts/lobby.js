var lobby = {};

(function() {
    var pusher;
    var lobbyMembers = [];
    var channel;

    this.init = function(key, currentUser) {
        pusher = new Pusher(key, {
        auth: {
            params: currentUser
            }
        });  
    };


    this.check = function() {
        channel = pusher.subscribe('presence-lobby');

        channel.bind('pusher:member_added', function(member) {
            console.log(member.id + " " + member.info.name + " joined lobby at " + member.info.join_time + ".");
            if (addMemberToLobby(member)) {
                addMemberToUserTable(member);
            }
        });

        channel.bind('pusher:member_removed', function(member) {
            console.log(member.id + " " + member.info.name + " left this lobby.");      
            removeMemberFromLobby(member);
            removeMemberFromUserTable(member);
        });

        channel.bind('client-reset-user', function(e) {
            console.log("reset user " + e);            
        });

        channel.bind('pusher:subscription_succeeded', function() {
            console.log("Subscription Succeeded.");

            channel.trigger('client-test', "Hello World");

            channel.members.each(function(member) {
                console.log(member.id + " " + member.info.name + " is in this lobby.");      
                if (addMemberToLobby(member)) {
                    addMemberToUserTable(member);
                }
            });    
        });    
    }
    this.available = function() {
        channel = pusher.subscribe('presence-lobby');

        channel.bind('pusher:member_added', function(member) {
            console.log(member.id + " " + member.info.name + " joined lobby at " + member.info.join_time + ".");
            addMemberToLobby(member);
        });

        channel.bind('pusher:member_removed', function(member) {
            console.log(member.id + " " + member.info.name + " left this lobby.");      
            removeMemberFromLobby(member);
        });

        channel.bind('client-request-service', function(e) {
    
        });

        channel.bind('pusher:subscription_succeeded', function() {
            console.log("Subscription Succeeded.");

            channel.trigger('client-test', "Hello World");

            channel.members.each(function(member) {
                console.log(member.id + " " + member.info.name + " is in this lobby.");      
                addMemberToLobby(member);
            });    
        });  
    };

    this.busy = function() {
        if (channel != null) {
            pusher.unsubscribe('presence-lobby');
            channel = null;            
        }
    };
    
    var addMemberToLobby = function(member) {
        var flag = true;
        for (var m in lobbyMembers) {
            if (m.id == member.id) {
                flag = false;
                break;
            }
        }
        if (flag) {
            lobbyMembers.push(member);
            return true;
            // addMemberToUserTable(member);  
        } else {
            return false;
        }
    };

    var removeMemberFromLobby = function(member) {
        // removeMemberFromUserTable(member);

        for (var m in lobbyMembers) {
            if (m.id == member.id) {
                var index = lobbyMembers.indexOf(m);
                lobbyMembers.splice(m, 1);
            }
            break;
        }
    }

    var addMemberToUserTable = function(member) {
        var table = document.getElementById("user-table-body");

        var row = table.insertRow(-1);
        row.id = "member-row-" + member.id;
    
        var idCell = row.insertCell(0);
        idCell.innerHTML = member.id;

        var nameCell = row.insertCell(1);
        nameCell.innerHTML = member.info.name;    
    };

    var removeMemberFromUserTable = function(member) {
        var row = document.getElementById("member-row-" + member.id);
        var table = document.getElementById("user-table-body");    
        table.deleteRow(row.rowIndex - 1);
    }

}).apply(lobby);