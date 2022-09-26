#!/bin/bash

# clean folder
rm -rf /tmp/freechains

# pubpvt keys from pioneer
PIONEER_PUBKEY=ADB56B48005452626DA84219DF000A2F92F63DC533D76BE0B806C4CF84A422F8
PIONEER_PVTKEY=CBBA777B93E03459033D97E249C65DB43547A644D52885C727E42A5B386B4212ADB56B48005452626DA84219DF000A2F92F63DC533D76BE0B806C4CF84A422F8

# pubpvt keys from users
ACTIVE_PUBKEY=F055BD53EED18E6B964629D063DE722095C30EC7B002E245497D5332AD03C464
ACTIVE_PVTKEY=57F3AFDEBA300207F6790C0BBA1FBEFA1AF8D42E0F6B8806B6D33D61F8F91AC7F055BD53EED18E6B964629D063DE722095C30EC7B002E245497D5332AD03C464

TROLL_PUBKEY=9ECFFB7E407E816FFD1CC90287F749817CCBB3B444598B226CBF0AD26743EA3E
TROLL_PVTKEY=84B2FCDB05906FE04F140608640834EFE56B676EC57EC88F4287D6AFA8165B509ECFFB7E407E816FFD1CC90287F749817CCBB3B444598B226CBF0AD26743EA3E

NEWBIE_PUBKEY=A88DEEE7BB0AA7DD164CC71261E7B11B83178C6CD2ED9D610D75146DB689A8A1
NEWBIE_PVTKEY=673E7C02F403692A9128D04B9295732D8DA5ED17494FB5FDB62C98B314E290F0A88DEEE7BB0AA7DD164CC71261E7B11B83178C6CD2ED9D610D75146DB689A8A1

# const variables
NUMBER_HOSTS=3
PUBLIC_FORUM_NAME="#forum"
PIONEER_HOST=9001
ACTIVE_HOST=9002
TROLL_HOST=9003
NEWBIE_HOST=9001

updateHostsTimestamp() {
    NEW_DATE=`date -d "$DATE + $1 day" +%s`
    echo "...Updating Hosts Timestamps..."
    for (( host_idx = 1; host_idx <= $NUMBER_HOSTS; host_idx++ ))
    do
        freechains-host now $NEW_DATE --port=900$host_idx
    done
    echo "...Hosts Timestamps Updated Sucessfully..."
}

synchronizeHosts() {
    echo "...Synchronizing Hosts..."
    for (( host_idx = 1; host_idx <= $NUMBER_HOSTS; host_idx++ ))
    do
        for (( host_idx_another = host_idx + 1; host_idx_another <= $NUMBER_HOSTS; host_idx_another++ ))
        do
            freechains --host=localhost:900$host_idx peer localhost:900$host_idx_another recv $PUBLIC_FORUM_NAME
            freechains --host=localhost:900$host_idx_another peer localhost:900$host_idx recv $PUBLIC_FORUM_NAME
        done
    done
    echo "...Hosts Synchronized Sucessfully..."
}

getPioneerReps() {
    echo `freechains --host=localhost:9001 chain $PUBLIC_FORUM_NAME reps $PIONEER_PUBKEY`
}

getActiveReps() {
    echo `freechains --host=localhost:9001 chain $PUBLIC_FORUM_NAME reps $ACTIVE_PUBKEY`
}

getTrollReps() {
    echo `freechains --host=localhost:9001 chain $PUBLIC_FORUM_NAME reps $TROLL_PUBKEY`
}

getNewbieReps() {
    echo `freechains --host=localhost:9001 chain $PUBLIC_FORUM_NAME reps $NEWBIE_PUBKEY`
}

getPostReps() {
    echo `freechains --host=localhost:9001 chain $PUBLIC_FORUM_NAME reps $1`
}

showAllUserReps() {
    echo "PIONEER REPS"
    getPioneerReps
    echo "ACTIVE REPS"
    getActiveReps
    echo "TROLL REPS"
    getTrollReps
    echo "NEWBIE REPS"
    getNewbieReps
}

giveLikeOrDislikeToPost() {
    if [ $1 = 0 ]; then
        if [ $( getPioneerReps ) -gt 5 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 like $3 --sign=$PIONEER_PVTKEY
        fi

        if [ $( getActiveReps ) -gt 10 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 like $3 --sign=$ACTIVE_PVTKEY
        fi

        if [ $( getNewbieReps ) -gt 15 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 like $3 --sign=$NEWBIE_PVTKEY
        fi
    elif [ $1 = 2 ]; then
        if [ $( getPioneerReps ) -gt 10 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 dislike $3 --sign=$PIONEER_PVTKEY
        fi

        if [ $( getActiveReps ) -gt 14 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 dislike $3 --sign=$ACTIVE_PVTKEY
        fi

        if [ $( getNewbieReps ) -gt 18 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 dislike $3 --sign=$NEWBIE_PVTKEY
        fi
    fi
}

# init hosts and first posts
echo "...Initializing hosts and joining #forum..."
for (( host_idx = 1; host_idx <= $NUMBER_HOSTS; host_idx++ ))
do
    gnome-terminal -- freechains-host --port=900$host_idx start /tmp/freechains/host0$host_idx
    sleep 1
    freechains --host=localhost:900$host_idx chains join '#forum' $PIONEER_PUBKEY
    echo "Host0$host_idx OK..."
done

# messages
PIONEER_MESSAGES=(
    "freechains --host=localhost:${PIONEER_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'PIONEER VIRAL MESSAGE' --sign=${PIONEER_PVTKEY}"
    "freechains --host=localhost:${PIONEER_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'PIONEER NORMAL MESSAGE' --sign=${PIONEER_PVTKEY}"
    "freechains --host=localhost:${PIONEER_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'PIONEER BAD MESSAGE' --sign=${PIONEER_PVTKEY}"
)

ACTIVE_MESSAGES=(
    "freechains --host=localhost:${ACTIVE_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'ACTIVE VIRAL MESSAGE' --sign=${ACTIVE_PVTKEY}"
    "freechains --host=localhost:${ACTIVE_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'ACTIVE NORMAL MESSAGE' --sign=${ACTIVE_PVTKEY}"
    "freechains --host=localhost:${ACTIVE_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'ACTIVE BAD MESSAGE' --sign=${ACTIVE_PVTKEY}"
)

TROLL_MESSAGES=(
    "freechains --host=localhost:${TROLL_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'I AM TROLL, I ONLY HAVE BAD MESSAGE' --sign=${TROLL_PVTKEY}"
    "freechains --host=localhost:${TROLL_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'I AM TROLL, I ONLY HAVE BAD MESSAGE' --sign=${TROLL_PVTKEY}"
    "freechains --host=localhost:${TROLL_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'I AM TROLL, I ONLY HAVE BAD MESSAGE' --sign=${TROLL_PVTKEY}"
)

NEWBIE_MESSAGES=(
    "freechains --host=localhost:${NEWBIE_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'NEWBIE VIRAL MESSAGE' --sign=${NEWBIE_PVTKEY}"
    "freechains --host=localhost:${NEWBIE_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'NEWBIE NORMAL MESSAGE' --sign=${NEWBIE_PVTKEY}"
    "freechains --host=localhost:${NEWBIE_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'NEWBIE BAD MESSAGE' --sign=${NEWBIE_PVTKEY}"
)

# init simulation for around 3 months (30 iterations per month)
# everyday the host`s timestamps updated
# every 7 days the hosts are synchronized
# every 2 days pioneer post something
# every 3 days pioneer post something
# every 5 days troll post something
# every 7 days newbie post something
# like message if is viral, dislike message if is bad and do nothing if is normal message
echo "...Initializing 3 months of simulation..."
for (( i = 1; i <= 90; i++ ))
do
    echo "Day $i"
    updateHostsTimestamp $i
    synchronizeHosts

    MESSAGE_RANDOM_NUMBER=`shuf -i 0-1 -n 1` # 0 - Viral Message, 1 - Normal Message, 2 = Bad Message

    if [ $(($i % 2)) = 0 ]; then
        HASH_MESSAGE=$(eval ${PIONEER_MESSAGES[$MESSAGE_RANDOM_NUMBER]})
        giveLikeOrDislikeToPost $MESSAGE_RANDOM_NUMBER $PIONEER_HOST $HASH_MESSAGE
    fi

    if [ $(($i % 3)) = 0 ]; then
        HASH_MESSAGE=$(eval ${ACTIVE_MESSAGES[$MESSAGE_RANDOM_NUMBER]})
        giveLikeOrDislikeToPost $MESSAGE_RANDOM_NUMBER $ACTIVE_HOST $HASH_MESSAGE
    fi

    if [ $(($i % 5)) = 0 ]; then
        MESSAGE_RANDOM_NUMBER=2 # TROLL HAS ALWAYS BAD MESSAGES
        HASH_MESSAGE=$(eval ${TROLL_MESSAGES[$MESSAGE_RANDOM_NUMBER]})
        giveLikeOrDislikeToPost $MESSAGE_RANDOM_NUMBER $TROLL_HOST $HASH_MESSAGE
    fi

    if [ $(($i % 7)) = 0 ]; then
        HASH_MESSAGE=$(eval ${NEWBIE_MESSAGES[$MESSAGE_RANDOM_NUMBER]})
        giveLikeOrDislikeToPost $MESSAGE_RANDOM_NUMBER $NEWBIE_HOST $HASH_MESSAGE
    fi

    showAllUserReps
done

echo "...3 months of simulation is finished..."