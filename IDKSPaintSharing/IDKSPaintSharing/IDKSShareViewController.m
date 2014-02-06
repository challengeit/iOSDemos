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

typedef void (*FShare)(UIImage *);

/*!
 @discussion Definition of the class extension for IDKSShareViewController.
 */
@interface IDKSShareViewController () <MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) NSArray *shares;

@end

@implementation IDKSShareViewController

/*!
 @discussion Helper method for post the image in the desire social network.
 @param serviceName The name of the social network service.
 @return One Share block.
 */
- (Share)postInSocialNetwork:(NSString *)serviceName
{
    Share s = ^(UIImage *draw) {
        if (![SLComposeViewController isAvailableForServiceType:serviceName])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:[NSString stringWithFormat:@"please configure your %@ account in the settings", serviceName] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        SLComposeViewController *compose = [SLComposeViewController composeViewControllerForServiceType:serviceName];
        [compose setInitialText:@"DEBUG MODE..."];
        [compose addImage:draw];
        compose.completionHandler = ^(SLComposeViewControllerResult result)
        {
            NSLog(@"%@", (result == SLComposeViewControllerResultDone)? @"Posted." : @"Not Posted.");
        };
        
        [self presentViewController:compose animated:YES completion:nil];
    };
    
    return s;
}

/*!
 @discussion Getter method for shares array. Contains the blocks
 for execute each share action. Note that the order in array is important!
 @return The shares array instance.
 */
- (NSArray *)shares
{
    if (!_shares)
    {
        _shares = @[^(UIImage *draw) {
                         // Save draw in photo album.
                         UIImageWriteToSavedPhotosAlbum(draw, nil, nil, nil);
                         NSLog(@"Saved in Photos.");
                     },
                     [self postInSocialNetwork:SLServiceTypeFacebook],
                     [self postInSocialNetwork:SLServiceTypeTwitter],
                     ^(UIImage *draw) {
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
