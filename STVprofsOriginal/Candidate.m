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

#import "Candidate.h"
/**
 * Candidate is a representation of a candidate running in an election
 */
@implementation Candidate
/**
 * Initializes a Candidate with the given name and default values for the other fields.
 * @param inputName The name for the candidate.
 */
-(id) initCandidate: (NSString*) inputName{
    if (self = [super init]) {
        name = inputName;
        won = NO;
        votes = 0.0;
    }
    return self;
}
/**
 * Returns the Candidate's name.
 * @return name The name of the candidate.
 */
-(NSString*) getName{
    return name;
}
/**
 * Returns the Candidate's amount of votes.
 * @return votes The amount of the candidate's votes.
 */
-(double) getVotes{
    return votes;
}
/**
 * Adds the given amount of votes to the candidate's total.
 * @param value The amount of votes to add to the candidate's total.
 */
-(void) addVote: (double) value{
    votes = votes + value;
}
/**
 * Sets the candidate's winner status to YES.
 */
-(void) winner{
    won = YES;
}
/**
 * Returns whether the candidate is a winner.
 * @return won YES if candidate is a winner, NO if the candidate is not a winner.
 */
-(BOOL) isAWinner{
    return won;
}
@end