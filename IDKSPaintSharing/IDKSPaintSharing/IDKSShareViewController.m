//
//  IDKSShareViewController.m
//  IDKSPaintSharing
//
//  Created by Ricardo Sousa on 28/11/13.
//  Copyright (c) 2013 ChallengeIT. All rights reserved.
//

#import "IDKSShareViewController.h"
#import <Social/Social.h>
#import <Social/SLComposeViewController.h>
#import <MessageUI/MessageUI.h>

typedef void (^Share)(UIImage *);

/*!
 @discussion Definition of the class extension for IDKSShareViewController.
 */
@interface IDKSShareViewController () <MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) NSArray *shares;

@end

@implementation IDKSShareViewController

/*!
 @discussion Getter method for shares array. Contains the blocks 
 for execute each share action. Note that the order in array is important!
 @return The shares array instance.
 */
- (NSArray *)shares
{
    if (!_shares)
    {
        _shares = @[^(UIImage *draw)
                     {
                         // Save draw in photo album.
                         UIImageWriteToSavedPhotosAlbum(draw, nil, nil, nil);
                         NSLog(@"Saved in Photos.");
                     },
                    ^(UIImage *draw)
                     {
                         // Try post in Facebook.
                         if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
                         {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"please configure your FB account in the settings" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                             [alert show];
                             return;
                         }
                         
                         SLComposeViewController *fbCompose = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                         [fbCompose setInitialText:@"DEBUG MODE..."];
                         [fbCompose addImage:draw];
                         fbCompose.completionHandler = ^(SLComposeViewControllerResult result)
                         {
                             NSLog(@"%@", (result == SLComposeViewControllerResultDone)? @"Posted in FB." : @"Not Posted in FB.");
                         };
                         
                         [self presentViewController:fbCompose animated:YES completion:nil];
                     },
                     ^(UIImage *draw)
                     {
                         // Try post in Twitter.
                         if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                         {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"please configure your Twitter account in the settings" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                             [alert show];
                             return;
                         }
                         
                         SLComposeViewController *twitterCompose = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                         [twitterCompose setInitialText:@"DEBUG MODE..."];
                         [twitterCompose addImage:draw];
                         twitterCompose.completionHandler = ^(SLComposeViewControllerResult result)
                         {
                             NSLog(@"%@", (result == SLComposeViewControllerResultDone)? @"Posted in Twitter." : @"Not Posted in Twitter.");
                         };

                         [self presentViewController:twitterCompose animated:YES completion:nil];
                     },
                     ^(UIImage *draw)
                     {
                         // Send an e-mail with the draw.
                         MFMailComposeViewController *mailcontroller = [[MFMailComposeViewController alloc] init];
                         [mailcontroller setMailComposeDelegate:self];
                         [mailcontroller setSubject:@"See my new draw!"];
                         [mailcontroller addAttachmentData:UIImagePNGRepresentation(draw) mimeType:@"image/png" fileName:@"draw"];
                         [self presentViewController:mailcontroller animated:YES completion:nil];
                     }
                    ];
    }
    
    return _shares;
}

/*!
 @discussion tableView method override, for make the action of the selected shared
 option.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.draw)
        NSLog(@"you are crazy!");
    
    Share share = [self.shares objectAtIndex:indexPath.row];
    share(self.draw);
}

#pragma mark - MFMailComposeControllerDelegate methods.
/*!
 @discussion Because the simulator can not send the email, we override this method to see if email was sent correctly.
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"e-mail cancelled.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"e-mail saved.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"e-mail sent.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"e-mail failed [%@].", (error)? error.localizedDescription : @"");
            break;
        default: break;
    }
    
    // Dismiss the mail controller and go back to share table.
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
