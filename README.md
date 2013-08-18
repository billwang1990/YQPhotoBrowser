It's a really simple photo browser. Here is a example how to use it:


    NSArray *imageArr=[NSArray arrayWithObjects:
                        @"http://125.70.12.96/media/awine/ex_chap/P33-1.png",
                        @"http://125.70.12.96/media/awine/he_in_chap/P33-5.png",
                        @"http://125.70.12.96/media/awine/tra_cert/P35-1.png",
                        @"http://125.70.12.96/media/awine/ex_in_rep/P35-2.png",
                        @"http://d.hiphotos.baidu.com/album/w%3D2048/sign=0c2a56cf77c6a7efb926af26c9c2ae51/32fa828ba61ea8d316248714960a304e251f5898.jpg",
                        nil];
    
    NSArray *text = [NSArray arrayWithObjects:@"the two array must have some count objects", @"if there isn't a description word, you can set the [NSNull null] like the next one", [NSNull null], @"ksnhk", @"good luck, billwang@gmail.com",nil];
    
    YQPhotoBrowser *vc = [[YQPhotoBrowser alloc]initWithImagesUrl:imageArr andDescription:text];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    
    Ofcoure, you can set the vc as the rootviewcontroller directly.
    
    Good luck to you
