
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)seleccionarImagen:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self 
                                                   cancelButtonTitle:@"Cancel" 
                                              destructiveButtonTitle:nil 
                                                   otherButtonTitles:@"Hacer Foto", @"Seleccionar", nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    [popupQuery release];
}

- (void)dealloc {
    [imageView release];
    [super dealloc];
}

#pragma mark - UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:self];
    
    if (buttonIndex == 0) {
        
        NSString *requieredMediaType;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        requieredMediaType = (NSString *)kUTTypeImage;
        
        controller.mediaTypes = [NSArray arrayWithObject:requieredMediaType];
        controller.allowsEditing = YES;
        
        [self presentModalViewController:controller animated:YES];
        
    } else if (buttonIndex == 1) {
        
        [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setEditing:YES];
                    
        [self presentModalViewController:controller animated:YES];
        
    }
    
    
    [controller release];
    
}

#pragma mark - UIImagePickerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage] == YES) {
        
        UIImage  *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                    
        NSFileManager *fm = [NSFileManager  defaultManager];
        
        NSTimeInterval today = [[NSDate date] timeIntervalSince1970];
        NSString *filename = [NSString stringWithFormat:@"/%f.jpg", today];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",[[[fm URLsForDirectory:NSDocumentDirectory inDomains:NSAllDomainsMask] objectAtIndex:0] path], filename];
        
        [fm createFileAtPath:filePath contents:UIImageJPEGRepresentation(image, 1.0) attributes:nil];
        
        [imageView setImage:image];

    }
    
    
    [picker dismissModalViewControllerAnimated:YES];
}

@end
