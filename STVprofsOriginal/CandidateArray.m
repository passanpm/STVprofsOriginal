/*
 Name: Philip Passntino and Tu Nguyen
 Assignment: Term Project
 Title: Single Transferable Vote
 Course: CSCE 343
 Semester: Fall, 2015
 Instructor: Dr. Reyes
 Date: 12/7/2015
 Sources consulted: Dr. Reyes, Jeff and Jordan from class
 Objective-C Programming For Dummies by Neal Goldstein and Karl Kowalski
 http://stackoverflow.com/questions/541289/objective-c-bool-vs-bool
 http://www.tutorialspoint.com/objective_c/objective_c_functions.htm
 http://stackoverflow.com/questions/2430706/how-can-we-print-different-types-of-data-types-in-objective-c
 http://code-and-coffee.blogspot.com/2012/06/objective-c-basic-data-types-and-nslog.html
 http://www.tutorialspoint.com/objective_c/objective_c_operators.htm
 http://stackoverflow.com/questions/11221902/objective-c-nsstack-and-nsqueue
 http://www.tutorialspoint.com/objective_c/objective_c_multi_dimensional_arrays.htm
 https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSMutableArray_Class/#//apple_ref/occ/instm/NSMutableArray/removeLastObject
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Strings/Articles/readingFiles.html
 http://www.techotopia.com/index.php/Working_with_Files_in_Objective-C
 https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/index.html#//apple_ref/occ/instm/NSString/stringByAppendingString:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Strings/Articles/readingFiles.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSArray_Class/#//apple_ref/occ/instm/NSArray/objectAtIndex:
 http://rypress.com/tutorials/objective-c/properties
 http://www.tutorialspoint.com/objective_c/objective_c_data_storage.htm
 http://stackoverflow.com/questions/3414644/how-to-convert-integer-to-string-in-objective-c
 https://www.youtube.com/watch?v=QPp2r8b6vBA
 https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSBundle_Class/#//apple_ref/occ/instm/NSBundle/pathForResource:ofType:
 http://stackoverflow.com/questions/695980/how-do-i-declare-class-level-properties-in-objective-c
 http://www.voting.ukscientists.com/stvcount.html
 https://svn.apache.org/repos/asf/steve/trunk/stv_background/meekm.pdf (I looked at but did not use the code on this website)
 https://en.wikipedia.org/wiki/Counting_single_transferable_votes
 https://en.wikipedia.org/wiki/Single_transferable_vote
 http://www.plu.edu/csce/staff/
 https://github.com/mattt/FormatterKit/blob/master/FormatterKit/TTTAddressFormatter.h
 https://github.com/marcransome/MRBrew/blob/master/MRBrew/MRBrew.h#L174
 https://github.com/groue/GRMustache/blob/master/src/classes/GRMustache.h
 http://nshipster.com/documentation/
 http://stackoverflow.com/questions/15172971/append-to-nstextview-and-scroll
 http://stackoverflow.com/questions/2822358/how-do-i-send-text-to-a-uitextview
 Program description: Calculates the result of a Single Transferable Vote election.
 */
#import "CandidateArray.h"
#import "RawVotes.h"
/**
 * CandidateArray is an NSMutableArray of Candidate objects. It has methods that are useful for calculating the result of a
 * SIngle Transferable Vote election.
 */
@implementation CandidateArray
/**
 * Initializes an empty array of Candidates with an initial capacity of 5.
 */
-(id) initCandidateArray{
    self = [super init];
        if (self) {
            candidates = [[NSMutableArray alloc] initWithCapacity:5];
        }
        return self;
}
/**
 * Adds a Candidate to the CandidateArray
 * @param name The Candidate to be added
 */
-(void) addCandidate: (Candidate*) name{
    [candidates addObject:name];
}
/**
 * Returns a Candidate at the specified index of the CandidateArray
 * @param first The index in the CandidateArray
 * @return the Candidate at the specified index
 */
-(Candidate*) getCandidate: (long) first{
    return [candidates objectAtIndex:first];
}
/**
 * Finds a new winner in the CandidateArray, makes that Candidate a winner, and returns the index at which that Candidate
 * was found. If no Candidate is a winner -1 is returned.
 * @param quota The quota, if a Candidate's vote total is greater than the quota that Candidate is a winner
 * @return the index at which the winning Candidate was found in the CandidateArray
 */
-(int) foundWinner: (double) quota{
    for (int i = 0; i < candidates.count; i++) {
        if ([[candidates objectAtIndex:i] getVotes] >= quota && ![[candidates objectAtIndex:i] isAWinner]) {
            [[candidates objectAtIndex:i] winner];
            return i;
        }
    }
    return -1;
}
/**
 * Redistributes the excess votes of a winner and removes the name of the winner in the RawVotes object b.
 * @param quota The amount of votes needed to be a winner
 * @param b A RawVotes object used for redistributing votes
 * @param w The index that the winner is at in the CandidateArray
 * @return the Candidate who is at index w in the CandidateArray
 */
-(Candidate*) redistributeVotes: (double) quota RawVotesObject: (RawVotes*) b indexOfWinner: (int) w{
    
    double winnerNumOfVotes = 0.0;
    for (long j = 0; j < [b numOfVoters] ; j++) {
        if ([[b getAtIndex:j secondArgument:0] isEqualToString:[[candidates objectAtIndex:w] getName]]){
            winnerNumOfVotes++;
        }
    }
    
    double excessVotes = [[candidates objectAtIndex:w] getVotes] - quota;
    double voteValue = excessVotes/winnerNumOfVotes;
    [[candidates objectAtIndex:w] addVote: -excessVotes];
    for (long j = 0; j < [b numOfVoters] ; j++) {
        if ([[b getAtIndex:j secondArgument:0] isEqualToString:[[candidates objectAtIndex:w] getName]]){
            [b eliminateAtIndex:j secondArgument:0];
            NSString *temp = [b getAtIndex:j secondArgument:0];
            for( int k = 0; k < candidates.count; k++){
                if([[[candidates objectAtIndex:k] getName] isEqualToString:temp]){
                    [[candidates objectAtIndex:k] addVote:voteValue];
                    break;
                }
            }
            }
    }
    Candidate *theWinner = [candidates objectAtIndex:w];
    [b eliminateAllInstances:[[candidates objectAtIndex:w] getName]];
    return theWinner;
}
/**
 * Finds the candidate with the lowest amount of votes in the CandidateArray, redistributes their votes, eliminates the
 * Candidate from the RawVotes object b and the CandidateArray, and returns the name of the Candidate who was defeated.
 * @param b A RawVotes object used for redistributing votes
 * @return the name of the Candidate who was defeated
 */
-(NSString*) findAndEliminateLoser: (RawVotes*) b{
    int lowest = 0;
    for (int i = 1; i <candidates.count; i++) {
        if ([[candidates objectAtIndex:i] getVotes] < [[candidates objectAtIndex:lowest] getVotes]) {
            lowest = i;
        }
    }
    double loserNumOfVotes = 0.0;
    for (long j = 0; j < [b numOfVoters] ; j++) {
        if ([[b getAtIndex:j secondArgument:0] isEqualToString:[[candidates objectAtIndex:lowest] getName]]){
            loserNumOfVotes++;
        }
    }
    double loserVoteValue = [[candidates objectAtIndex:lowest] getVotes]/loserNumOfVotes;
    for (long j = 0; j < [b numOfVoters] ; j++) {
        if ([[b getAtIndex:j secondArgument:0] isEqualToString:[[candidates objectAtIndex:lowest] getName]]){
            [b eliminateAtIndex:j secondArgument:0];
            NSString *temp = [b getAtIndex:j secondArgument:0];
            for( int k = 0; k < candidates.count; k++){
                if([[[candidates objectAtIndex:k] getName] isEqualToString:temp]){
                    [[candidates objectAtIndex:k] addVote:loserVoteValue];
                    break;
                }
            }
        }
    }
    NSString *returnValue = [[candidates objectAtIndex:lowest] getName];
    [b eliminateAllInstances:[[candidates objectAtIndex:lowest] getName]];
    [candidates removeObject:[candidates objectAtIndex:lowest]];
    return returnValue;
}
/**
 * Returns the number of Candidates in the CandidateArray.
 * @return the number of Candidates in the CandidateArray
 */
-(long) numOfCandidates{
    return candidates.count;
}
/**
 * Returns the number of winners in the CandidateArray.
 * @return the number of winners in the CandidateArray
 */
-(int) numOfWinners{
    int howManyWinners = 0;
    for (int i = 0; i < candidates.count; i++) {
        if ([[candidates objectAtIndex:i] isAWinner]) {
            howManyWinners++;
        }
    }
    return howManyWinners;
}
    
@end
