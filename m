Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE0F5AF47F
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 21:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiIFTiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 15:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIFTiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 15:38:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26E39A9D2
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 12:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662493095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JKGNkNlKsgdRE1IUnqehupjYBIRQhjyCm+5wxoZ9iLk=;
        b=MasgCEUQAkOBr8wjGzrYPRvPyLSR6lLfzmJl8dyGI7tHc81wmFddyNfLULaeS8cyk8SlUW
        IKNNuxxiRaniNtbMCA1p7WV0ui0okiEaBk07cN2uuZcp+INHkTZlAEsFgqm7N1UASLvNxK
        0z6Urtv1NddzlVBZxWVtfwdiWEtg5PM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-Qujii73xPUCVuxszGdhNeA-1; Tue, 06 Sep 2022 15:38:14 -0400
X-MC-Unique: Qujii73xPUCVuxszGdhNeA-1
Received: by mail-il1-f199.google.com with SMTP id d6-20020a056e020be600b002dcc7977592so10260255ilu.17
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 12:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=JKGNkNlKsgdRE1IUnqehupjYBIRQhjyCm+5wxoZ9iLk=;
        b=8NCmdzsZUNx1Yhs215fEsQfPbAvTaA5ErclHzlmxd632O4Uesr2I14VBEarNLeJpka
         ecfQUID/yxSwPvF5KHN0kkf36FdYACHoLs7OSCnLrdNObvV1n3lI0YTMkVC/EcoUlLwy
         7sHoufFbxhf3IOEHrZBhKowitGsx5/neizu+mclbmlFOUS0r78JqPN+PDHLSddVCIoL/
         +Z3eUAjNk3qrCLB8XwQXDLtr2E35Wut8PtFMF+W2TClW9kZtnSZ2GhThAUkkRsuOHZGF
         gkd0fwDmoNdu5sjuedfPVkNonBmBjQWldWSdMyJzz4YOCbMgEQfarMNjpRpB9TTfTMex
         K1Ww==
X-Gm-Message-State: ACgBeo1nptey0l0lB/zhZ6O3Dp3T0SlVe9O5T6sfqwTa2xY6GRVQqHQI
        tNtb7Hvdck9ncAatnRWV1IHYlLuqmJ9esCkgteS9DJUSE1IlddlcrGuy2HMCiB0QmMd6lS+JTQu
        51z8ReD6W5W3A
X-Received: by 2002:a05:6e02:164f:b0:2f1:9d98:3899 with SMTP id v15-20020a056e02164f00b002f19d983899mr58539ilu.3.1662493093708;
        Tue, 06 Sep 2022 12:38:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6t2NwMAjssWwnmRgD4Qf7LGQnvbn2csU5cUDg0RM3OTLbmcKnljIoV7KHJ9rG2DmRBnZpjlg==
X-Received: by 2002:a05:6e02:164f:b0:2f1:9d98:3899 with SMTP id v15-20020a056e02164f00b002f19d983899mr58530ilu.3.1662493093371;
        Tue, 06 Sep 2022 12:38:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y12-20020a056602048c00b00669a3f60e99sm6385582iov.31.2022.09.06.12.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 12:38:13 -0700 (PDT)
Date:   Tue, 6 Sep 2022 13:38:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Message-ID: <20220906133811.16031613.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276FCB0DCB4E741CCCD48318C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
        <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
        <BN9PR11MB52767A4CCD5C7B0E70F0BA2C8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
        <YxFOPUaab8DZH9v8@nvidia.com>
        <BN9PR11MB5276122C4CBAACB295DD15E78C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220902083934.7e6f6438.alex.williamson@redhat.com>
        <YxIuTF0qfy8c3cDj@nvidia.com>
        <BN9PR11MB5276FCB0DCB4E741CCCD48318C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Sep 2022 03:35:48 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, September 3, 2022 12:25 AM
> > 
> > On Fri, Sep 02, 2022 at 08:39:34AM -0600, Alex Williamson wrote:  
> > > On Fri, 2 Sep 2022 03:51:01 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > >  
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Friday, September 2, 2022 8:29 AM
> > > > >
> > > > > On Wed, Aug 31, 2022 at 08:46:30AM +0000, Tian, Kevin wrote:  
> > > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > > Sent: Wednesday, August 31, 2022 9:02 AM
> > > > > > >
> > > > > > > To vfio_container_detatch_group(). This function is really a  
> > container  
> > > > > > > function.
> > > > > > >
> > > > > > > Fold the WARN_ON() into it as a precondition assertion.
> > > > > > >
> > > > > > > A following patch will move the vfio_container functions to their  
> > own .c  
> > > > > > > file.
> > > > > > >
> > > > > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > > ---
> > > > > > >  drivers/vfio/vfio_main.c | 11 +++++------
> > > > > > >  1 file changed, 5 insertions(+), 6 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > > > > > index bfa6119ba47337..e145c87f208f3a 100644
> > > > > > > --- a/drivers/vfio/vfio_main.c
> > > > > > > +++ b/drivers/vfio/vfio_main.c
> > > > > > > @@ -928,12 +928,13 @@ static const struct file_operations  
> > vfio_fops = {  
> > > > > > >  /*
> > > > > > >   * VFIO Group fd, /dev/vfio/$GROUP
> > > > > > >   */
> > > > > > > -static void __vfio_group_unset_container(struct vfio_group *group)
> > > > > > > +static void vfio_container_detatch_group(struct vfio_group *group)  
> > > > > >
> > > > > > s/detatch/detach/  
> > > > >
> > > > > Oops
> > > > >  
> > > > > > Given it's a vfio_container function is it better to have a container  
> > pointer  
> > > > > > as the first parameter, i.e.:
> > > > > >
> > > > > > static void vfio_container_detatch_group(struct vfio_container  
> > *container,  
> > > > > > 		struct vfio_group *group)  
> > > > >
> > > > > Ah, I'm not so sure, it seems weird to make the caller do
> > > > > group->container then pass the group in as well.
> > > > >
> > > > > This call assumes the container is the container of the group, it
> > > > > doesn't work in situations where that isn't true.  
> > > >
> > > > Yes, this is a valid interpretation on doing this way.
> > > >
> > > > Other places e.g. iommu_detach_group(domain, group) go the other way
> > > > even if internally domain is not used at all. I kind of leave that pattern
> > > > in mind thus raised this comment. But not a strong opinion.
> > > >  
> > > > >
> > > > > It is kind of weird layering in a way, arguably we should have the
> > > > > current group stored in the container if we want things to work that
> > > > > way, but that is a big change and not that wortwhile I think.
> > > > >
> > > > > Patch 7 is pretty much the same, it doesn't work right unless the
> > > > > container and device are already matched
> > > > >  
> > > >
> > > > If Alex won't have a different preference and with the typo fixed,  
> > >
> > > I don't get it, if a group is detaching itself from a container, why
> > > isn't it vfio_group_detach_container().  Given our naming scheme,
> > > vfio_container_detach_group() absolutely implies the args Kevin
> > > suggests, even if they're redundant.  vfio_foo_* functions should
> > > operate on a a vfio_foo object.  
> > 
> > Look at the overall picture. This series moves struct vfio_container
> > into a .c file and then pulls all of the code that relies on it into
> > the c file too.
> > 
> > With our current function layout that results in these cut points:
> > 
> > struct vfio_container *vfio_container_from_file(struct file *filep);
> > int vfio_container_use(struct vfio_group *group);
> > void vfio_container_unuse(struct vfio_group *group);
> > int vfio_container_attach_group(struct vfio_container *container,
> > 				struct vfio_group *group);
> > void vfio_container_detach_group(struct vfio_group *group);
> > void vfio_container_register_device(struct vfio_device *device);
> > void vfio_container_unregister_device(struct vfio_device *device);
> > long vfio_container_ioctl_check_extension(struct vfio_container *container,
> > 					  unsigned long arg);
> > int vfio_container_pin_pages(struct vfio_device *device, dma_addr_t iova,
> > 			     int npage, int prot, struct page **pages);
> > void vfio_container_unpin_pages(struct vfio_device *device, dma_addr_t
> > iova,
> > 				int npage);
> > int vfio_container_dma_rw(struct vfio_device *device, dma_addr_t iova,
> > 			  void *data, size_t len, bool write);
> > 
> > Notice almost none of them use container as a function argument. The
> > container is always implied by another object that is linked to the
> > container.
> > 
> > Yet these are undeniably all container functions because they are only
> > necessary when the container code is actually being used. Every one of
> > this functions is bypassed if iommmufd is used. I even have a patch
> > that just replaces them all with nops if container and type 1 is
> > compiled out.
> > 
> > So, this presents two possiblities for naming. Either we call
> > everything in container.c vfio_container because it is primarily
> > related to the container.c *system*, or we label each function
> > according to OOP via the first argument type (vfio_XX_YY_container
> > perhaps) and still place them in container.c.
> > 
> > Keep in mind I have plans to see a group.c and rename vfio_main.c to
> > device.c, so having a vfio_group or vfio_device function in
> > container.c seems to get confusing.  
> 
> IMHO I don't see a big difference between two naming options if the
> first parameter is kept as group or device object.
> 
> > 
> > In other words, I prefer to think of the group of functions above as
> > the exported API of the vfio container system (ie container.c) - not in
> > terms of an OOP modeling of a vfio_container object.
> >   
> 
> After reading above IMHO the OOP modeling wins a bit as far as
> readability is concerned. Probably just my personal preference
> but having most vfio_maintaier_xxx() helpers w/o explicitly providing
> a vfio_maintainer object does affect my reading of related code.
> 
> At least vfio_XX_YY_container makes me feel better if we want to
> avoid duplicating a vfio_maintainer object, e.g.:
> 
> struct vfio_container *vfio_container_from_file(struct file *filep);
> int vfio_group_use_container(struct vfio_group *group);
> void vfio_group_unuse_container(struct vfio_group *group);
> int vfio_group_attach_container(struct vfio_group *group,
> 				vfio_container *container);
> void vfio_group_detach_container(struct vfio_group *group);
> void vfio_device_register_container(struct vfio_device *device);
> void vfio_device_unregister_container(struct vfio_device *device);
> long vfio_container_ioctl_check_extension(struct vfio_container *container,
> 					  unsigned long arg);
> int vfio_pin_pages_container(struct vfio_device *device, dma_addr_t iova,
> 			     int npage, int prot, struct page **pages);
> void vfio_unpin_pages_container(struct vfio_device *device, dma_addr_t
> iova,
> 				int npage);
> int vfio_dma_rw_container(struct vfio_device *device, dma_addr_t iova,
> 			  void *data, size_t len, bool write);
> 
> They are all container related. So although the first parameter is not
> container we put them in container.c as the last word in the function
> name is container.

I might refine these to:

struct vfio_container *vfio_container_from_file(struct file *filep);

int vfio_group_use_container(struct vfio_group *group);
void vfio_group_unuse_container(struct vfio_group *group);

int vfio_container_attach_group(struct vfio_container *container,
				struct vfio_group *group);
void vfio_group_detach_container(struct vfio_group *group);

void vfio_device_container_register(struct vfio_device *device);
void vfio_device_container_unregister(struct vfio_device *device);

long vfio_container_ioctl_check_extension(struct vfio_container *container,
 					  unsigned long arg);

int vfio_device_pin_container_pages(struct vfio_device *device, dma_addr_t iova,
				    int npage, int prot, struct page **pages);
void vfio_device_unpin_container_pages(struct vfio_device *device, dma_addr_t
				       iova, int npage);

int vfio_device_dma_rw_container(struct vfio_device *device, dma_addr_t iova,
				 void *data, size_t len, bool write);

Overall, I'm still not really on board with sacrificing a "the name
tells you how to use it" API in order to break down devices, groups,
and containers into their own subsystems.  We should not only consider
the logical location of the function, but the usability and
intuitiveness of the API.

Are we necessarily finding the right splits here?  The {un}use,
{un}pin, and dma_rw in particular seem like they could be decomposed
further.  For example a vfio_group intermediary that calls
vfio_container_{un}use() with a vfio_container object.  Or a
vfio_device intermediary that can call vfio_container_ functions for
{un}pin/rw, also with a container object.  Thanks,

Alex

