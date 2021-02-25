Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF283254FB
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 18:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhBYR5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 12:57:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233242AbhBYR4a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 12:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614275703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IyIvq1GfEQ2PqGVKSEXomSQN6J1/9Sf0bgGXJLS7atg=;
        b=jOQB5Q99T/MFrljaM0cRO1+YquA4jB/jMRt2r57XWQXUoXQl+hozgjgTUe4c+B3iV4uILM
        5CJ2blsaOvweDQ4ZSdnO+aW22fr+J20UtOk6ngjrkzHuwvPhdHBTARIHTNDKJgYiwvqI5m
        AvMSbW9Q/HlRV2MAdvc35pQcsbDVE/Y=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-qVItqVGsMYOUHSOiMOQ5Og-1; Thu, 25 Feb 2021 12:55:00 -0500
X-MC-Unique: qVItqVGsMYOUHSOiMOQ5Og-1
Received: by mail-qt1-f199.google.com with SMTP id b7so4622630qtj.16
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 09:55:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IyIvq1GfEQ2PqGVKSEXomSQN6J1/9Sf0bgGXJLS7atg=;
        b=NIn8XpCFndCQgHprtbLrVil5exM6efM5Mb2B+34MBMzQeGtVwyXKEOzYbU579dvVJp
         p+57NP8dKRvufwNwm48nk43kYVsxCD1FEe012yKzfyPYw+Z5uMQbmuKSgQetQvLtM/Yk
         qetxk8WZvEUyCCK5Jy+36IK07qLV+gQNOg9RHoe1yc1+5X93HW+JTkfdVTFkeqbsxhYh
         ihStzBI0uc+PJ5wpLtSqm6r3S6Et/5A55gXRaPFjLROsx/yJ2jYLiwJOCCRgWoL1UQGN
         RXJK/E4ut33h/arKueku6r1DQMZltnqR5PaR56UylzTxaJd1LXuxnPywzYBO/DDq0D+9
         oL5A==
X-Gm-Message-State: AOAM533h5NOERsi//yr631iHw/5ZfnZqfhIkZpatllDDO+c0NDTOM7D9
        4RHlgWsZs5dHomQ2xFk7bzc80bihshJ0wHyxLfRVJKgGUNTFKbOuf3R/yxKZyDIMMeGayJ8onYb
        iyYuJMSDI83xC
X-Received: by 2002:a37:a945:: with SMTP id s66mr3877064qke.272.1614275699656;
        Thu, 25 Feb 2021 09:54:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgzhNPTv29Ls5uj1DyeOOVM8HTCfzoOfLXiEEzsAqvbc/Keh+rqfXheRUc/Vee/FRoEgc8pw==
X-Received: by 2002:a37:a945:: with SMTP id s66mr3877046qke.272.1614275699300;
        Thu, 25 Feb 2021 09:54:59 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id q6sm4359046qkd.41.2021.02.25.09.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 09:54:58 -0800 (PST)
Date:   Thu, 25 Feb 2021 12:54:57 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 10/10] vfio/type1: Register device notifier
Message-ID: <20210225175457.GD250483@xz-x1>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401275279.16443.6350471385325897377.stgit@gimli.home>
 <20210222175523.GQ4247@nvidia.com>
 <20210224145508.1f0edb06@omen.home.shazbot.org>
 <20210225002216.GQ4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210225002216.GQ4247@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 08:22:16PM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 24, 2021 at 02:55:08PM -0700, Alex Williamson wrote:
> 
> > > > +static bool strict_mmio_maps = true;
> > > > +module_param_named(strict_mmio_maps, strict_mmio_maps, bool, 0644);
> > > > +MODULE_PARM_DESC(strict_mmio_maps,
> > > > +		 "Restrict to safe DMA mappings of device memory (true).");  
> > > 
> > > I think this should be a kconfig, historically we've required kconfig
> > > to opt-in to unsafe things that could violate kernel security. Someone
> > > building a secure boot trusted kernel system should not have an
> > > options for userspace to just turn off protections.
> > 
> > It could certainly be further protected that this option might not
> > exist based on a Kconfig, but I think we're already risking breaking
> > some existing users and I'd rather allow it with an opt-in (like we
> > already do for lack of interrupt isolation), possibly even with a
> > kernel taint if used, if necessary.
> 
> Makes me nervous, security should not be optional.
> 
> > > I'd prefer this was written a bit differently, I would like it very
> > > much if this doesn't mis-use follow_pte() by returning pfn outside
> > > the lock.
> > > 
> > > vaddr_get_bar_pfn(..)
> > > {
> > >         vma = find_vma_intersection(mm, vaddr, vaddr + 1);
> > > 	if (!vma)
> > >            return -ENOENT;
> > >         if ((vma->vm_flags & VM_DENYWRITE) && (prot & PROT_WRITE)) // Check me
> > >            return -EFAULT;
> > >         device = vfio_device_get_from_vma(vma);
> > > 	if (!device)
> > >            return -ENOENT;
> > > 
> > > 	/*
> > >          * Now do the same as vfio_pci_mmap_fault() - the vm_pgoff must
> > > 	 * be the physical pfn when using this mechanism. Delete follow_pte entirely()
> > >          */
> > >         pfn = (vaddr - vma->vm_start)/PAGE_SIZE + vma->vm_pgoff
> > > 	
> > >         /* de-dup device and record that we are using device's pages in the
> > > 	   pfnmap */
> > >         ...
> > > }
> > 
> > 
> > This seems to undo both:
> > 
> > 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")
> 
> No, the bug this commit described is fixed by calling
> vfio_device_get_from_vma() which excludes all non-VFIO VMAs already.
> 
> We can assert that the vm_pgoff is in a specific format because it is
> a VFIO owned VMA and must follow the rules to be part of the address
> space. See my last email
> 
> Here I was suggesting to use the vm_pgoff == PFN rule, but since
> you've clarified that doesn't work we'd have to determine the PFN from
> the region number through the vfio_device instead.
> 
> > (which also suggests we are going to break users without the module
> > option opt-in above)
> 
> Not necessarily, this is complaining vfio crashes, it doesn't say they
> actually needed the IOMMU to work on those VMAs because they are doing
> P2P DMA.
> 
> I think, if this does break someone, they are on a real fringe and
> must have already modified their kernel, so a kconfig is the right
> approach. It is pretty hard to get non-GUP'able DMA'able memory into a
> process with the stock kernel.
> 
> Generally speaking, I think Linus has felt security bug fixes like
> this are more on the OK side of things to break fringe users.
> 
> > And:
> > 
> > 41311242221e ("vfio/type1: Support faulting PFNMAP vmas")
> > 
> > So we'd have an alternate path in the un-safe mode and we'd lose the
> > ability to fault in mappings.
> 
> As above we already exclude VMAs that are not from VFIO, and VFIO
> sourced VMA's do not meaningfully implement fault for this use
> case. So calling fixup_user_fault() is pointless.
> 
> Peter just did this so we could ask him what it was for..
> 
> I feel pretty strongly that removing the call to follow_pte is
> important here. Even if we do cover all the issues with mis-using the
> API it just makes a maintenance problem to leave it in.

I can't say I fully understand the whole rational behind 5cbf3264bc71, but that
commit still sounds reasonable to me, since I don't see why VFIO cannot do
VFIO_IOMMU_MAP_DMA upon another memory range that's neither anonymous memory
nor vfio mapped MMIO range.  In those cases, vm_pgoff namespace defined by vfio
may not be true anymore, iiuc.

Then if with that follow_pfn() for non-vfio mappings, it seems also very
reasonable to have 41311242221e or similar as proposed by Alex to make sure pte
installed before calling that, for either vfio or other vma providers.

Or does it mean that we don't want to allow VFIO dma to those unknown memory
backends, for some reason?

Thanks,

-- 
Peter Xu

