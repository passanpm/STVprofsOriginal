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

#import <Foundation/Foundation.h>
#import "Candidate.h"
#import "RawVotes.h"
#import "CandidateArray.h"
/**
 * Counts the votes recorded in the RawVotes object and updates the Candidates vote totals who are in the CandidateArray.
 * @param t The RawVotes object
 * @param r the CandidateArray
 */
void countVotes(RawVotes *t, CandidateArray *r);
/**
 * Prints out the name and amount of votes each Candidate has in the CandidateArray
 * @param A The CandidateArray to print out
 */
void printOutResults(CandidateArray *A);

/**
 * This is main, where the action happens.
 */
int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        //These are all the Candidates running in this election. Do their names sound familiar?
        Candidate *blaha = [[Candidate alloc] initCandidate:@"Blaha"];
        Candidate *dijkstra = [[Candidate alloc] initCandidate:@"Dijkstra"];
        Candidate *hauser = [[Candidate alloc] initCandidate:@"Hauser"];
        Candidate *murphy = [[Candidate alloc] initCandidate:@"Murphy"];
        Candidate *wolff = [[Candidate alloc] initCandidate:@"Wolff"];
        
        //Initialize a CandidateArray and add all the Candidates who are running to it.
        CandidateArray *running = [[CandidateArray alloc] initCandidateArray];
        [running addCandidate: blaha];
        [running addCandidate: dijkstra];
        [running addCandidate: hauser];
        [running addCandidate: murphy];
        [running addCandidate: wolff];
        
        //This CandidateArray will hold the winners of this election.
        CandidateArray *winners = [[CandidateArray alloc] initCandidateArray];
        
        //Initialize a RawVotes object
        RawVotes *b = [[RawVotes alloc] initRawVotes:@"/test3.txt"];
        
        //Count the votes
        countVotes(b, running);
        
        //The seats to be won in this election
        double seats = 3.0;
        
        //Quota = (total number of voters/(seats to be won + 1))
        double quota = ([b numOfVoters]/(seats+1.0));
        
        //Print out the quota
        NSLog(@"The quota to get elected is: %f", quota);
        //NSLog(@"", quota);
        
        //Print out the results of the first round
        printOutResults(running);
        
        while ([running numOfWinners] < seats) {
            int winnerIndex = [running foundWinner:quota];
            //if a Candidate meets the quota
            if (winnerIndex >= 0) {
                //redistribute the winner's excess votes
                Candidate *theWinner = [running redistributeVotes:quota RawVotesObject:b indexOfWinner:winnerIndex];
                //Declare the Candidate a winner
                [winners addCandidate: theWinner];
                //Print out the winner found this round.
                //NSLog([theWinner getName]);
                NSLog(@"%@ has been elected.",[theWinner getName] );
                if([running numOfWinners] < seats){
                //Print out the results of the round, unless all the winners have already been found
                printOutResults(running);
                }
            }
            //if no Candidate meets the quota
            else{
                //Redistribute all of the defeated Candidates votes
                NSString *temp = [running findAndEliminateLoser:b];
                //Print out the name of the Candidate defeated this round.
                //NSLog(temp);
                NSLog(@"%@ was eliminated.", temp);
                //Print out the results of the round
                printOutResults(running);
            }
        }
        //Print out all the winners in this election
        NSLog(@"The winners are:");
        for (long x = 0; x < [winners numOfCandidates]; x++) {
                NSLog([[winners getCandidate:x] getName]);
        }
        
        return 0;
    }
}
/**
 * Counts the votes recorded in the RawVotes object and updates the Candidates vote totals who are in the CandidateArray.
 * @param t The RawVotes object
 * @param r the CandidateArray
 */
void countVotes(RawVotes *t, CandidateArray *r){
    for (long j = 0; j < [r numOfCandidates]; j++) {
        for (long i = 0; i < [t numOfVoters]; i++) {
            if ([[t getAtIndex:i secondArgument:0] isEqualToString:[[r getCandidate:j] getName]]){
                [[r getCandidate:j] addVote:1];
            }
        }
    }
}
/**
 * Prints out the name and amount of votes each Candidate has in the CandidateArray
 * @param A The CandidateArray to print out
 */
void printOutResults(CandidateArray *A){
    @autoreleasepool {
        for (int i = 0; i < [A numOfCandidates]; i++) {
           // NSLog([[A getCandidate:i] getName]);
            NSLog(@"%@ has %f votes.", [[A getCandidate:i] getName], [[A getCandidate:i] getVotes] );
            /*NSLog(@"%f",[[A getCandidate:i] getVotes]);
            NSLog(@"votes."); */
        }
        NSLog(@"\n");
    }
}

