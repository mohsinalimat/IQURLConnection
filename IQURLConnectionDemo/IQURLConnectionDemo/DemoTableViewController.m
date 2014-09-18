//
//  DemoTableViewController.m
//  AsyncImageView
//
//  Created by Canopus 4 on 16/09/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import "DemoTableViewController.h"
#import "DemoCollectionViewController.h"

@interface DemoTableViewController ()

@end

@implementation DemoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DifferentURL"])
    {
        DemoCollectionViewController *controller = segue.destinationViewController;
//        controller.urls = @[  //Large Images
//                            @"http://asia.olympus-imaging.com/products/dslr/e520/sample/images/sample_03.jpg",
//                            @"http://asia.olympus-imaging.com/products/dslr/e510/sample/images/sample_01.jpg",
//                            @"https://www.ricoh.com/r_dc/r/r8/img/sample_10.jpg",
//                            @"http://asia.olympus-imaging.com/products/dslr/e510/sample/images/sample_05.jpg",
//                            @"http://asia.olympus-imaging.com/products/dslr/e420/sample/images/sample_02.jpg",
//                            @"http://www.olympus-imaging.co.in/products/dslr/lenses/25_28/images/sample02.jpg",
//                            @"http://www.usa.canon.com/app/html/HDV/HR10/images/hr10_sample_image_02.jpg",
//                            @"https://www.ricoh.com/r_dc/cx/cx3/img/sample_03.jpg",
//                            @"http://www.olympus-imaging.co.in/products/compact/tough_series/tg810/images/tg810_sample02.jpg",
//                            @"https://www.ricoh.com/r_dc/cx/cx1/img/sample_04.jpg",
//                            @"http://www.olympus-imaging.co.in/products/dslr/lenses/90-250_28/images/sample02.jpg",
//                            @"http://www.fujifilmusa.com/products/digital_cameras/x/fujifilm_x_s1/sample_images/img/index/ff_x_s1_002.JPG",
//                            @"http://asia.olympus-imaging.com/products/dslr/epl1/sample/images/epl1_sample01.jpg",
//                            @"http://www.jail.se/hardware/digital_camera/canon/ixus_800is-powershot_sd700/images/sample_photos/sample1.jpg",
//                            @"http://www.ricoh-imaging.co.jp/english/r_dc/caplio/r7/img/sample_04.jpg",
//                            @"http://www.popphoto.com/files/_images/201306/k50sample1.jpg"
//                            ];
        
        controller.urls = @[    //Medium Images
                            @"http://isc.stuorg.iastate.edu/wp-content/uploads/sample.jpg",
                            @"http://res.cloudinary.com/demo/image/upload/sample.jpg",
                            @"http://upload.wikimedia.org/wikipedia/commons/1/16/HDRI_Sample_Scene_Balls_(JPEG-HDR).jpg",
                            @"http://imgsv.imaging.nikon.com/lineup/lens/zoom/normalzoom/af-s_24-85mmf_35-45g_ed_vr/img/sample/sample2_l.jpg",
                            @"http://nikonrumors.com/wp-content/uploads/2014/03/Nikon-1-V3-sample-photo.jpg",
                            @"http://imgsv.imaging.nikon.com/lineup/lens/zoom/normalzoom/af-s_dx_18-300mmf_35-56g_ed_vr/img/sample/sample4_l.jpg",
                            @"http://www.cameraegg.org/wp-content/uploads/2013/08/AF-S-DX-NIKKOR-18-140mm-f-3.5-5.6G-ED-VR-sample-images-1.jpg",
                            @"http://dcuser.net/images/nikon/d700/nikon-d700-sample-photo-17.jpg",
                            @"http://upload.wikimedia.org/wikipedia/en/9/9e/Lensbaby-sample.JPG",
                            @"http://indianapublicmedia.org/arts/files/2012/04/sample-gates-9-940x626.jpg",
                            @"http://cdn.gottabemobile.com/wp-content/uploads/2012/02/nikon-d800-sample-image-cat-head-620x507.png",
                            @"http://www.sonolta.com/sony-photos/d/1964-3/dSLR+Sample+Images",
                            @"http://cdn-4.nikon-cdn.com/en_INC/o/oLrTCTTuzYdOceunJwHWLeCyRmU/Photography/S3500_sample-photo_03.jpg",
                            @"http://cdn-4.nikon-cdn.com/en_INC/o/hf5PVfvLIjkWyg0rzAM27OIAroI/Photography/S01_sample-photo_04.jpg",
                            @"http://www.cameraegg.org/wp-content/uploads/2013/02/Nikon-D7100-Sample-Image-5.jpg",
                            @"http://4.bp.blogspot.com/-nTwks1VdWu4/UGAroalldrI/AAAAAAAALOo/SdPxvADI1vk/s1600/sample-pic-sony-w570-6.jpg"
                            ];
    }
    
    else if ([segue.identifier isEqualToString:@"SameURL"])
    {
        DemoCollectionViewController *controller = segue.destinationViewController;
        controller.urls = @[@"https://www.ricoh.com/r_dc/gx/gx200/img/sample_05.jpg",
                            @"http://asia.olympus-imaging.com/products/dslr/ep2/sample/images/ep2_sample_01.jpg",
                            @"http://www.sony.net/Products/di/common/images/products/4axb/actualphotos/photo_sample3.jpg",
                            @"http://imgsv.imaging.nikon.com/lineup/dslr/d600/img/sample01/img_05_l.jpg",
                            @"https://www.ricoh.com/r_dc/gx/gx200/img/sample_05.jpg",
                            @"http://asia.olympus-imaging.com/products/dslr/ep2/sample/images/ep2_sample_01.jpg",
                            @"http://www.sony.net/Products/di/common/images/products/4axb/actualphotos/photo_sample3.jpg",
                            @"http://imgsv.imaging.nikon.com/lineup/dslr/d600/img/sample01/img_05_l.jpg",
                            @"https://www.ricoh.com/r_dc/gx/gx200/img/sample_05.jpg",
                            @"http://asia.olympus-imaging.com/products/dslr/ep2/sample/images/ep2_sample_01.jpg",
                            @"http://www.sony.net/Products/di/common/images/products/4axb/actualphotos/photo_sample3.jpg",
                            @"http://imgsv.imaging.nikon.com/lineup/dslr/d600/img/sample01/img_05_l.jpg",
                            @"https://www.ricoh.com/r_dc/gx/gx200/img/sample_05.jpg",
                            @"http://asia.olympus-imaging.com/products/dslr/ep2/sample/images/ep2_sample_01.jpg",
                            @"http://www.cameraegg.org/wp-content/uploads/2013/02/Nikon-D7100-Sample-Image-4.jpg",
                            ];
    }
}

@end
